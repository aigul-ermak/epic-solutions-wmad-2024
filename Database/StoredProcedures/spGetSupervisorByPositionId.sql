/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spGetSupervisorByPositionId]   
    @PositionId INT
AS
BEGIN   
	DECLARE @RoleId INT
    DECLARE @DepartmentId INT

	SELECT @RoleId = roleId FROM position WHERE positionId = @PositionId 
    SELECT @DepartmentId = departmentId FROM position WHERE positionId = @PositionId 

	PRINT 'Role ID: ' + CAST(@RoleId AS VARCHAR(10))
    PRINT 'Department ID: ' + CAST(@DepartmentId AS VARCHAR(10))
	

	IF @PositionId = 1
    BEGIN
        RETURN;
    END

	IF @RoleId IS NOT NULL
	BEGIN
    IF @RoleId = 4
    BEGIN
        SELECT  
			EmployeeId,
            LastName + ', ' + FirstName AS FullName
        FROM employee 
        WHERE roleId = 2 AND departmentId = @DepartmentId
    END
    ELSE IF @RoleId = 3
    BEGIN
        SELECT 
			EmployeeId,
            LastName + ', ' + FirstName AS FullName			
        FROM employee 
        WHERE roleId = 1 AND departmentId = @DepartmentId
    END
	ELSE IF @RoleId = 2 OR @RoleId = 1
    BEGIN
        SELECT 
			EmployeeId,
            LastName + ', ' + FirstName AS FullName			
        FROM employee 
        WHERE EmployeeId = 1
    END
	END
    ELSE
    BEGIN      
        SELECT 'No supervisors found' AS Result
    END
END
GO

