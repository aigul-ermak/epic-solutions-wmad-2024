/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spIsDepartmantNameIsUnique]
    @DepartmentName NVARCHAR(128)
AS
BEGIN
    BEGIN TRY
        SELECT * 
        FROM [Department]
        WHERE DepartmentName = @DepartmentName
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO

