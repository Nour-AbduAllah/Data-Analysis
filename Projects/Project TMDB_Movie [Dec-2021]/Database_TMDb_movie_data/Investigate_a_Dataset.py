from numpy.core.fromnumeric import mean
import pandas as pd
import numpy as np
import matplotlib.pylab as plt

df = pd.read_csv("tmdb-movies.csv")

# print("Data frame shape:", df.shape)
# print("\nData frame info:")
# print(df.info())
# print("\nData frame describtion:", df.describe(), sep="\n")


def reform_column(s):
    dict = {}

    for item in s:
        for value in item.split("|"):
            if value not in dict:
                dict[value] = 1
            else:
                dict[value] += 1
    return pd.Series(dict)


def year_filter(df, filter_from=None, filter_to=None):
    if not filter_from and not filter_to:
        # No filter
        pass
    elif filter_from and not filter_to:
        df = df[filter_from <= df["release_year"]]
        pass
    elif not filter_from and filter_to:
        df = df[df["release_year"] <= filter_to]
        pass
    else:
        if filter_from > filter_to:
            filter_from, filter_to = filter_to, filter_from
        df = df[df["release_year"].between(filter_from, filter_to)]
    return df


columns_to_drop = [
    "imdb_id",
    "homepage",
    "tagline",
    "keywords",
    "overview",
    "production_companies",
    "budget_adj",
    "revenue_adj",
]

df.drop(columns_to_drop, axis=1, inplace=True)

# # remove rows with budget and revenue of 0 value
# df = df[df["budget"] != 0]
# df = df[df["revenue"] != 0]
df.dropna(axis=0, inplace=True)
df.drop_duplicates(inplace=True)

# directors = reform_column(df["director"].copy()).sort_values(
#     ascending=False, inplace=False
# )
# actors = reform_column(df["cast"].copy()).sort_values(ascending=False, inplace=False)
# genres = reform_column(df["genres"].copy()).sort_values(ascending=False, inplace=False)

# df.drop(["cast", "director, "], axis=1, inplace=True)


df.to_csv("tmdb_movies_cleaned.csv", index=False)
df["release_date"] = pd.to_datetime(df["release_date"])

print("Data frame shape:", df.shape)
print("\nData frame info:")
print(df.info())
print("\nData frame describtion:", df.describe(), sep="\n")
print("\nData frame uniques:", df.nunique(), sep="\n")
print("\nData frame duplicates:", df.duplicated().sum(), sep="\n")
