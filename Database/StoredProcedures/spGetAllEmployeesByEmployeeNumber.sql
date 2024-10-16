/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO


CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployeesByEmployeeNumber]
@EmployeeNumber int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,             
              PositionName as Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.EmployeeNumber = @EmployeeNumber AND Employee.StatusId = 1

       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



