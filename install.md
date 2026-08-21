# Installation

## Requirements

- Python 3.10 or newer
- Internet access for `src/scraping/bom_scraper.py`

## macOS or Linux

From the repository root, create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install the Python dependencies:

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Windows PowerShell

From the repository root, create and activate a virtual environment:

```powershell
py -m venv .venv
.venv\Scripts\Activate.ps1
```

Install the Python dependencies:

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Verify the installation

Run this from the repository root while the virtual environment is active:

```bash
python -c "import bs4, lxml, matplotlib, numpy, pandas, requests, scipy; print('Dependencies installed successfully')"
```

## Run the climate spectral demo

```bash
python -m src.demos.climate_spectral_demo
```

The demo reads the station data in `data/climate/` and opens an interactive Matplotlib window. Use the left and right arrow keys to change stations, and `q` or `Esc` to close the window.

## Run the Bureau of Meteorology scraper

```bash
python src/scraping/bom_scraper.py
```

The scraper requires internet access, requests data for the configured station and year range, and saves `adelaide_station_023011_daily_temps.csv` in the current working directory.
