/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spGetRoleByPositionId]
    @PositionId INT
AS
BEGIN
    SELECT 
        Role.RoleId,
        RoleName
    FROM
        Role 
    INNER JOIN 
        Position ON Role.RoleId = Position.RoleId
    WHERE
        Position.PositionId = @PositionId
    ORDER BY
        RoleName;
END



