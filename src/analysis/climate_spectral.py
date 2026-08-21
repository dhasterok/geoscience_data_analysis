from __future__ import annotations

from typing import Iterable, Optional

import numpy as np
import pandas as pd
from scipy import signal


def _to_numpy(series: pd.Series) -> np.ndarray:
    values = series.to_numpy(dtype=float)
    if np.any(np.isnan(values)):
        raise ValueError("Input series must have no missing values for spectral analysis.")
    return values


def _morlet2(M: int, s: float, w: float = 6.0) -> np.ndarray:
    t = np.arange(-M // 2, M // 2 + (M % 2))
    x = t / s
    wavelet = np.exp(1j * w * x) * np.exp(-0.5 * x ** 2)
    norm = (np.pi ** -0.25) * np.sqrt(1.0 / s)
    return norm * wavelet


def _cwt_custom(y: np.ndarray, widths: np.ndarray, w: float = 6.0) -> np.ndarray:
    from scipy.signal import fftconvolve

    result = np.zeros((len(widths), len(y)), dtype=np.complex128)
    for idx, width in enumerate(widths):
        M = max(1, int(round(10.0 * width)))
        if M % 2 == 0:
            M += 1
        wavelet = _morlet2(M, width, w=w)
        result[idx, :] = fftconvolve(y, wavelet, mode="same")
    return result


def compute_fft(
    series: pd.Series,
    sampling_interval: float = 1.0,
    detrend: bool = True,
    window: Optional[str] = "hann",
) -> pd.DataFrame:
    """Compute the Fourier magnitude and power spectrum for a daily series."""
    y = _to_numpy(series)
    if detrend:
        y = signal.detrend(y)
    n = len(y)
    if window is None:
        weights = np.ones(n)
    elif window == "hann":
        weights = np.hanning(n)
    else:
        raise ValueError(f"Unsupported window type: {window}")
    y_windowed = y * weights
    fft_values = np.fft.rfft(y_windowed)
    frequencies = np.fft.rfftfreq(n, d=sampling_interval)
    power = np.abs(fft_values) ** 2
    amplitude = np.abs(fft_values) / n
    period_days = np.full_like(frequencies, np.nan, dtype=float)
    positive = frequencies > 0
    period_days[positive] = 1.0 / frequencies[positive]
    result = pd.DataFrame(
        {
            "frequency": frequencies,
            "period_days": period_days,
            "period_years": period_days / 365.24,
            "amplitude": amplitude,
            "power": power,
        }
    )
    return result


def compute_spectrogram(
    series: pd.Series,
    window_days: int = 365,
    overlap_days: int = 335,
    sampling_interval: float = 1.0,
    detrend: bool = True,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Compute a time-varying Fourier spectrogram for daily data."""
    if overlap_days >= window_days:
        raise ValueError("overlap_days must be smaller than window_days")
    y = _to_numpy(series)
    if detrend:
        y = signal.detrend(y)
    fs = 1.0 / sampling_interval
    noverlap = int(overlap_days)
    nperseg = int(window_days)
    frequencies, times, Sxx = signal.spectrogram(
        y,
        fs=fs,
        window="hann",
        nperseg=nperseg,
        noverlap=noverlap,
        mode="magnitude",
    )
    return frequencies, times, Sxx


def compute_wavelet_transform(
    series: pd.Series,
    periods: Optional[Iterable[float]] = None,
    wavelet_center_frequency: float = 6.0,
    sampling_interval: float = 1.0,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Compute a continuous wavelet transform for daily temperature data."""
    y = _to_numpy(series)
    if periods is None:
        periods = np.concatenate(
            [np.arange(2, 31, 1), np.arange(31, 92, 2), np.arange(92, 365, 7), np.arange(365, 730, 14)]
        )
    periods = np.asarray(periods, dtype=float)
    scales = periods * wavelet_center_frequency / (2.0 * np.pi)
    cwt_matrix = _cwt_custom(y, scales, w=wavelet_center_frequency)
    power = np.abs(cwt_matrix) ** 2
    return power, periods, series.index.to_numpy()
