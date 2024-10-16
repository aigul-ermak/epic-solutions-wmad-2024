/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/





USE EpicSolutions;
GO

CREATE OR ALTER PROCEDURE [spUpdateDepartment]
    @DepartmentId INT,
    @DepartmentName NVARCHAR(128),
    @Description NVARCHAR(512),
	@InvocationDate DATETIME2
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY 
		 UPDATE [dbo].[Department]
			SET 
				[DepartmentName] = @DepartmentName, 
				[Description] = @Description,
				[InvocationDate] = @InvocationDate
			WHERE 
            [DepartmentId] = @DepartmentId;        
        COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;
GO

