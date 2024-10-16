/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeeDTO]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  FirstName, 
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



