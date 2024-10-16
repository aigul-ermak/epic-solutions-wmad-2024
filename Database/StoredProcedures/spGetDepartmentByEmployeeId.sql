/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetDepartmentByEmployeeId]
@EmployeeId int
AS

BEGIN
	SELECT 
		Department.DepartmentId,
		DepartmentName, 
		Description,
		InvocationDate
	FROM
		Department
	INNER JOIN Employee
	ON Department.DepartmentId = Employee.DepartmentId
	WHERE EmployeeId = @EmployeeId
	
END

GO


