/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetSupervisorByDepartmentId]   
    @DepartmentId INT
AS
BEGIN   
    BEGIN
        SELECT 
            EmployeeId,
            LastName + ', ' + FirstName AS FullName
        FROM
            Employee
        WHERE 
           DepartmentId = @DepartmentId
        ORDER BY
            LastName, FirstName
    END   
END
GO