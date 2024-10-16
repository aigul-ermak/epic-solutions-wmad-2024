/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByEmployeeNumber]
    @EmployeeNumber nvarchar(8)  
AS
BEGIN   
    BEGIN TRY 
        SELECT EmployeeNumber, 
               LastName,
               FirstName,
               WorkPhone,
               OfficeLocation, 
               PositionName as Position
        FROM Employee
        INNER JOIN Position
        ON Employee.PositionId = Position.PositionId
        WHERE EmployeeNumber = @EmployeeNumber 
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO




