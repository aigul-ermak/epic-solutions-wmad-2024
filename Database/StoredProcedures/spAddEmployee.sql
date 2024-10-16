/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO


CREATE OR ALTER PROCEDURE [dbo].[spAddEmployee]
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
    @SupervisorEmployee int,
    @OfficeLocation nvarchar(255),
    @WorkPhone nvarchar(14),
    @CellPhone nvarchar(14),
    @Email nvarchar(255),
    @Password char(64),
    @PasswordSalt binary(16),
    @isSupervisor bit,
    @DepartmentId int = NULL,
    @PositionId int = NULL,
	@StatusId int,
    @RoleId int = NULL
	 
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY 
  
        INSERT INTO [dbo].[Employee] (
            [FirstName],
            [MiddleInitial],
            [LastName],
            [StreetAddress],
            [City],
            [PostalCode],
            [DOB],
            [SIN],
            [SeniorityDate],
            [JobStartDate],       
            [SupervisorEmployee],
            [OfficeLocation],
            [WorkPhone],
            [CellPhone],
            [Email],
            [Password],
            [PasswordSalt],
            [isSupervisor],
            [DepartmentId],
            [PositionId],
			[StatusId],
            [RoleId]
			
        )
        VALUES (
            @FirstName,
            @MiddleInitial,
            @LastName,
            @StreetAddress,
            @City,
            @PostalCode,
            @DOB,
            @SIN,
            @SeniorityDate,
            @JobStartDate,       
            @SupervisorEmployee,
            @OfficeLocation,
            @WorkPhone,
            @CellPhone,
            @Email,
            @Password,
            @PasswordSalt,
            @isSupervisor,
            @DepartmentId,
            @PositionId,
			@StatusId,
            @RoleId
        );
  
        DECLARE @NewEmployeeId int = SCOPE_IDENTITY();

        SELECT 
            EmployeeId, 
            EmployeeNumber 
        FROM [dbo].[Employee] 
        WHERE EmployeeId = @NewEmployeeId;

        COMMIT TRANSACTION;
	 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
