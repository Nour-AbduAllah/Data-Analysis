from os import sep
import numpy as np
import seaborn as sns
import matplotlib
import matplotlib.pylab as plt
import pandas as pd

sns.set_style("darkgrid")
matplotlib.rcParams["font.size"] = 14
matplotlib.rcParams["figure.figsize"] = (9, 5)
matplotlib.rcParams["figure.facecolor"] = "#00000000"

public_fname = "stackoverflow-developer-survey-2020/survey_results_public.csv"
survey_raw_df = pd.read_csv(public_fname)

schema_fname = "stackoverflow-developer-survey-2020/survey_results_schema.csv"
survey_result_schema = pd.read_csv(schema_fname, index_col="Column")
schema_raw = survey_result_schema["QuestionText"]

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
# Let's extract a copy of the data from these columns into a new data frame, which we can continue to modify further
# without affecting the original data frame
survey_df = survey_raw_df[selected_columns].copy()
print("# of unique values:", survey_df["Country"].nunique())

top_countries = survey_df["Country"].value_counts().head(15)
print("Top Countries:", top_countries, sep="\n")


plt.figure("Countries", figsize=(12, 6))
plt.xticks(rotation=50)
plt.title(schema_raw["Country"])
sns.barplot(x=top_countries.index, y=top_countries)
# plt.show()

plt.figure("Age", figsize=(12, 6))
plt.title(schema_raw["Age"])
plt.xlabel("Age")
plt.ylabel("Number of respondents")
plt.hist(survey_df["Age"], bins=np.arange(10, 80, 5), color="purple")

survey_df.where(
    ~(survey_df["Gender"].str.contains(";", na=False)), np.nan, inplace=True
)
# gender_counts = survey_df["Gender"].value_counts(dropna=False)
gender_counts = survey_df["Gender"].value_counts()

plt.figure("Gender", figsize=(12, 6))
plt.title(schema_raw["Gender"])
plt.pie(gender_counts, labels=gender_counts.index, autopct="%1.1f%%", startangle=180)

# Education level
plt.figure("Education", figsize=(12, 6))
sns.countplot(y=survey_df["EdLevel"])
plt.xticks(rotation=75)
plt.yticks(rotation=75)
plt.title(schema_raw["EdLevel"])
plt.ylabel(None)

undergrade_pct = (
    survey_df["UndergradMajor"].value_counts()
    * 100
    / survey_df["UndergradMajor"].count()
)
plt.figure("Undergrade")
sns.barplot(x=undergrade_pct, y=undergrade_pct.index)
plt.title(schema_raw["UndergradMajor"])
plt.ylabel(None)
plt.xlabel("Precentage")

# Employment
plt.figure("Employment", figsize=(10, 5))
(survey_df["Employment"].value_counts(normalize=True, ascending=True) * 100).plot(
    kind="barh", color="g"
)
plt.title(schema_raw["Employment"])
plt.xlabel("Precentage")

# DevType
# This field contains info about the roles held by respondents.
# Scince the question allows multiple answers, the column contains lists of values separated by (;),
# which make it harder to analyze directly.
def split_multiColumn(col_series):
    result_df = col_series.to_frame()
    options = []
    # Iterate ove the column
    for index, value in col_series[col_series.notnull()].iteritems():
        # Break each value into list of options
        for option in value.split(";"):
            # Add the option as a column to result
            if not option in result_df.columns:
                options.append(option)
                result_df[option] = False
                pass
            # Mark the value in the option column as True
            result_df.at[index, option] = True
            pass
        pass
    return result_df[options]


dev_type_df = split_multiColumn(survey_df["DevType"])
# print(dev_type_df)
dev_type_totals = dev_type_df.sum().sort_values(ascending=False)
# print(dev_type_totals)
plt.show()
