import opendatasets as od
import os
import pandas as pd
import numpy as np

# While the survey responses contain a wealth of info, we'll limit our analysis to following areas:
#   -Demographics of the survey respondents & global programming community
#   -Distribution of programming skills, experiences an preferences
#   -Employment-related info, preferences and opinions

public_fname = "stackoverflow-developer-survey-2020/survey_results_public.csv"
survey_raw_df = pd.read_csv(public_fname)
# print(survey_raw_df)
# print(survey_raw_df.columns)

schema_fname = "stackoverflow-developer-survey-2020/survey_results_schema.csv"
survey_result_schema = pd.read_csv(schema_fname, index_col="Column")

# Let's select a subset of columns with the relevant data for our analysis.
selected_columns = [
    # Demographics
    "Country",
    "Age",
    "Gender",
    "EdLevel",
    "UndergradMajor",
    # Programming experince
    "Hobbyist",
    "Age1stCode",
    "YearsCode",
    "YearsCodePro",
    "LanguageWorkedWith",
    "LanguageDesireNextYear",
    "NEWLearn",
    "NEWStuck",
    # Employment
    "Employment",
    "DevType",
    "WorkWeekHrs",
    "JobSat",
    "JobFactors",
    "NEWOvertime",
    "NEWEdImpt",
]
print("# of selected columns:", len(selected_columns))
# Let's extract a copy of the data from these columns into a new data frame, which we can continue to modify further
# without affecting the original data frame
survey_df = survey_raw_df[selected_columns].copy()
print("\nSurvey data frame shape:", survey_df.shape)
print("\nSurvey data frame info:")
print(survey_df.info())

# Show the unique values of Age1stCode
# print(survey_df["Age1stCode"].unique())


# To ignore the errors of values that is not numeric
survey_df["Age1stCode"] = pd.to_numeric(survey_df["Age1stCode"], errors="coerce")
survey_df["YearsCode"] = pd.to_numeric(survey_df["YearsCode"], errors="coerce")
survey_df["YearsCodePro"] = pd.to_numeric(survey_df["YearsCodePro"], errors="coerce")

# Let's now view some basic statistics about the numeric columns
print("\n\nDescription:")
print(survey_df.describe())
# You will notice that there are some errors in Age column, as min = 1, max = 279
# A simple fix would be ignore the rows where the value in the age column is higher than 100 years or
# lower than 10 years. This can be done using the (.drop()) method.
survey_df.drop(survey_df[survey_df["Age"] < 10].index, inplace=True)
survey_df.drop(survey_df[survey_df["Age"] > 100].index, inplace=True)
survey_df.drop(survey_df[survey_df["Age1stCode"] > 100].index, inplace=True)
survey_df.drop(survey_df[survey_df["Age1stCode"] < 10].index, inplace=True)
survey_df.drop(survey_df[survey_df["YearsCode"] > 100].index, inplace=True)
survey_df.drop(survey_df[survey_df["YearsCodePro"] > 100].index, inplace=True)
survey_df.drop(survey_df[survey_df["WorkWeekHrs"] > 168].index, inplace=True)


# The gender column also allows picking multiple options, but to simplify our analysis,
# we'll remove values containing more than one option

# Before
# print(survey_df["Gender"].unique())
# print(survey_df["Gender"].value_counts())

survey_df.where(
    ~(survey_df["Gender"].str.contains(";", na=False)), np.nan, inplace=True
)

# After
# print(survey_df["Gender"].unique())
# print(survey_df["Gender"].value_counts())
