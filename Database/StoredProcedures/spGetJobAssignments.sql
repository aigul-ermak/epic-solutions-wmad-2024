/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetJobAssignments]
AS

BEGIN
	SELECT 
		PositionId,
		PositionName
	FROM
		Position
	ORDER BY
		PositionName
END

GO


