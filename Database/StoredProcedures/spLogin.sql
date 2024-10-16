/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[spLogin]
	@EmployeeNumber NVARCHAR(8),
	@HashedPassword NVARCHAR(255)
AS
BEGIN
	BEGIN TRY
		SELECT
			Employee.EmployeeId,
			Employee.EmployeeNumber,
			(Employee.FirstName +' '+ Employee.LastName) AS EmployeeName,
			Employee.Email,
			[Role].RoleName,
			Department.DepartmentName,
			(SupervisorEmp.FirstName +' ' + SupervisorEmp.LastName) AS SupervisorEmp
		FROM
			[Employee]
				INNER JOIN [Role] ON [Employee].RoleId = [Role].RoleId
				INNER JOIN Department ON Employee.DepartmentId = Department.DepartmentId
				LEFT JOIN Employee AS SupervisorEmp ON Employee.SupervisorEmployee = SupervisorEmp.EmployeeId 
		WHERE
			Employee.EmployeeNumber = @EmployeeNumber
			AND Employee.[Password] = @HashedPassword
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO
