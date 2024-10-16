/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO


CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployees]
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  EmployeeNumber, 
			  Password,             
              FirstName,
			  MiddleInitial,
			  LastName,
			  StreetAddress,
			  City,
			  PostalCode,
			  DOB,
			  SIN,
			  SeniorityDate,
			  RetirementDate,
			  TerminationDate,
			  JobStartDate,
			  SupervisorEmployee,              
              OfficeLocation, 
			  WorkPhone,
			  CellPhone,
			  Email,
			  isSupervisor,			  
			  Department.DepartmentName as Department,
              PositionName as Position,		
			  StatusName as Status
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId
	   INNER JOIN Department
	   ON Employee.DepartmentId = Department.DepartmentId  
	   INNER JOIN EmployeeStatus
	   ON Employee.StatusId = EmployeeStatus.StatusId
       
       ORDER BY LastName, FirstName   
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO





--CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployees]
--AS
--BEGIN   
--    BEGIN TRY 
  
--       SELECT 
--			  EmployeeId,
--			  EmployeeNumber, 
--			  Password,             
--              FirstName,
--			  MiddleInitial,
--			  LastName,
--			  StreetAddress,
--			  City,
--			  PostalCode,
--			  DOB,
--			  SIN,
--			  SeniorityDate,
--			  RetirementDate,
--			  TerminationDate,
--			  JobStartDate,
--			  SupervisorEmployee,              
--              OfficeLocation, 
--			  WorkPhone,
--			  CellPhone,
--			  Email,
--			  isSupervisor,			  
--			  Department.DepartmentName as Department,
--              PositionName as Position,		
--			  StatusName as Status
--       FROM Employee
--       INNER JOIN Position
--       ON Employee.PositionId = Position.PositionId
--	   INNER JOIN Department
--	   ON Employee.DepartmentId = Department.DepartmentId  
--	   INNER JOIN EmployeeStatus
--	   ON Employee.StatusId = EmployeeStatus.StatusId
       
--       ORDER BY LastName, FirstName   
     
--    END TRY
--    BEGIN CATCH
--        THROW;
--    END CATCH
--END
--GO



