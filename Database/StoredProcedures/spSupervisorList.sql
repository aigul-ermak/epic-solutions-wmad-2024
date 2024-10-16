/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spSupervisorList]
AS

BEGIN
	SELECT 
		EmployeeId,
		LastName + ', ' + FirstName AS Name
	FROM
		Employee
	WHERE (RoleId = 1 OR RoleId = 2) OR EmployeeId = 1
	ORDER BY
		Name
END

GO


