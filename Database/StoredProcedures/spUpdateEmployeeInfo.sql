/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO


CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeeInfo]
    @EmployeeId int, 
    @FirstName nvarchar(50),
    @MiddleInitial nvarchar(1),
    @LastName nvarchar(50),
    @StreetAddress nvarchar(255),
    @City nvarchar(255),
    @PostalCode nvarchar(7),
    @DOB datetime2,
    @SIN nvarchar(50),
    @SeniorityDate datetime2,
    @JobStartDate datetime2 = NULL,  
	@RetirementDate datetime2 = NULL,
	@TerminationDate datetime2 = NULL,
    @SupervisorEmployee int,   
    @WorkPhone nvarchar(14),
    @CellPhone nvarchar(14),
    @Email nvarchar(255),  
    @DepartmentId int = NULL,
    @PositionId int = NULL,  
	@StatusId int 
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY 
        UPDATE Employee
        SET
            FirstName = @FirstName,
            MiddleInitial = @MiddleInitial,
            LastName = @LastName,
            StreetAddress = @StreetAddress,
            City = @City,
            PostalCode = @PostalCode,
            DOB = @DOB,
            SIN = @SIN,
            SeniorityDate = @SeniorityDate,
            JobStartDate = @JobStartDate,  
			RetirementDate = @RetirementDate,
			TerminationDate =@TerminationDate,
            SupervisorEmployee = @SupervisorEmployee,            
            WorkPhone = @WorkPhone,
            CellPhone = @CellPhone, 
            Email = @Email, 
            DepartmentId = @DepartmentId,
            PositionId = @PositionId,            
			StatusId = @StatusId
        WHERE
            EmployeeId = @EmployeeId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH
END
GO
