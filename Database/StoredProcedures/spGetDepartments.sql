/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetDepartments]
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	ORDER BY
		DepartmentName
END

GO


