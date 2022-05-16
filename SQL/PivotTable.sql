
--Generating a pivot table for total Salary for each department per gender.

Select GenderType,
	IsNull(IT,0) As [IT], --Replace Null values to 0 and set the column Name
	IsNull(HR, 0) As [HR], 
	IsNull(Payroll, 0) As [Payroll], 
	IsNull(Other, 0) As [Other]
	From 
	(--Inner Join for Employee with Department & Gender
		Select Salary, DepartmentName, [GenderType] From Employee
		Join Department
		On Employee.DepartmentID = Department.DeptID
		Join Gender
		On Employee.GenderID = Gender.GendID
	)T
Pivot
(
	Sum(Salary)
	For DepartmentName In ([IT], [HR], [Payroll], [Other])
) As PivotTable