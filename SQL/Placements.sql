
--	'Placements'

/*		Problem
You are given three tables: Students, Friends and Packages.
Students contains two columns: ID and Name.
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend).
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

Write a query to output the names of those students whose best
friends got offered a higher salary than them.
Names must be ordered by the salary amount offered to the best friends.
It is guaranteed that no two students got same salary offer.
*/

With StdSalary As(
	Select S.ID, S.[Name], P.Salary
		From Students S
		Inner Join Friends F
		On S.ID = F.ID
		Inner Join Packages P
		On S.ID = P.ID
), FrndSalary As(
	Select F.ID, F.Friend_ID, P.Salary [Friend_Salary]
	From Packages P
	Inner Join Friends F
	On P.ID = F.Friend_ID
), StdVsFrnd As(
	Select SS.ID, SS.[Name], SS.Salary, FS.Friend_ID, FS.Friend_Salary From StdSalary SS
	Inner Join FrndSalary FS
	On SS.ID = FS.ID
)
Select * 
	From StdVsFrnd
	Where Salary < Friend_Salary
	Order By Friend_Salary;

--Select [Name]
--	From 
--	(
--		Select S.ID, S.[Name], P.Salary
--			From Students S 
--			Inner Join Packages P
--			On S.ID = P.ID
--	) SS
--	Inner Join
--	(
--		Select F.ID, F.Friend_ID, P.Salary [Friend_Salary] 
--			From Friends F 
--			Inner Join Packages P
--			On F.Friend_ID = P.ID
--	) FS
--	On SS.ID = FS.ID
--	Where Salary < Friend_Salary
--	Order By Friend_Salary;
	

