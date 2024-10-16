/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [spAddDepartment]
    @DepartmentName nvarchar(128),
    @Description nvarchar(512),
    @InvocationDate datetime2(7)
	
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY 
		INSERT INTO [dbo].[Department]
			(
			[DepartmentName], 
			[Description], 
			[InvocationDate]
			)
		VALUES
			(
			@DepartmentName, 
			@Description, 
			@InvocationDate
			);
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;
GO

