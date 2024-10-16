/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByActiveDepartment]   
	@DepartmentName nvarchar (128)
AS
BEGIN   
    BEGIN TRY 
        SELECT EmployeeNumber, 
               LastName,
               FirstName,
               WorkPhone,
               OfficeLocation, 
               PositionName as Position,
			   DepartmentName as Department
        FROM Employee
        INNER JOIN Position
        ON Employee.PositionId = Position.PositionId
		INNER JOIN Department
		ON Employee.DepartmentId = Department.DepartmentID		
        WHERE DepartmentName LIKE '%' + @DepartmentName + '%' AND InvocationDate <= GETDATE()
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO




