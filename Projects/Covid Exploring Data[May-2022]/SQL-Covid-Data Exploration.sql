-- See all columns
Select * From CovidDeaths
	Where continent Is Not Null
	order by 2,3,4

--Select the most important columns for you
Select continent, [location], Convert(Date,[date]) [date], total_cases, new_cases, total_deaths, [population]
	From CovidDeaths 
	where continent Is Not Null
	Order By 1,2

--Select total deaths ratio respect to total infection
Select [location], Convert(Date,[date]) [date], new_cases, total_cases, total_deaths,
	Convert(Decimal(7,2),Round((total_deaths/total_cases)*100, 2)) [deaths ratio]
	from CovidDeaths
	Where continent Is Not Null

--Select total infection ratio respect to population
Select [location], Convert(Date,[date]) [date], new_cases, total_cases, [population],
	Convert(Decimal(8,4),Round((total_cases/[population]) * 100, 4)) [infection ratio]
	from CovidDeaths
	Where continent Is Not Null
	Order By [infection ratio] Desc

--Select Max infection total and Max deaths ration for loactions
Select [location], [population], Max(total_cases) [highest infections], Max(Convert(Decimal(6,2),
	Round(total_cases*100/[population], 2))) [infection ratio]
	From CovidDeaths
	Where continent Is Not Null
	Group By [location], [population]
	Order by [infection ratio] desc 

--Select Max deaths total and Max deaths ratio per location
Select [location], [population], Max(Convert(float,total_deaths)) [highest deaths], Max(Convert(Decimal(6,2),
	Round(Convert(float,total_deaths)*100/[population], 2))) [deaths ratio]
	From CovidDeaths
	Where continent Is Not Null
	Group By [location], [population]
	Order by [highest deaths] desc

--Select highest deaths per continents
Select continent, Max(Convert(Float, total_deaths)) [highest deaths]
	From CovidDeaths
	Where [continent] Is Not Null
	Group By continent
	Order By [highest deaths] Desc

--Select highest infections per continents
Select continent, Max(total_cases) [highest infections]
	From CovidDeaths
	Where [continent] Is Not Null
	Group By continent
	Order By [highest infections] Desc

--Select Worldwide infections and deaths
Select Sum(new_cases) [total cases], Sum(Convert(float, new_deaths)) [total deaths],
	Convert(Decimal(7,3), Round(Sum(Convert(float, new_deaths))*100/Sum(new_cases), 3)) [death ratio]
	from CovidDeaths
	Where continent Is Not Null


--Select all vaccionation data
Select * from CovidVaccionations where continent Is Not Null Order By [location], [date]

--Select just important data from Vaccionatins
Select continent, [location], [date], total_tests, new_tests,
	total_vaccinations, new_vaccinations, people_fully_vaccinated,
	people_fully_vaccinated, positive_rate, Convert(Int,median_age)
	From CovidVaccionations
	Where continent Is Not Null

--Select countries people who fully vaccinated and total vaccination and the ratio between them
Select continent, [location], Convert(Date, [date]) [date],
	Max(Convert(float, total_vaccinations)) [total vaccinations],
	Max(Convert(float, people_fully_vaccinated)) [people fully vaccinated],
	Convert(
	Decimal(7,3),
	Round(Max(Convert(float, people_fully_vaccinated))*100/Max(Convert(float, total_vaccinations)), 3)
	)[full vaccinated ratio]
	From CovidVaccionations
	Where continent Is Not Null
	Group By continent, [location], [date]
	Order By continent, [location], [date]

--Select average vaccinated people ages per countries
Select continent,[location], Max(median_age) [avg age]
	From CovidVaccionations 
	Where continent Is Not Null
	Group By continent, [location]
	Order By continent, [location]

--Select country's total tests and positive rate
Select continent, [location], Convert(Date, [date]) [date], new_tests, total_tests, new_tests_smoothed, positive_rate
	From CovidVaccionations
	Where continent Is Not Null
	Order By [location], [date]




--Select all deaths and vaccination data
Select * From CovidDeaths Death
	Inner Join
	CovidVaccionations Vacc
	On Death.[location] =  Vacc.[location]
	and
	Death.[date] = Vacc.[date]

--Select important columns only
Select Dea.continent, Dea.[location], Convert(Date,Dea.[date]) [date], Dea.[population], Dea.total_cases, Dea.new_cases, Dea.total_deaths,
	Dea.new_deaths, total_tests, new_tests, positive_rate, tests_units, total_vaccinations,
	new_vaccinations, people_vaccinated, people_fully_vaccinated, median_age,
	male_smokers, female_smokers
	From
	CovidDeaths Dea
	Inner Join CovidVaccionations Vacc
	On
	Dea.[location] = Vacc.[location]
	And
	Dea.[date]=Vacc.[date]
	Where Dea.continent Is Not Null
	Order By Dea.[date]

--new cases VS new deaths VS new vaccinations
Select CV.[location], Convert(Date,CV.[date]) [date], CD.new_cases, CD.new_deaths,
	CV.new_vaccinations
	From
	CovidDeaths CD
	Inner Join CovidVaccionations CV
	On
	CD.[location] = CV.[location]
	And
	CD.[date]=CV.[date]
	Where CD.continent Is Not Null
	Order By CD.[location], CD.[date]


--new vaccinations VS population
--Create a common table expression (CTE)
with PopVsVacc As
(
	Select CV.[location], Convert(Date, CV.[date]) [date], CD.[population], CV.new_vaccinations,
	Sum(Convert(float,CV.new_vaccinations))
	Over(Partition By CV.[location] Order By CV.[location], CV.[date]) [new vaccionations running total]
	From
	CovidDeaths CD
	Inner Join CovidVaccionations CV
	On
	CD.[location] = CV.[location]
	And
	CD.[date]=CV.[date]
	Where CD.continent Is Not Null
)
Select *, Convert(Decimal(7,3), Round([new vaccionations running total]*100/population, 3)) [Current Vaccinations ratio]
	From
	PopVsVacc

--Select countries people who fully vaccinated ratio respect to population
Select CD.[location], [population],
	Max(Convert(float, people_fully_vaccinated)) [people fully vaccinated],
	Convert(
	Decimal(7,3),
	Round(Max(Convert(float, people_fully_vaccinated))*100/Max([population]), 3)
	)[full vaccinated ratio]
	From CovidVaccionations CV
	Inner Join
	CovidDeaths CD
	On CD.[location] = CV.[location]
	And CD.[date] = CV.[date]
	Where CD.continent Is Not Null
	Group By CD.[location], CD.[population]
	Order By CD.[location]

