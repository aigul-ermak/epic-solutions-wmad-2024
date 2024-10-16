/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO


CREATE OR ALTER PROCEDURE [dbo].[spGetEmployee]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT FirstName, 
              LastName,
              Email,
              WorkPhone,
              SeniorityDate, 
              PositionName as Position,
			  DepartmentName as Department
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId
	   INNER JOIN Department
	   ON Employee.DepartmentId = Department.DepartmentId       
       WHERE EmployeeId = @EmployeeId
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

--CREATE OR ALTER PROCEDURE [dbo].[spGetEmployee]
--@EmployeeId int
--AS
--BEGIN   
--    BEGIN TRY 
  
--       SELECT *			
--       FROM Employee           
--       WHERE EmployeeId = @EmployeeId
     
--    END TRY
--    BEGIN CATCH
--        THROW;
--    END CATCH
--END
--GO



