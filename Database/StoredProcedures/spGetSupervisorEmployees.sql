/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetSupervisorEmployees]
    @RoleId INT,
    @DepartmentId INT
AS
BEGIN
    IF @RoleId = 4
    BEGIN
        SELECT 
            EmployeeId,
            LastName + ', ' + FirstName AS FullName
        FROM
            Employee
        WHERE 
            RoleId = 3 AND DepartmentId = @DepartmentId
        ORDER BY
            LastName, FirstName
    END
    ELSE IF @RoleId = 2
    BEGIN
        SELECT 
            EmployeeId,
            LastName + ', ' + FirstName AS FullName
        FROM
            Employee
        WHERE 
            RoleId = 1 AND DepartmentId = @DepartmentId
        ORDER BY
            LastName, FirstName
    END
END
GO




--if role id = 1 || roleId= 3 retir