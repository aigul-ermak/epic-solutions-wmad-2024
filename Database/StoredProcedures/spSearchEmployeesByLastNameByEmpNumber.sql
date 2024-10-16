/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByLastNameByEmpNumber]
    @EmployeeNumber nvarchar(8) = NULL,
    @LastName nvarchar(50) = NULL
AS
BEGIN   
    BEGIN TRY 
        SELECT 
			   EmployeeId,
			   EmployeeNumber, 
               LastName,
               FirstName,
               WorkPhone,
               OfficeLocation, 
               PositionName as Position
        FROM Employee
        INNER JOIN Position
        ON Employee.PositionId = Position.PositionId
        WHERE 
		   (@EmployeeNumber IS NULL OR Employee.EmployeeNumber = @EmployeeNumber)
            AND
            (@LastName IS NULL OR Employee.LastName LIKE '%' + @LastName + '%')
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO




