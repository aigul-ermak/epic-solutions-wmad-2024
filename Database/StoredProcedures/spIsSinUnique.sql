/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spIsSinUnique]
    @SIN NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT * 
        FROM [Employee]
        WHERE SIN = @SIN
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO

