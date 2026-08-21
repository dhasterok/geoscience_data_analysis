from __future__ import annotations

from datetime import datetime
from typing import Optional

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import signal


def plot_time_series(
    series: pd.Series,
    title: Optional[str] = None,
    metadata_text: Optional[str] = None,
    ax: Optional[plt.Axes] = None,
) -> plt.Axes:
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 4))
    ax.set_title(title or "Daily temperature series")
    if series.empty:
        ax.text(
            0.5,
            0.5,
            "No temperature data available",
            transform=ax.transAxes,
            fontsize=12,
            ha="center",
            va="center",
            color="tab:red",
        )
    else:
        ax.plot(series.index, series.values, color="tab:blue", lw=1)
    if metadata_text is not None:
        ax.text(
            0.01,
            0.98,
            metadata_text,
            transform=ax.transAxes,
            fontsize=9,
            va="top",
            ha="left",
            bbox={"facecolor": "white", "alpha": 0.8, "edgecolor": "none"},
        )
    ax.set_xlabel("Date")
    ax.set_ylabel(series.name or "Temperature")
    ax.grid(alpha=0.35)
    return ax


def plot_fourier_spectrum(
    spectrum: pd.DataFrame,
    title: Optional[str] = None,
    ax: Optional[plt.Axes] = None,
    max_period_years: Optional[float] = 2.0,
    n_peaks: int = 5,
    min_prominence_db: Optional[float] = None,
) -> plt.Axes:
    if ax is None:
        fig, ax = plt.subplots(figsize=(10, 5))
    spectrum = spectrum.copy().dropna(subset=["period_days", "period_years"])
    if "period_years" not in spectrum.columns:
        spectrum["period_years"] = spectrum["period_days"] / 365.24
    mask = spectrum["period_years"] <= max_period_years
    spectrum = spectrum.loc[mask].copy()
    if spectrum.empty:
        raise ValueError("No spectrum values in the requested period range.")

    eps = np.finfo(float).tiny
    spectrum["power_db"] = 10.0 * np.log10(np.maximum(spectrum["power"], eps))
    ax.plot(spectrum["period_years"], spectrum["power_db"], color="tab:red")

    power_db = spectrum["power_db"].to_numpy()
    if min_prominence_db is None:
        min_prominence_db = max(1.0, np.max(power_db) * 0.05)
    peaks, properties = signal.find_peaks(power_db, prominence=min_prominence_db)
    if len(peaks) > 0:
        peak_values = power_db[peaks]
        top_indices = np.argsort(peak_values)[-n_peaks:][::-1]
        for idx in top_indices:
            peak_ix = peaks[idx]
            year = spectrum["period_years"].iat[peak_ix]
            value = power_db[peak_ix]
            ax.plot(year, value, marker="o", color="black", ms=4)
            ax.text(
                year,
                value,
                f"{year:.2f} yr",
                fontsize=8,
                ha="left",
                va="bottom",
                rotation=45,
            )

    ax.set_xscale("log")
    ax.set_xlabel("Period (years)")
    ax.set_ylabel("Power (dB)")
    ax.set_title(title or "Fourier power spectrum")
    ax.grid(which="both", alpha=0.3)
    ax.invert_xaxis()
    return ax


def plot_spectrogram(
    frequencies: np.ndarray,
    times: np.ndarray,
    Sxx: np.ndarray,
    title: Optional[str] = None,
    ax: Optional[plt.Axes] = None,
) -> plt.Axes:
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 5))
    t = times
    f = frequencies
    mesh = ax.pcolormesh(t, f, Sxx, shading="auto", cmap="viridis")
    ax.set_title(title or "Fourrogram (time-varying Fourier magnitude)")
    ax.set_xlabel("Time (days)")
    ax.set_ylabel("Frequency (cycles per day)")
    plt.colorbar(mesh, ax=ax, label="Magnitude")
    return ax


def plot_wavelet_scalogram(
    dates: np.ndarray,
    periods: np.ndarray,
    power: np.ndarray,
    title: Optional[str] = None,
    ax: Optional[plt.Axes] = None,
) -> plt.Axes:
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 6))
    x = dates
    y = periods
    mesh = ax.pcolormesh(x, y, power, shading="auto", cmap="magma")
    ax.set_yscale("log")
    ax.set_ylabel("Period (days)")
    ax.set_xlabel("Date")
    ax.set_title(title or "Wavelet power scalogram")
    plt.colorbar(mesh, ax=ax, label="Power")
    return ax
