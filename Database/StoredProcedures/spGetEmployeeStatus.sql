/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetEmployeeStatus]
AS

BEGIN
	SELECT 
		StatusId,
		StatusName
	FROM
		EmployeeStatus	
	ORDER BY
		StatusName
END

GO




