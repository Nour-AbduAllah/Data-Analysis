--	'Occupations Pivoting'
/*
Pivot the Occupation column in OCCUPATIONS
so that each Name is sorted alphabetically
and displayed underneath its corresponding Occupation.
The output column headers should be
Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.
*/
Select 
	Min(Case When Occupation = 'Doctor' Then [Name] End) [Doctor],
	Min(Case When Occupation = 'Professor' Then [Name] End) [Professor],
	Min(Case When Occupation = 'Singer' Then [Name] End) [Singer],
	Min(Case When Occupation = 'Actor' Then [Name] End) [Actor]
	From
	(
		Select [Name], Occupation,
			ROW_NUMBER() Over(Partition By Occupation Order By [Name]) [Row_Num]
			From Occupations
	)Occ_ranked
	group by Row_Num