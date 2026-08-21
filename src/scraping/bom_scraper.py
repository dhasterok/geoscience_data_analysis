import requests
import pandas as pd
from bs4 import BeautifulSoup
import time

STATION = "023011"
START_YEAR = 1900   # adjust as needed
END_YEAR = 2026

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Referer": "https://www.bom.gov.au/",
    "Accept-Language": "en-US,en;q=0.5",
}

OBS_CODE_MAP = {
    "tmax": "122",
    "maximum temperature": "122",
    "maxtemp": "122",
    "tmin": "123",
    "minimum temperature": "123",
    "mintemp": "123",
    "tavg": "124",
    "temperature": "124",
    "mean temperature": "124",
    "average temperature": "124",
    "avg temperature": "124",
    "t": "124",
}

CANONICAL_VAR_NAME = {
    "tmax": "Tmax",
    "maximum temperature": "Tmax",
    "Maximum Temperature": "Tmax",
    "maxtemp": "Tmax",
    "tmin": "Tmin",
    "minimum temperature": "Tmin",
    "Minimum Temperature": "Tmin",
    "mintemp": "Tmin",
    "tavg": "Tavg",
    "temperature": "Tavg",
    "mean temperature": "Tavg",
    "average temperature": "Tavg",
    "avg temperature": "Tavg",
    "t": "Tavg",
}

def fetch_year(year, var):
    """
    var = 'Tmax' or 'Tmin' or aliases such as
    'Maximum Temperature', 'Minimum Temperature', 'Tavg', or 'Temperature'.
    """
    base = "https://www.bom.gov.au/jsp/ncc/cdio/weatherData/av"

    var_key = str(var).strip().lower()
    obs_code = OBS_CODE_MAP.get(var_key)
    if obs_code is None:
        supported = ", ".join(sorted(set(OBS_CODE_MAP.keys())))
        raise ValueError(f"Unknown variable '{var}'. Supported values: {supported}")

    output_var = CANONICAL_VAR_NAME[var_key]

    params = {
        "p_nccObsCode": obs_code,
        "p_display_type": "dailyDataFile",
        "p_startYear": year,
        "p_c": "0",
        "p_stn_num": STATION
    }

    r = requests.get(base, params=params, headers=HEADERS, timeout=30)
    r.raise_for_status()

    # parse HTML table
    soup = BeautifulSoup(r.text, "html.parser")

    table = soup.find("table")
    if table is None:
        page_title = soup.title.string.strip() if soup.title and soup.title.string else "Unknown page"
        print(f"No data for {year} {output_var} ({page_title})")
        return None

    df = pd.read_html(str(table))[0]

    # reshape from wide (months) to long
    df = df.melt(id_vars=['Day'], var_name='Month', value_name=output_var)

    # drop NaNs
    df = df.dropna(subset=[output_var])

    # convert Month names to numbers if needed
    month_map = {m: i for i, m in enumerate(
        ['Jan','Feb','Mar','Apr','May','Jun',
         'Jul','Aug','Sep','Oct','Nov','Dec'], start=1)}

    df['Month'] = df['Month'].map(month_map)
    df['Year'] = year

    # build date
    df['Date'] = pd.to_datetime(
        dict(year=df['Year'], month=df['Month'], day=df['Day']),
        errors='coerce'
    )

    return df[['Date', var]]


def build_dataset():
    all_data = []

    for year in range(START_YEAR, END_YEAR + 1):
        print(f"Processing {year}...")
        try:
            tmax = fetch_year(year, 'Tmax')
            tmin = fetch_year(year, 'Tmin')

            if tmax is None and tmin is None:
                continue

            if tmax is None:
                tmax = pd.DataFrame(columns=['Date', 'Tmax'])
            if tmin is None:
                tmin = pd.DataFrame(columns=['Date', 'Tmin'])

            df = pd.merge(tmax, tmin, on='Date', how='outer')
            all_data.append(df)

            time.sleep(1)  # be polite to BoM servers

        except Exception as e:
            print(f"Error in {year}: {e}")

    if not all_data:
        return pd.DataFrame(columns=['Date', 'Tmax', 'Tmin'])

    return pd.concat(all_data, ignore_index=True).sort_values('Date')


if __name__ == "__main__":
    df = build_dataset()

    df.to_csv("adelaide_station_023011_daily_temps.csv", index=False)

    print("Done. Saved to CSV.")