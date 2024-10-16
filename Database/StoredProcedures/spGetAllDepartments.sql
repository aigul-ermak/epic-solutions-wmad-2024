/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetAllDepartments]
AS

BEGIN
	SELECT *		
	FROM
		Department	
	ORDER BY
		DepartmentName
END

GO




