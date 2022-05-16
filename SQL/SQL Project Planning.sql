
--	- 'SQL Project Planning' -

/*
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date.
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day
for each row in the table.

If the End_Date of the tasks are consecutive, then they are part of the same project.
Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number
of days it took to complete the project in ascending order. If there is more than
one project that have the same number of completion days,
then order by the start date of the project.
*/
With Date_Periods As
(
	Select [Start_Date] [Start_Date], Row_Number() Over(Order By [Start_Date]) [R] from Projects Group By [Start_Date]
), Date_Difference As
(
	Select Min([Start_Date]) [Start_Date],
		DATEADD(day, 1, Max([Start_Date])) [End_Date],
		DATEDIFF(day, Min([Start_Date]),DATEADD(day, 1, Max([Start_Date]))) [day_diff]
		From Date_Periods
		Group by DATEDIFF(day, R, [Start_Date])
)
Select [Start_Date], [End_Date]
	From Date_Difference
	Order By day_diff, [Start_Date]