/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeePersonalPassword]
	@EmployeeId INT,
    @Password char(64),
    @PasswordSalt binary(16)    
AS
BEGIN   
    BEGIN TRY 
	UPDATE Employee
    SET
        Password =  @Password,       
        PasswordSalt = @PasswordSalt
    WHERE
        EmployeeId = @EmployeeId     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



