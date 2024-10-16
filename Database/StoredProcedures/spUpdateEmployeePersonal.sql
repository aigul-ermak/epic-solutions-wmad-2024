/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeePersonal]
	@EmployeeId INT,
    @StreetAddress NVARCHAR(255),
    @City NVARCHAR(255),
    @PostalCode NVARCHAR(7)
AS
BEGIN   
    BEGIN TRY 
	UPDATE Employee
    SET
        StreetAddress = @StreetAddress,
        City = @City,
        PostalCode = @PostalCode
    WHERE
        EmployeeId = @EmployeeId
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



