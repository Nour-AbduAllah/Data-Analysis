from os import sep
from matplotlib.pyplot import figure
import numpy as np
import seaborn as sns
import matplotlib
import matplotlib.pylab as plt
import pandas as pd


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


sns.set_style("darkgrid")
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


# Question 1: What is the most popular programming language in 2020?
languages_worked_df = split_multiColumn(survey_df["LanguageWorkedWith"])

# Use the mean to get the Falses out
languages_worked_with_precntage = (
    languages_worked_df.mean().sort_values(ascending=False) * 100
)
print(languages_worked_with_precntage)

plt.figure("Languages", figsize=(13, 6))
sns.barplot(x=languages_worked_with_precntage, y=languages_worked_with_precntage.index)
plt.xlabel("count")
# plt.show()

# Answer 1: JavaScript

# Question 2: Which languages are the most people interested to learn over the next year?
language_interested_df = split_multiColumn(survey_df["LanguageDesireNextYear"])
language_interested_precentage = (
    language_interested_df.mean().sort_values(ascending=False) * 100
)
# print(language_interested_precentage)
# Answer 2: Python, Js, HTML, CSS, ...

# Question 3: Which are the most loved languages i.e. a high precentage of people who have used the language want
# to continue learning and using it over the next year?
language_loved_df = languages_worked_df & language_interested_df
language_loved_precentage = (
    language_loved_df.sum() * 100 / languages_worked_df.sum()
).sort_values(ascending=False)
# print("\n\nThe Most Loved Languages:", language_loved_precentage, sep="\n")
# Answer 3: Rust, TypeScript, Python, ....


# Question 4: In which countries do developers work the highest number of hours per week? Consider contries with
# more the 250 responses only.
countries_df = (
    survey_df.groupby("Country")[["WorkWeekHrs"]]
    .mean()
    .sort_values("WorkWeekHrs", ascending=False)
)
high_response_contries_df = countries_df.loc[
    survey_df["Country"].value_counts() > 250
].head(15)
# print("\n\nHigh Response Contries", high_response_contries_df, sep="\n")


# Question 5: How important id it to start young to build a career in programming?
survey_df["YearsCodePro"] = pd.to_numeric(survey_df["YearsCodePro"], errors="coerce")
survey_df.drop(survey_df[survey_df["YearsCodePro"] > 100].index, inplace=True)
# To remove errors like: Age == YearsCodePro || Age - YearsCodePro < 10
# if you are 40 and have exp more than 30 it is an error !!
survey_df.drop(
    survey_df[survey_df["Age"] - survey_df["YearsCodePro"] <= 10].index, inplace=True
)
survey_df.drop(survey_df[survey_df["Age"] < 10].index, inplace=True)
survey_df.drop(survey_df[survey_df["Age"] > 100].index, inplace=True)
figure("When to start", figsize=(12, 6))
sns.scatterplot(x="Age", y="YearsCodePro", hue="Hobbyist", data=survey_df)
plt.xlabel("Age")
plt.ylabel("Years of professional coding experience")

# Answer 5: You are welcome any time.
plt.show()

# Inferences and Conclusion
#   -Based on the demographics of the survey respondents, we can infer that the survey is
#   somewhat reprentative of the overall programming community, although it definitly has
#   fewer responses from programmers in non-English-speaking countries and from women and non-binary genders.

#   -The programming community is not as diverse as it can be, and although things are improving, we should
#   take more efforts to support & encourage members of underrepresented communities - whather it is in terms
#   of age, country, race, gender, or otherwise.

#   -Most programmers hold a colleage degree, although a fairly large precentage did not have
#   computer science as their major in college, so a computer science degree isn't compulsory for learning
#   to code or building a carreer in programming.

#   -A sagnificant precentage of programmers either work part time or as freelancers, and this can be
#   a great way to break into the field espically when you're just getting started.

#   -JavaScript & HTML/CSS are the most used programming languages in 2020, closely followed by SQL&Python.

#   -Python is language most people are interested in learning - science it is an easy-to-learn
#   general purpose programming language well suited for a varity of domains.

#   -Rust and TypeScript are the most "Loved" languages in 2020, both of which have small but
#   fast-growing communites. Python is a close third, despite already being a widely used language.

#   -Programmers around the world seems be working for around 40 hours per week on average,
#   with slight variations by country.

#   -You can learn and start programming professionaly at any age, and you're likely to have
#   a long and fulfilling career if you also enjoy programming as a hobby.
