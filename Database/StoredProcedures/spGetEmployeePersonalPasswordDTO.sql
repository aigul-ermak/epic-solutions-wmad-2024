/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeePersonalPasswordDTO]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  EmployeeNumber			 
       FROM Employee      
	   WHERE EmployeeId = @EmployeeId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



