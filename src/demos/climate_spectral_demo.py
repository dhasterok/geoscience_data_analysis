from __future__ import annotations

import sys
from pathlib import Path
from typing import Optional

import matplotlib.pyplot as plt
import pandas as pd

ROOT_DIR = Path(__file__).resolve().parents[2]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from src.analysis import compute_fft, compute_spectrogram, compute_wavelet_transform
from src.io import (
    list_station_files,
    load_temperature_series,
    parse_station_list,
    station_id_from_path,
)
from src.plotting import plot_fourier_spectrum, plot_spectrogram, plot_time_series, plot_wavelet_scalogram


def station_label(station_meta: Optional[pd.Series], station_id: Optional[str] = None) -> str:
    if station_meta is None:
        return f"Station ID: {station_id or 'unknown'}"
    name = station_meta.get("STATION_NAME", "Unknown station")
    lat = station_meta.get("LATITUDE")
    lon = station_meta.get("LONGITUDE")
    elev = station_meta.get("ELEVATION")
    fields = [f"ID: {station_id or station_meta.get('ID', 'unknown')}", f"{name}"]
    if pd.notna(lat) and pd.notna(lon):
        fields.append(f"Lat {lat:.4f}, Lon {lon:.4f}")
    if pd.notna(elev):
        fields.append(f"Elev {elev:.1f} m")
    return " | ".join(fields)


class StationNavigator:
    def __init__(self, data_dir: Path, station_list_path: Path) -> None:
        self.data_dir = data_dir
        self.station_files = list_station_files(data_dir)
        self.station_files.sort()
        self.metadata = parse_station_list(station_list_path).set_index("ID")
        if not self.station_files:
            raise FileNotFoundError(f"No station files found in {data_dir}")
        self.current_index = 0

        self.fig, self.axes = plt.subplots(3, 1, figsize=(14, 14))
        self.fig.canvas.mpl_connect("key_press_event", self.on_key_press)
        self.fig.suptitle("", fontsize=14, weight="bold")
        self.render()
        self.fig.tight_layout(rect=[0, 0, 1, 0.96])
        plt.show()

    def on_key_press(self, event: plt.backend_bases.KeyEvent) -> None:
        if event.key in {"right", "pagedown"}:
            self.current_index = (self.current_index + 1) % len(self.station_files)
            self.render()
        elif event.key in {"left", "pageup"}:
            self.current_index = (self.current_index - 1) % len(self.station_files)
            self.render()
        elif event.key in {"q", "escape"}:
            plt.close(self.fig)

    def render(self) -> None:
        station_file = self.station_files[self.current_index]
        station_id = station_id_from_path(station_file)
        station_meta = self.metadata.loc[station_id] if station_id in self.metadata.index else None
        try:
            series = load_temperature_series(
                station_file,
                element="TAVG",
                max_gap=5,
                start_date="1980-01-01",
                end_date="2023-12-31",
            )
            message = None
        except ValueError as error:
            series = pd.Series(dtype=float)
            message = str(error)

        for ax in self.axes:
            ax.cla()

        title = station_meta["STATION_NAME"] if station_meta is not None else station_file.stem
        if not series.empty:
            time_range = f"{series.index.min().date()} to {series.index.max().date()}"
            metadata_text = f"{station_label(station_meta, station_id)} | Range: {time_range}"
        else:
            metadata_text = f"{station_label(station_meta, station_id)}"
            if message is not None:
                metadata_text = f"{metadata_text} | {message}"

        plot_time_series(
            series,
            title=title,
            metadata_text=metadata_text,
            ax=self.axes[0],
        )

        if not series.empty:
            spectrum = compute_fft(series.dropna())
            plot_fourier_spectrum(
                spectrum,
                title="Fourier power spectrum",
                ax=self.axes[1],
                max_period_years=2.0,
                n_peaks=5,
            )

            frequencies, times, Sxx = compute_spectrogram(series.dropna(), window_days=365, overlap_days=335)
            plot_spectrogram(
                frequencies,
                times,
                Sxx,
                title="Time-varying Fourier spectrogram",
                ax=self.axes[2],
            )
        else:
            self.axes[1].text(
                0.5,
                0.5,
                "No Fourier data available",
                transform=self.axes[1].transAxes,
                fontsize=12,
                ha="center",
                va="center",
                color="tab:red",
            )
            self.axes[2].text(
                0.5,
                0.5,
                "No spectrogram data available",
                transform=self.axes[2].transAxes,
                fontsize=12,
                ha="center",
                va="center",
                color="tab:red",
            )

        self.fig.suptitle(
            f"Station {self.current_index + 1}/{len(self.station_files)} ({station_id}): {title}",
            fontsize=14,
            weight="bold",
        )
        self.fig.canvas.draw_idle()


def main() -> None:
    root = Path(__file__).resolve().parents[2]
    data_dir = root / "data" / "climate"
    station_list_path = data_dir / "ghcnd-stations.txt"
    if not station_list_path.exists():
        raise FileNotFoundError(f"Station list file not found at {station_list_path}")

    StationNavigator(data_dir=data_dir, station_list_path=station_list_path)


if __name__ == "__main__":
    main()
