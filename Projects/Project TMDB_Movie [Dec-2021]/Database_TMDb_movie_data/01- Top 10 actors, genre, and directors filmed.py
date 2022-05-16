from types import NoneType
import pandas as pd
import matplotlib.pylab as plt
import seaborn as sns

df = pd.read_csv("tmdb_movies_cleaned.csv")

df["release_date"] = pd.to_datetime(df["release_date"])


def reform_column(s):
    """
    Takes a dataframe column as series and split every row to find unique values
    and their count

    INPUT:
        s: pandas.Series
            series as data to reform
    OUTPUT:
        pandas series from dictionary of unique values and their count
    """

    # Empty dictionary to store values in it.
    uni_dict = {}
    # Loop over given series to get all values in it
    for item in s:
        # Split each column to extract all values.
        for value in item.split("|"):
            # If value is unique and new, store it and assign its value by 1.
            if value not in uni_dict:
                uni_dict[value] = 1
            # If stored, increase it by one to know how many times did it repeat.
            else:
                uni_dict[value] += 1
    # Convert our dictionary to series and return it.
    return pd.Series(uni_dict)


def genres_in_year(df):
    """
    Function gets all genres in each year.
    INPUT:
        df: pandas.DataFrame
            Source of data to get genres in year
    OUTPUT: pandas.DataFrame
        dataframe of years and genres
    """
    # get all unique years
    years = df["release_year"].unique()
    # sort years ascending
    years.sort()

    # Empty dataframe to values inside
    result_df = pd.DataFrame(columns=["release_year", "genre"])

    # loop over years
    for year in years:
        # get all year genres
        release_year_filter = df.query("release_year == {}".format(year))["genres"]
        for year_genres in release_year_filter:
            # Split each year genres
            for genre in year_genres.split("|"):
                # Add splitted genres in the year
                result_df = result_df.append(
                    {"release_year": year, "genre": genre}, ignore_index=True
                )
    return result_df


def complex_in_year(df, column):
    """
    Function gets all complex data column in each year.
    INPUT:
        df: pandas.DataFrame
            Source of data to get complex data in year
        column: str
            complex column name to split
    OUTPUT: pandas.DataFrame
        dataframe of years and extracted data from column
    """
    if column not in df.columns:
        return None
    # get all unique years.
    years = df["release_year"].unique()
    # sort years ascending.
    years.sort()

    # Empty dataframe to values inside.
    result_df = pd.DataFrame(columns=["release_year", column, "vote_average"])

    # loop over years.
    for year in years:
        # get all data in current year
        release_year_filter = df.query("release_year == {}".format(year))[
            [column, "vote_average"]
        ]
        for year_genre, year_vote in zip(
            release_year_filter[column], release_year_filter["vote_average"]
        ):
            # Split each year row.
            for value in year_genre.split("|"):
                # Add splitted values from row in the year.
                result_df = result_df.append(
                    {"release_year": year, column: value, "vote_average": year_vote},
                    ignore_index=True,
                )
    return result_df


def sort_dict_of_dict(d):
    """
    Sorting Values in dictionary of dictionary

    INPUT:
        d: Dictionary
            dictionary years of dictionary of genres

    OUTPUT:
        Sorted dictionary of diactionary
    """
    # Sort genres count in genres dictionary
    for year in d.keys():
        d[year] = dict(sorted(d[year].items(), key=lambda x: x[1], reverse=True))
    return d


def year_filter(df, filter_from=None, filter_to=None):
    """
    Filters our data frame respect to specific years.

    INPUT:
        df (Optional): pandas.DataFrame
            data to filter it.
        filter_from (Optional): int
            value to start filter from it, if None then no lower limit will be applied.
        filter_to (optional): int
            value to stop filter to it, if None the no upper limit will be apllied.
    OUTPUT:
        filterd data frame by given limits.
    """

    # If no limits were given
    if not filter_from and not filter_to:
        # No filter
        return df
    # If lower limit was given
    elif filter_from and not filter_to:
        # Apply filter
        df = df[filter_from <= df["release_year"]]
        pass
    # If upper limit was given
    elif not filter_from and filter_to:
        # Apply filter
        df = df[df["release_year"] <= filter_to]
        pass
    # If both limits were given
    else:
        # If lower limit is greater from the upper, then awap them
        if filter_from > filter_to:
            filter_from, filter_to = filter_to, filter_from
        # Apply filter
        df = df[df["release_year"].between(filter_from, filter_to)]
    return df


def genre_count(df):
    unique_genres = df["genre"].unique()
    result = {}
    for genre in unique_genres:
        print(genre)
        result[genre] = df[df["genre"] == genre]["genre"].value_counts()
    # result = dict(sorted(result.items(), key=lambda x: x[1], reverse=True))
    return result


directors = reform_column(df["director"].copy()).sort_values(
    ascending=False, inplace=False
)
actors = reform_column(df["cast"].copy()).sort_values(ascending=False, inplace=False)
genres = reform_column(df["genres"].copy()).sort_values(ascending=False, inplace=False)


print("Top 20 Actors:", actors.head(20), sep="\n")
print("-" * 50)
print("Top 20 Directors:", directors.head(20), sep="\n")
print("-" * 50)
print("Top 20 Genres:", genres.head(20), sep="\n")

print(
    "Filter from {} to {}:".format(df["release_year"].min(), df["release_year"].max())
)
# df = year_filter(df, filter_from=2015, filter_to=2015)
print(df)
# print(df.groupby("release_year")["genres"].value_counts())
# year_genres_df = genres_in_year(df)
# year_genres_df.to_csv("year_genres.csv", index=False)
# year_genres_df = pd.read_csv("year_genres.csv")
# genres_df = genre_count(year_genres_df)
# print(genres_df)
# print(genres_in_year(df)[2015])
# print(year_genres_df["genre"].value_counts().plot(kind="bar"))
# directors_df = complex_in_year(df, "director")
# directors_df.to_csv("year_directors.csv", index=False)
print(complex_in_year(df, "genres"))
