/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetAllActiveDepartments]
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	WHERE
		InvocationDate <= GETDATE()
	ORDER BY
		DepartmentName
END

GO




