from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Iterable, Optional

import numpy as np
import pandas as pd

GHCN_COLUMNS = ["ID", "DATE", "ELEMENT", "VALUE", "MFLAG", "QFLAG", "SFLAG", "OBS_TIME"]
TEMPERATURE_ELEMENTS = {"TAVG", "TMIN", "TMAX"}
STATION_LIST_COLSPEC = [(0, 11), (11, 20), (20, 30), (30, 37), (41, 71)]
STATION_LIST_COLUMNS = ["ID", "LATITUDE", "LONGITUDE", "ELEVATION", "STATION_NAME"]


def list_station_files(data_dir: Path | str) -> list[Path]:
    data_dir = Path(data_dir)
    return sorted(data_dir.glob("*.csv"))


def parse_station_list(file_path: Path | str) -> pd.DataFrame:
    file_path = Path(file_path)
    if not file_path.exists():
        raise FileNotFoundError(f"Station list file not found: {file_path}")
    df = pd.read_fwf(
        file_path,
        colspecs=STATION_LIST_COLSPEC,
        names=STATION_LIST_COLUMNS,
        dtype={"ID": str, "LATITUDE": str, "LONGITUDE": str, "ELEVATION": str, "STATION_NAME": str},
        comment=None,
        header=None,
    )
    df["STATION_NAME"] = df["STATION_NAME"].astype(str).str.rstrip()
    df["LATITUDE"] = pd.to_numeric(df["LATITUDE"], errors="coerce")
    df["LONGITUDE"] = pd.to_numeric(df["LONGITUDE"], errors="coerce")
    df["ELEVATION"] = pd.to_numeric(df["ELEVATION"], errors="coerce")
    df.loc[df["ELEVATION"] == -999.9, "ELEVATION"] = pd.NA
    return df


def station_metadata(file_path: Path | str, station_id: str) -> pd.Series:
    df = parse_station_list(file_path)
    row = df[df["ID"] == station_id]
    if row.empty:
        raise KeyError(f"Station ID not found in station list: {station_id}")
    return row.iloc[0]


def parse_ghcn_daily(file_path: Path | str, start_date: Optional[str] = None, end_date: Optional[str] = None) -> pd.DataFrame:
    file_path = Path(file_path)
    raw = pd.read_csv(
        file_path,
        header=None,
        names=GHCN_COLUMNS,
        dtype={"ID": str, "DATE": str, "ELEMENT": str, "VALUE": str, "MFLAG": str, "QFLAG": str, "SFLAG": str, "OBS_TIME": str},
        na_values=["", "-9999"],
        keep_default_na=False,
    )
    raw["DATE"] = pd.to_datetime(raw["DATE"], format="%Y%m%d", errors="coerce")
    if start_date is not None:
        raw = raw[raw["DATE"] >= pd.to_datetime(start_date)]
    if end_date is not None:
        raw = raw[raw["DATE"] <= pd.to_datetime(end_date)]
    return raw


def _convert_temperature_value(element: str, value: pd.Series) -> pd.Series:
    if element in TEMPERATURE_ELEMENTS:
        return value.astype(float) / 10.0
    return value.astype(float)


def _build_full_index(series: pd.Series, start_date: Optional[str], end_date: Optional[str]) -> pd.DatetimeIndex:
    if start_date is None:
        start_date = series.index.min()
    if end_date is None:
        end_date = series.index.max()
    return pd.date_range(start=pd.to_datetime(start_date), end=pd.to_datetime(end_date), freq="D")


def _interpolate_small_gaps(series: pd.Series, max_gap: int) -> pd.Series:
    if max_gap is None or max_gap < 1:
        return series
    filled = series.copy()
    interpolated = series.interpolate(method="time")
    na_groups = (series.isna() != series.isna().shift()).cumsum()
    gap_sizes = series.isna().groupby(na_groups).transform("sum")
    small_gap_mask = series.isna() & (gap_sizes <= max_gap)
    filled.loc[small_gap_mask] = interpolated.loc[small_gap_mask]
    return filled


def load_temperature_series(
    file_path: Path | str,
    element: str = "TAVG",
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    max_gap: int = 3,
    fill_method: str = "linear",
) -> pd.Series:
    """Load a daily temperature series from a GHCN daily station file.

    Parameters:
        file_path: Path to a GHCN station CSV file.
        element: Desired element code, typically TAVG, TMIN, or TMAX.
        start_date: Optional start date for the returned series.
        end_date: Optional end date for the returned series.
        max_gap: Maximum consecutive missing days to fill by interpolation.
        fill_method: Currently only "linear" is supported.

    Returns:
        A daily pandas Series indexed by date. Temperature values are in degrees Celsius.
    """
    file_path = Path(file_path)
    df = parse_ghcn_daily(file_path, start_date=start_date, end_date=end_date)
    if df.empty:
        raise ValueError(f"No records found in {file_path}")

    def element_series(element_code: str) -> pd.Series:
        subset = df[df["ELEMENT"] == element_code].copy()
        if subset.empty:
            return pd.Series(dtype=float)
        subset["VALUE"] = pd.to_numeric(subset["VALUE"], errors="coerce")
        result = subset.set_index("DATE")["VALUE"]
        result.index = pd.to_datetime(result.index)
        return result

    if element == "TAVG":
        tavg = element_series("TAVG")
        if tavg.empty:
            tmin = element_series("TMIN")
            tmax = element_series("TMAX")
            if not tmin.empty and not tmax.empty:
                combined = pd.concat([tmin, tmax], axis=1)
                combined.columns = ["TMIN", "TMAX"]
                tavg = (combined["TMIN"] + combined["TMAX"]) / 2.0
            elif not tmin.empty:
                tavg = tmin
            else:
                tavg = tmax
    else:
        tavg = element_series(element)

    if tavg.empty:
        raise ValueError(f"Element {element} not found in {file_path}")

    tavg = _convert_temperature_value(element if element != "TAVG" else "TAVG", tavg)
    index = _build_full_index(tavg, start_date, end_date)
    series = tavg.reindex(index)
    if fill_method == "linear":
        series = _interpolate_small_gaps(series, max_gap)
    return series.rename(file_path.stem)


def station_id_from_path(file_path: Path | str) -> str:
    return Path(file_path).stem
