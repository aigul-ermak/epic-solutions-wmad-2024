/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetDepartmentByPositionId]
@PositionId INT
AS
BEGIN
	SELECT 
		Department.DepartmentId,
		DepartmentName
	FROM
		Department
	INNER JOIN 
    Position ON Position.DepartmentId = Department.DepartmentId
    WHERE
        Position.PositionId = @PositionId
	ORDER BY
		DepartmentName
END
GO


