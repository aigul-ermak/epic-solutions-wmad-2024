/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/


USE EpicSolutions;
GO


CREATE OR ALTER PROC [dbo].[spIsSupervisorValid]
    @SupervisorId int
AS
BEGIN
    BEGIN TRY
        SELECT COUNT(*)
        FROM [Employee]
        WHERE SupervisorEmployee = @SupervisorId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO

 SELECT COUNT(*)
        FROM [Employee]
        WHERE SupervisorEmployee = 4;