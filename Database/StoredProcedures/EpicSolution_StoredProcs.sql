/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 2.1
*/


USE EpicSolutions;
GO

CREATE OR ALTER PROC [dbo].[OrderRecordVersion]
@OrderId AS INT
AS
BEGIN
	BEGIN TRY
		SELECT [Order].RecordVersion FROM [Order] WHERE OrderId = @OrderId
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO

CREATE OR ALTER PROC [dbo].[ItemRecordVersion]
@ItemId AS INT
AS
BEGIN
	BEGIN TRY
		SELECT Item.RecordVersion FROM Item WHERE ItemId = @ItemId
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO



CREATE OR ALTER PROC [dbo].[spGetAllOrders]
@EmployeeNumber AS NVARCHAR(8)
AS
BEGIN
	BEGIN TRY
		SELECT [Order].OrderId,
				[Order].PONumber, 
				[Order].CreationDate, 
				(Employee.FirstName +' '+ Employee.LastName) AS EmployeeName, 
				Employee.EmployeeId,
				Employee.EmployeeNumber,
				[OrderStatus].StatusId,
				[OrderStatus].StatusName,
				SUM(Item.ItemQuantity*ItemPrice) AS SubTotal
		FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
		INNER JOIN Item ON Item.OrderId = [Order].OrderId
		WHERE Employee.EmployeeNumber = @EmployeeNumber
		GROUP BY 
		[Order].OrderId,
		[Order].PONumber, 
		[Order].CreationDate, 
		Employee.FirstName, 
		Employee.LastName, 
		Employee.EmployeeId,
		Employee.EmployeeNumber,
		OrderStatus.StatusId,
		OrderStatus.StatusName
		ORDER BY [Order].CreationDate DESC
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO

CREATE OR ALTER PROC [dbo].[spGetAllOrdersBySupervisor]
@SupervisorId AS Int
AS
BEGIN
       BEGIN TRY
               SELECT [Order].OrderId,
                               [Order].PONumber,
                               [Order].CreationDate,
                               (Employee.FirstName +' '+ Employee.LastName) AS EmployeeName,
                               Employee.EmployeeId,
                               Employee.EmployeeNumber,
                               Department.DepartmentName,
                               OrderStatus.StatusId,
                               OrderStatus.StatusName,
                               SUM(Item.ItemQuantity*ItemPrice) AS SubTotal
               FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId
               INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
               INNER JOIN Item ON Item.OrderId = [Order].OrderId
               INNER JOIN Department ON Employee.DepartmentId = Department.DepartmentId
               WHERE Employee.SupervisorEmployee = @SupervisorId
               GROUP BY
               [Order].OrderId,
               [Order].PONumber,
               [Order].CreationDate,
               Employee.FirstName,
               Employee.LastName,
               Employee.EmployeeId,
              Employee.EmployeeNumber,
               Department.DepartmentName,
               OrderStatus.StatusId,
               OrderStatus.StatusName
               ORDER BY [Order].CreationDate DESC
       END TRY
       BEGIN CATCH
       ;THROW
       END CATCH
END

GO



CREATE OR ALTER PROC [dbo].[spGetAllOrdersByEmployee]
@EmployeeId AS Int
AS
BEGIN
       BEGIN TRY
               SELECT [Order].OrderId,
                               [Order].PONumber,
                              [Order].CreationDate,
                               (Employee.FirstName +' '+ Employee.LastName) AS EmployeeName,
                               Employee.EmployeeId,
                               Employee.EmployeeNumber,
                               Department.DepartmentName,
                               OrderStatus.StatusId,
                               OrderStatus.StatusName,
                               SUM(Item.ItemQuantity*ItemPrice) AS SubTotal
               FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId
               INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
               INNER JOIN Item ON Item.OrderId = [Order].OrderId
              INNER JOIN Department ON Employee.DepartmentId = Department.DepartmentId
               WHERE Employee.EmployeeId = @EmployeeId
               GROUP BY
               [Order].OrderId,
              [Order].PONumber,
               [Order].CreationDate,
               Employee.FirstName,
               Employee.LastName,
              Employee.EmployeeId,
               Employee.EmployeeNumber,
               Department.DepartmentName,
               OrderStatus.StatusId,
               OrderStatus.StatusName
              ORDER BY [Order].CreationDate DESC
       END TRY
       BEGIN CATCH
       ;THROW
       END CATCH
END

GO


CREATE OR ALTER PROCEDURE [spGetEmployeeOrdersBySupervisorId]
@SupervisorId AS NVARCHAR(8)
AS
BEGIN
       BEGIN TRY

       SELECT [Order].*
       FROM [Order] INNER JOIN
       Employee ON [Order].EmployeeId = Employee.EmployeeId
       WHERE Employee.SupervisorEmployee = @SupervisorId
END TRY
       BEGIN CATCH
               THROW;
       END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spGetEmployeeBySupervisorId]
@SupervisorId AS NVARCHAR(8)
AS
BEGIN
       BEGIN TRY
       SELECT Count(EmployeeId)
       FROM Employee
       WHERE Employee.SupervisorEmployee = @SupervisorId
END TRY
       BEGIN CATCH
               THROW;
       END CATCH
END
GO


CREATE OR ALTER PROC [dbo].[spGetAllOrdersByDepartment]
@Department AS NVARCHAR(255)
AS
BEGIN
	BEGIN TRY
		SELECT [Order].OrderId,
				[Order].PONumber, 
				[Order].CreationDate, 
				(Employee.FirstName +' '+ Employee.LastName) AS EmployeeName, 
				Employee.EmployeeId,
				Employee.EmployeeNumber,
				Department.DepartmentName,
				OrderStatus.StatusId,
				OrderStatus.StatusName,
				SUM(Item.ItemQuantity*ItemPrice) AS SubTotal
		FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
		INNER JOIN Item ON Item.OrderId = [Order].OrderId
		INNER JOIN Department ON Employee.DepartmentId = Department.DepartmentId
		WHERE Department.DepartmentName Like @Department
		GROUP BY 
		[Order].OrderId,
		[Order].PONumber, 
		[Order].CreationDate, 
		Employee.FirstName, 
		Employee.LastName, 
		Employee.EmployeeId,
		Employee.EmployeeNumber,
		Department.DepartmentName,
		OrderStatus.StatusId,
		OrderStatus.StatusName
		ORDER BY [Order].CreationDate DESC
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO

CREATE OR ALTER PROC [dbo].[spGetAllOrdersByStatus]
AS
BEGIN
	BEGIN TRY
		SELECT [Order].OrderId,
				[Order].PONumber, 
				[Order].CreationDate, 
				(Supervisor.FirstName +' '+ Supervisor.LastName) AS SupervisorName,
				OrderStatus.StatusName,
				Department.DepartmentId,
				Department.DepartmentName
		FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
		INNER JOIN Department ON Employee.DepartmentId = Department.DepartmentId
		INNER JOIN Employee AS Supervisor ON Employee.SupervisorEmployee = Supervisor.EmployeeId
		WHERE OrderStatus.StatusId = 2 OR OrderStatus.StatusId = 4
		ORDER BY [Order].CreationDate ASC
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO



CREATE OR ALTER PROC [dbo].[spSearchOrder]
@EmployeeId AS INT,
@StartDate AS DATETIME2(7) = NULL,
@EndDate AS DATETIME2(7) = NULL,
@PONumber AS NVARCHAR(8) = NULL
AS
BEGIN
	BEGIN TRY
		SELECT OrderId, PONumber, CreationDate, (Employee.FirstName +' '+ Employee.LastName) AS FullName, OrderStatus.StatusName 
		FROM [Order] 
		INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
		WHERE (Employee.EmployeeId = @EmployeeId)
		AND (@StartDate IS NULL OR CreationDate >= @StartDate)
		AND (@EndDate IS NULL OR CreationDate <= @EndDate)
		AND (@PONumber IS NULL OR PONumber = @PONumber)
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END

GO

CREATE OR ALTER PROC [dbo].[spGetOrderById]
@OrderId AS INT
AS
BEGIN
	BEGIN TRY
		SELECT OrderId, PONumber, CreationDate, (Employee.FirstName +' '+ Employee.LastName) AS FullName, OrderStatus.StatusName, Employee.Email 
		FROM [Order] INNER JOIN OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN Employee ON [Order].EmployeeId = Employee.EmployeeId
		WHERE OrderId = @OrderId
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO

CREATE OR ALTER PROC [dbo].[spGetOrderWithItems]
	@OrderId INT
AS
BEGIN
	BEGIN TRY

		WITH OrderTotals AS (
			SELECT 
				Item.OrderId,
				SUM(Item.ItemQuantity * Item.ItemPrice) AS SubTotal
			FROM 
				Item
			GROUP BY 
				Item.OrderId
		)
		SELECT 
			[Order].OrderId,
			[Order].PONumber, 
			[Order].CreationDate, 
			(Employee.FirstName + ' ' + Employee.LastName) AS EmployeeName, 
			Employee.EmployeeId,
			Employee.EmployeeNumber,
			Department.DepartmentName,
			(Supervisor.FirstName + ' ' + Supervisor.LastName) AS SupervisorName,
			[Order].StatusId,
			[Order].RecordVersion AS orderRecordVersion,
			OrderStatus.StatusName,
			Item.ItemId,
			Item.ItemName,
			Item.ItemDescription,
			Item.ItemQuantity,
			Item.ItemPrice,
			Item.RecordVersion AS itemRecordVersion,
			Item.ItemPurchaseLocation,
			Item.ItemJustification,
			Item.StatusId AS ItemStatusId,
			ItemStatus.StatusName As ItemStatusName,

			(Item.ItemPrice * Item.ItemQuantity) AS ItemSubTotal,
			OrderTotals.SubTotal
		FROM 
			[Order]
		INNER JOIN 
			OrderStatus ON [Order].StatusId = OrderStatus.StatusId 
		INNER JOIN 
			Employee ON [Order].EmployeeId = Employee.EmployeeId
		INNER JOIN 
			Department ON [Department].DepartmentId = Employee.DepartmentId
		INNER JOIN 
			Employee AS Supervisor ON Employee.SupervisorEmployee = Supervisor.EmployeeId
		INNER JOIN 
			Item ON Item.OrderId = [Order].OrderId
		INNER JOIN 
			ItemStatus ON Item.StatusId = ItemStatus.StatusId
		INNER JOIN 
			OrderTotals ON OrderTotals.OrderId = [Order].OrderId
		WHERE 
			[Order].OrderId = @OrderId;

	END TRY

	BEGIN CATCH
		;THROW
	END CATCH

END

GO

CREATE OR ALTER PROC [dbo].[spGetItemById]
	@ItemId INT
AS
BEGIN
	BEGIN TRY
		SELECT 
			Item.ItemId,
			Item.ItemName,
			Item.ItemDescription,
			Item.ItemQuantity,
			Item.ItemPrice,
			Item.ItemPurchaseLocation,
			Item.ItemJustification,
			Item.OrderId,
			Item.StatusId AS ItemStatusId,
			ItemStatus.StatusName As ItemStatusName,
			Item.DenyReason,
			Item.RecordVersion
		FROM 
			Item
		INNER JOIN 
			ItemStatus ON Item.StatusId = ItemStatus.StatusId

		WHERE 
			Item.ItemId = @ItemId;

	END TRY

	BEGIN CATCH
		;THROW
	END CATCH

END

GO


CREATE OR ALTER PROC [dbo].[spOrderIdByItemId]
@ItemId AS INT
AS
BEGIN
	BEGIN TRY
		SELECT OrderId FROM Item WHERE ItemId = @ItemId;
	END TRY
	BEGIN CATCH
	;THROW
	END CATCH
END

GO


CREATE OR ALTER PROCEDURE [spGetOrderId]
@OrderNumber AS NVARCHAR(8)
AS
BEGIN
	BEGIN TRY 
		SELECT [Order].OrderId FROM [Order] WHERE [Order].PONumber = @OrderNumber
END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spGetNewPONumber]
AS
BEGIN
	BEGIN TRY 

	SELECT TOP 1 RIGHT('00000000' + CAST(OrderId AS VARCHAR(8)), 8) AS PONumber
	FROM [Order]
	ORDER BY OrderId DESC;
END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spUpdateItem]
@ItemId Int,
@ItemName NVARCHAR(45),
@ItemDescription NVARCHAR(255),
@ItemQuantity Int,
@StatusId Int,
@ItemPrice Money,
@ItemPurchaseLocation NVARCHAR(255),
@ItemJustification NVARCHAR(255),
@ItemRecordVersion ROWVERSION
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY 

	DECLARE @RecordVersion ROWVERSION = (SELECT Item.RecordVersion FROM Item WHERE ItemId = @ItemId);
        IF @RecordVersion <> @ItemRecordVersion
            THROW 51002, 'The record has been alredy updated.', 1;

	UPDATE Item 
			SET
				ItemName = @ItemName,
				ItemDescription = @ItemDescription,
				ItemQuantity = @ItemQuantity,
				ItemPrice = @ItemPrice,
				ItemPurchaseLocation = @ItemPurchaseLocation,
				ItemJustification = @ItemJustification,
				StatusId = @StatusId
			WHERE
				ItemId = @ItemId
	 COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
	IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spUpdateItemStatus]
@ItemId Int,
@StatusId Int,
@DenyReason NVARCHAR(255),
@ItemRecordVersion ROWVERSION
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 

	DECLARE @RecordVersion ROWVERSION = (SELECT Item.RecordVersion FROM Item WHERE ItemId = @ItemId);
        IF @RecordVersion <> @ItemRecordVersion
            THROW 51002, 'The record has been alredy updated.', 1;

	UPDATE Item 
			SET
				StatusId = @StatusId,
				DenyReason = @DenyReason
			WHERE
				ItemId = @ItemId
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE [spUpdateItemStatusApprove]
@ItemId AS Int,
@StatusId AS Int,
@EditReason AS NVARCHAR(255) = NULL,
@Quantity AS NVARCHAR(255),
@Price AS Money,
@Location AS NVARCHAR(255),
@ItemRecordVersion ROWVERSION
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 

	DECLARE @RecordVersion ROWVERSION = (SELECT Item.RecordVersion FROM Item WHERE ItemId = @ItemId);
        IF @RecordVersion <> @ItemRecordVersion
            THROW 51002, 'The record has been alredy updated.', 1;

	UPDATE Item 
			SET
				StatusId = @StatusId,
				EditReason = @EditReason,
				ItemQuantity = @Quantity,
				ItemPrice = @Price,
				ItemPurchaseLocation = @Location
			WHERE
				ItemId = @ItemId
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO



CREATE OR ALTER PROCEDURE [spUpdateOrderStatus]
@OrderId Int,
@StatusId Int
--@OrderRecordVersion ROWVERSION
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 

	--DECLARE @RecordVersion ROWVERSION = (SELECT [Order].RecordVersion FROM [Order] WHERE OrderId = @OrderId);
 --       IF @RecordVersion <> @OrderRecordVersion
 --           THROW 51002, 'The record has been alredy updated.', 1;

	UPDATE [Order] 
			SET
				StatusId = @StatusId
			WHERE
				OrderId = @OrderId
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO



CREATE OR ALTER PROCEDURE [stItemDelete]
@ItemId Int
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 

	Delete Item 
			WHERE
				Item.ItemId = @ItemId
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
				IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO




CREATE OR ALTER PROCEDURE [spGetEmployeeFullName]
@EmployeeNumber AS NVARCHAR(8)
AS
BEGIN
	BEGIN TRY 

	SELECT (FirstName +' '+ LastName) AS FullName
	FROM Employee
	WHERE EmployeeNumber = @EmployeeNumber
END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spGetNewOrdeInfo]
@EmployeeNumber AS NVARCHAR(8)
AS
BEGIN
	BEGIN TRY 
		SELECT a.Result AS POOrder, b.Result AS FullName
		FROM
			(SELECT TOP 1 RIGHT('00000000' + CAST(OrderId + 1 AS VARCHAR(8)), 8) AS Result, 1 AS JoinKey
			 FROM [Order]
			 ORDER BY OrderId DESC) a
		CROSS JOIN
			(SELECT (FirstName + ' ' + LastName) AS Result, 1 AS JoinKey
			 FROM Employee
			 WHERE EmployeeNumber = @EmployeeNumber) b
END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE [spAddOrder]
@CreationDate AS DATETIME2(7),
@StatusId AS Int, 
@EmployeeId AS Int
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 
		INSERT INTO [dbo].[Order]
			(CreationDate, StatusId, EmployeeId)
		VALUES
			(@CreationDate, @StatusId, @EmployeeId)
			COMMIT TRANSACTION
END TRY
	BEGIN CATCH
			IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spAddOrderAndItems]

    @OrderNum AS Int OUTPUT,
	@CreationDate AS DATETIME2(7),
    @StatusId AS Int, 
    @EmployeeId AS Int,
    @ItemName AS NVARCHAR(45),
    @ItemDescription AS NVARCHAR(255),
    @ItemQuantity AS Int,
    @ItemPrice AS Money,
    @ItemPurchaseLocation  AS NVARCHAR(255),
    @ItemJustification AS NVARCHAR(255)
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY

        INSERT INTO [dbo].[Order] (CreationDate, StatusId, EmployeeId)
        VALUES (@CreationDate, @StatusId, @EmployeeId)
        
        DECLARE @OrderId AS INT = SCOPE_IDENTITY();
		SET @OrderNum = @OrderId;

        INSERT INTO [dbo].[Item] (ItemName, ItemDescription, ItemQuantity, ItemPrice, ItemPurchaseLocation, ItemJustification, StatusId, OrderId)
        VALUES (@ItemName, @ItemDescription, @ItemQuantity, @ItemPrice, @ItemPurchaseLocation, @ItemJustification, @StatusId, @OrderId)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO



CREATE OR ALTER PROCEDURE [spCheckOrderDublicate]

    @OrderId AS Int,
    @ItemName AS NVARCHAR(45),
    @ItemDescription AS NVARCHAR(255),
    @ItemPrice AS Money,
    @ItemPurchaseLocation  AS NVARCHAR(255),
    @ItemJustification AS NVARCHAR(255)
AS
BEGIN  
    BEGIN TRY
		SELECT 
			ItemId 
		FROM 
			Item
		WHERE 
			OrderId = @OrderId AND
			ItemName = @ItemName AND
			ItemPrice = @ItemPrice AND
			ItemDescription = @ItemDescription AND
			ItemPurchaseLocation = @ItemPurchaseLocation AND
			ItemJustification = @ItemJustification;    
		END TRY
    BEGIN CATCH
		;THROW
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE [spMergeDublicate]

    @ItemId AS Int,
	@ItemQuantity AS Int
AS
BEGIN  
     BEGIN TRANSACTION
    BEGIN TRY
	DECLARE @CurrentQuantity INT;

		SELECT @CurrentQuantity = ItemQuantity FROM Item WHERE ItemId = @ItemId;

		UPDATE Item 
			SET
				ItemQuantity = @ItemQuantity + @CurrentQuantity
			WHERE
				ItemId = @ItemId

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO






CREATE OR ALTER PROCEDURE [spAndItemOnly]
	@OrderId AS Int,
	@CreationDate AS DATETIME2(7),
    @StatusId AS Int, 
    @EmployeeId AS Int,
    @ItemName AS NVARCHAR(45),
    @ItemDescription AS NVARCHAR(255),
    @ItemQuantity AS Int,
    @ItemPrice AS Money,
    @ItemPurchaseLocation  AS NVARCHAR(255),
    @ItemJustification AS NVARCHAR(255)
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY

        INSERT INTO [dbo].[Item] (ItemName, ItemDescription, ItemQuantity, ItemPrice, ItemPurchaseLocation, ItemJustification, StatusId, OrderId)
        VALUES (@ItemName, @ItemDescription, @ItemQuantity, @ItemPrice, @ItemPurchaseLocation, @ItemJustification, @StatusId, @OrderId)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO


CREATE OR ALTER PROCEDURE [spAddItem]
@ItemId AS Int OUTPUT,
@ItemName AS NVARCHAR(45),
@ItemDescription AS NVARCHAR(255),
@ItemQuantity AS Int,
@ItemPrice AS Money,
@ItemPurchaseLocation  AS NVARCHAR(255),
@ItemJustification AS NVARCHAR(255),
@StatusId AS Int,
@OrderId AS Int
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY 
		INSERT INTO [dbo].[Item]
			(ItemName, ItemDescription, ItemQuantity, ItemPrice, ItemPurchaseLocation, ItemJustification, StatusId, OrderId)
		VALUES
			(@ItemName, @ItemDescription, @ItemQuantity, @ItemPrice, @ItemPurchaseLocation, @ItemJustification, @StatusId, @OrderId)

		SET @ItemId = SCOPE_IDENTITY();
		COMMIT TRANSACTION
END TRY
	BEGIN CATCH
			IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

--- department

CREATE OR ALTER PROCEDURE [spAddDepartment]
	@DepartmentId int OUTPUT,
    @DepartmentName nvarchar(128),
	@RecordVersion ROWVERSION OUTPUT,
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
			)
		SET @DepartmentId = SCOPE_IDENTITY(); 

		SET @RecordVersion = (SELECT RecordVersion FROM Department WHERE DepartmentId = @DepartmentId);
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;
GO



CREATE OR ALTER PROCEDURE [dbo].[spAddEmployee]
	@EmployeeId int OUTPUT, 
	@RecordVersion ROWVERSION OUTPUT,
    @FirstName nvarchar(50),
    @MiddleInitial nvarchar(1),
    @LastName nvarchar(50),
    @StreetAddress nvarchar(255),
    @City nvarchar(255),
    @PostalCode nvarchar(7),
    @DOB datetime2,
    @SIN nvarchar(50),
    @SeniorityDate datetime2,
	@TerminationDate datetime2,
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
			[TerminationDate],
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
			@TerminationDate,
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
  
        --DECLARE @NewEmployeeId int = SCOPE_IDENTITY();

        --SELECT 
        --    EmployeeId, 
        --    EmployeeNumber 
        --FROM [dbo].[Employee] 
        --WHERE EmployeeId = @NewEmployeeId;
		SET @EmployeeId = SCOPE_IDENTITY();
		SET @RecordVersion = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId);

        COMMIT TRANSACTION;
	 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spIsDepartmentValidForDelete]
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	WHERE
		InvocationDate <= GETDATE()
	ORDER BY
		DepartmentName
END

GO



CREATE OR ALTER PROC [dbo].[spGetEmployeesWithPendingReviews]
@SupervisorId  int
AS


DECLARE @CurrentDate DATE = GETDATE();  -- Current date
DECLARE @CurrentYear INT = YEAR(@CurrentDate);  -- Current year
DECLARE @CurrentQuarter INT = (MONTH(@CurrentDate) - 1) / 3 + 1;  -- Current quarter

;WITH Quarters AS (
    SELECT
        @CurrentYear AS Year,
        @CurrentQuarter AS Quarter,
        DATEADD(QUARTER, @CurrentQuarter - 1, DATEADD(YEAR, @CurrentYear - 1900, 0)) AS StartDate,
        DATEADD(DAY, -1, DATEADD(QUARTER, @CurrentQuarter, DATEADD(YEAR, @CurrentYear - 1900, 0))) AS EndDate
    UNION ALL
    SELECT
        CASE 
            WHEN Quarter = 1 THEN Year - 1
            ELSE Year
        END,
        CASE 
            WHEN Quarter = 1 THEN 4
            ELSE Quarter - 1
        END,
        DATEADD(QUARTER, (CASE WHEN Quarter = 1 THEN 4 ELSE Quarter - 1 END) - 1, DATEADD(YEAR, (CASE WHEN Quarter = 1 THEN Year - 1 ELSE Year END) - 1900, 0)),
        DATEADD(DAY, -1, DATEADD(QUARTER, CASE WHEN Quarter = 1 THEN 4 ELSE Quarter - 1 END, DATEADD(YEAR, (CASE WHEN Quarter = 1 THEN Year - 1 ELSE Year END) - 1900, 0)))
    FROM Quarters
    WHERE Year > @CurrentYear - 2 OR (Year = @CurrentYear - 1 AND Quarter >= @CurrentQuarter)
)

SELECT  MyQuarters.Year, MyQuarters.QuarterId,
		Employee.EmployeeId, Employee.FirstName, Employee.LastName, ReviewsCreated.EmployeeId 

		FROM 

			(SELECT Quarter.QuarterId, Quarters.Year  FROM Quarters
			INNER JOIN Quarter
			ON Quarters.Quarter = Quarter.QuarterId) AS MyQuarters
			
		CROSS JOIN
			Employee	
			
		LEFT JOIN

--- Reviews Created
  ( SELECT 
   MyQuarters1.Year, MyQuarters1.QuarterId,
		E1.EmployeeId, FirstName, LastName 
		FROM 

		(SELECT Quarter.QuarterId, Quarters.Year  FROM Quarters
			INNER JOIN Quarter
			ON Quarters.Quarter = Quarter.QuarterId) AS MyQuarters1		
		
				
		INNER JOIN Review
		ON MyQuarters1.QuarterID = Review.QuarterId AND MyQuarters1.Year = DATEPART(year, Review.ReviewYear)


		INNER JOIN Employee AS E1
		ON E1.EmployeeId = Review.EmployeeId) AS ReviewsCreated

		ON ReviewsCreated.Year = MyQuarters.Year AND ReviewsCreated.QuarterId = MyQuarters.QuarterId AND ReviewsCreated.EmployeeId = Employee.EmployeeId

		
		WHERE ReviewsCreated.EmployeeId IS NULL AND Employee.SupervisorEmployee = @SupervisorId    
		
		ORDER BY MyQuarters.Year DESC, MyQuarters.QuarterId DESC, LastName, FirstName 

GO



CREATE OR ALTER PROC [dbo].[spGetRatingList]
AS

BEGIN
	SELECT 
		RatingId,
		RatingName
	FROM
		Rating	
END

GO



CREATE OR ALTER PROC [dbo].[spGetQuatersList]
AS

BEGIN
	SELECT 
		QuarterId,
		QuarterName
	FROM
		[Quarter]	
END

GO



CREATE OR ALTER PROCEDURE [dbo].[spDeleteDepartment]
    @DepartmentId int
AS
BEGIN
    BEGIN TRY
        DELETE FROM Department
        WHERE DepartmentId = @DepartmentId;
    END TRY
    BEGIN CATCH       
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllActiveEmployees]
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
       WHERE Employee.StatusId = 1 
       ORDER BY LastName, FirstName   
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spGetAllDepartments]
AS

BEGIN
	SELECT *		
	FROM
		Department	
	ORDER BY
		DepartmentName
END

GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllDepartmentsExceptOne]
    @ExcludeDepartmentId INT = NULL  
AS
BEGIN
    SELECT *
    FROM Department
    WHERE DepartmentId <> ISNULL(@ExcludeDepartmentId, DepartmentId)
    ORDER BY DepartmentName;
END;

GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployees]
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  EmployeeNumber, 
			  Password,             
              FirstName,
			  MiddleInitial,
			  LastName,
			  StreetAddress,
			  City,
			  PostalCode,
			  DOB,
			  SIN,
			  SeniorityDate,
			  RetirementDate,
			  TerminationDate,
			  JobStartDate,
			  SupervisorEmployee,              
              OfficeLocation, 
			  WorkPhone,
			  CellPhone,
			  Email,
			  isSupervisor,
			  Employee.RecordVersion,
			  Department.DepartmentName AS Department,
              PositionName AS Position,		
			  StatusName AS Status
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId
	   INNER JOIN Department
	   ON Employee.DepartmentId = Department.DepartmentId  
	   INNER JOIN EmployeeStatus
	   ON Employee.StatusId = EmployeeStatus.StatusId
       
       ORDER BY LastName, FirstName   
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO




CREATE OR ALTER PROCEDURE [dbo].[spAddReview]
	@ReviewYear Date, 	
    @Comment NVARCHAR (MAX),
    @CompletionDate DATETIME,
    @isRead bit,
    @RatingId int,
    @EmployeeId int,
	@SupervisorId int,
    @QuarterId int	 
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY 
  
        INSERT INTO [dbo].[Review] (
            [ReviewYear],
            [Comment],
            [CompletionDate],
            [isRead],
            [RatingId],
            [EmployeeId],
            [SupervisorEmployee],
            [QuarterId]
        )
        VALUES (
            @ReviewYear,
            @Comment,
            @CompletionDate,
            @isRead,
            @RatingId,
            @EmployeeId,
            @SupervisorId,
            @QuarterId           
        );

        COMMIT TRANSACTION;
	 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spUpdateReview]
	@ReviewId int,   
    @isRead bit
     
AS
BEGIN    
    BEGIN TRY 
	 BEGIN TRANSACTION;
		UPDATE [dbo].[Review]	
		
		SET isRead = @isRead
        WHERE ReviewId = @ReviewId;

        COMMIT TRANSACTION;
	 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetReviewsByEmployeeId]	
    @EmployeeId int 
AS
BEGIN
    
    BEGIN TRY 
		SELECT 
		    Review.ReviewId AS ReviewId,
			Review.EmployeeId AS EmployeeId,
			Review.ReviewId AS ReviewId,
			Review.isRead AS isRead,
			DATEPART(year, Review.ReviewYear) AS Year,
			Quarter.QuarterName AS QuarterName
       FROM 
			Review
	   INNER JOIN 
			Quarter
	   ON Review.QuarterId = Quarter.QuarterId
	   WHERE	
			Review.EmployeeId = @EmployeeId
	  ORDER BY Year DESC
     END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetReviewDetails]	
    @ReviewId int 
AS
BEGIN
    
    BEGIN TRY 
	
		DECLARE @SupervisorEmployee int;

		SELECT @SupervisorEmployee = Employee.SupervisorEmployee
        FROM Employee
        INNER JOIN Review ON Employee.EmployeeId = Review.EmployeeId
        WHERE Review.ReviewId = @ReviewId;

		SELECT 	
			DATEPART(year, Review.ReviewYear) AS Year,
			Review.CompletionDate AS CompletionDate,
			Review.Comment AS Comment,			
			Rating.RatingName AS RatingName,
			Quarter.QuarterName AS QuarterName,
			(SELECT FirstName + ' ' + LastName FROM Employee WHERE EmployeeId = @SupervisorEmployee) AS SupervisorFullName
       FROM 
			Review
	   INNER JOIN 
			Quarter
	   ON Review.QuarterId = Quarter.QuarterId
	   INNER JOIN 
		    Rating
	   ON Review.RatingId = Rating.RatingId
	   INNER JOIN
			Employee
	   ON Review.EmployeeId = Employee.EmployeeId
	   WHERE	
			Review.ReviewId = @ReviewId

     END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO


--CREATE OR ALTER PROCEDURE [dbo].[spGetReviewDetails]	
--    @EmployeeId int 
--AS
--BEGIN
    
--    BEGIN TRY 
	
--		DECLARE @SupervisorEmployee int;

--		SELECT @SupervisorEmployee = Employee.SupervisorEmployee
--        FROM Employee
--        WHERE EmployeeId = @EmployeeId;

--		SELECT 	
--			DATEPART(year, Review.ReviewYear) AS Year,
--			Review.CompletionDate AS CompletionDate,
--			Review.Comment AS Comment,			
--			Rating.RatingName AS RatingName,
--			Quarter.QuarterName AS QuarterName,
--			(SELECT FirstName + ' ' + LastName FROM Employee WHERE EmployeeId = @SupervisorEmployee) AS SupervisorFullName
--       FROM 
--			Review
--	   INNER JOIN 
--			Quarter
--	   ON Review.QuarterId = Quarter.QuarterId
--	   INNER JOIN 
--		    Rating
--	   ON Review.RatingId = Rating.RatingId
--	   INNER JOIN
--			Employee
--	   ON Review.EmployeeId = Employee.EmployeeId
--	   WHERE	
--			Review.EmployeeId = @EmployeeId

--     END TRY
--    BEGIN CATCH
--        THROW;
--    END CATCH
--END
--GO



CREATE OR ALTER PROCEDURE [dbo].[spGetReviewById]	
    @ReviewId int 
AS
BEGIN
    
    BEGIN TRY 
		SELECT 
			ReviewId,
			DATEPART(year, ReviewYear) AS Year,
			Comment,
			CompletionDate, 
			isRead,
			RatingId,
			EmployeeId,
			QuarterId,
			SupervisorEmployee 

		FROM 
			Review
	  WHERE ReviewId = @ReviewId 

     END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployeesByDepartmentId]
@DepartmentId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,
			  Employee.RecordVersion,
              PositionName AS Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.DepartmentId = @DepartmentId AND Employee.StatusId = 1

       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployeesByEmployeeLastName]
@LastName nvarchar(50)
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,
			  Employee.RecordVersion,
              PositionName AS Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.LastName LIKE '%' + @LastName + '%' AND Employee.StatusId = 1
       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllEmployeesByEmployeeNumber]
@EmployeeNumber int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,  
			  Employee.RecordVersion,
              PositionName AS Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.EmployeeNumber = @EmployeeNumber AND Employee.StatusId = 1

       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetAllMobileListEmployees]
AS
BEGIN   
    BEGIN TRY 
  
          SELECT 
			  EmployeeNumber,			  
              LastName,
              FirstName,
			  Employee.RecordVersion,
              PositionName AS Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId   
       WHERE Employee.StatusId = 1
       ORDER BY LastName, FirstName 
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spGetDepartmentByEmployeeId]
@EmployeeId int
AS

BEGIN
	SELECT 
		Department.DepartmentId,
		DepartmentName, 
		Description,
		InvocationDate,
		Department.RecordVersion
	FROM
		Department
	INNER JOIN Employee
	ON Department.DepartmentId = Employee.DepartmentId
	WHERE EmployeeId = @EmployeeId
	
END

GO



CREATE OR ALTER PROC [dbo].[spGetDepartmentById]
@DepartmentId int
AS

BEGIN
	SELECT 
		Department.DepartmentId,
		DepartmentName, 
		Description,
		InvocationDate,
		RecordVersion
	FROM
		Department	
	WHERE DepartmentId = @DepartmentId
	
END

GO



CREATE OR ALTER PROC [dbo].[spGetDepartmentInvocationDateById]
@DepartmentId int
AS

BEGIN
	SELECT 			
		InvocationDate
	FROM
		Department
	WHERE DepartmentId = @DepartmentId	
END

GO



CREATE OR ALTER PROC [dbo].[spGetDepartmentNameById]
@DepartmentId int
AS

BEGIN
	SELECT 		
		DepartmentName
	FROM
		Department
	WHERE DepartmentId = @DepartmentId	
END

GO



CREATE OR ALTER PROC [dbo].[spGetSinByEmployeeId]
@EmployeeId int
AS

BEGIN
	SELECT 		
		SIN
	FROM
		Employee
	WHERE EmployeeId = @EmployeeId
END

GO



CREATE OR ALTER PROC [dbo].[spGetDepartments]
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	ORDER BY
		DepartmentName
END

GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployee]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 

	       SELECT *			
       FROM Employee           
       WHERE EmployeeId = @EmployeeId
  
    --   SELECT FirstName, 
    --          LastName,
    --          Email,
    --          WorkPhone,
    --          SeniorityDate, 
    --          PositionName as Position,
			 -- DepartmentName as Department
    --   FROM Employee
    --   INNER JOIN Position
    --   ON Employee.PositionId = Position.PositionId
	   --INNER JOIN Department
	   --ON Employee.DepartmentId = Department.DepartmentId       
    --   WHERE EmployeeId = @EmployeeId
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeeDetailAsync]
    @EmployeeNumber NVARCHAR(100) 
AS
BEGIN
    BEGIN TRY
        SELECT 
            FirstName,
            MiddleInitial,
            LastName,
            StreetAddress + ', ' + City + ', ' + PostalCode AS HomeMailingAddress,
            WorkPhone,
            CellPhone,
            Email
        FROM 
            Employee
        WHERE
            EmployeeNumber = @EmployeeNumber; 
    END TRY
    BEGIN CATCH       
        THROW; 
    END CATCH
END;
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeeDTO]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  FirstName, 
              LastName,
              Email,
              WorkPhone,
              SeniorityDate, 
              PositionName as Position,
			  DepartmentName as Department
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId
	   INNER JOIN Department
	   ON Employee.DepartmentId = Department.DepartmentId       
       WHERE EmployeeId = @EmployeeId
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeeInfo]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT *
       FROM Employee
           
	   WHERE EmployeeId = @EmployeeId
     
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeePersonal]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  EmployeeNumber,
			  FirstName, 
			  MiddleInitial,
              LastName,
			  Password,
			  PasswordSalt,
              StreetAddress,
			  City,
			  PostalCode,
			  RecordVersion
       FROM Employee      
	   WHERE EmployeeId = @EmployeeId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spGetEmployeePersonalPasswordDTO]
@EmployeeId int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT 
			  EmployeeId,
			  EmployeeNumber,
			  RecordVersion
       FROM Employee      
	   WHERE EmployeeId = @EmployeeId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spGetEmployeeStatus]
AS

BEGIN
	SELECT 
		StatusId,
		StatusName
	FROM
		EmployeeStatus	
	ORDER BY
		StatusName
END

GO



CREATE OR ALTER PROC [dbo].[spGetJobAssignments]
AS

BEGIN
	SELECT 
		PositionId,
		PositionName
	FROM
		Position
	ORDER BY
		PositionName
END

GO



CREATE OR ALTER PROCEDURE [dbo].[spGetRolesList]   
AS
BEGIN
    SELECT 
        Role.RoleId,
        RoleName
    FROM
        Role    
    ORDER BY
        RoleName;
END
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



CREATE OR ALTER PROC [dbo].[spGetSupervisorByRoleIdDepartmentId]
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
            RoleId = 2 AND DepartmentId = @DepartmentId
        ORDER BY
            LastName, FirstName
    END
    ELSE IF @RoleId = 3
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



CREATE OR ALTER PROC [dbo].[spGetAllActiveDepartments]
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	WHERE
		InvocationDate <= GETDATE()
	ORDER BY
		DepartmentName
END



GO



CREATE OR ALTER PROC [dbo].[spGetAllActiveDepartmentsExceptOne]
 @ExcludeDepartmentId INT = NULL  
AS

BEGIN
	SELECT 
		DepartmentId,
		DepartmentName
	FROM
		Department
	WHERE
		InvocationDate <= GETDATE() AND DepartmentId <> ISNULL(@ExcludeDepartmentId, DepartmentId)
	ORDER BY
		DepartmentName
END

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




CREATE OR ALTER PROC [dbo].[spIsDepartmantNameIsUnique]
    @DepartmentName NVARCHAR(128)
AS
BEGIN
    BEGIN TRY
        SELECT * 
        FROM [Department]
        WHERE DepartmentName = @DepartmentName
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO



CREATE OR ALTER PROC [dbo].[spIsSinUnique]
    @SIN NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT * 
        FROM [Employee]
        WHERE SIN = @SIN
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO



CREATE OR ALTER PROC [dbo].[spSupervisorDepartment]	
    @SupervisorId int
AS
BEGIN
    BEGIN TRY
        SELECT DepartmentId
        FROM Employee
        WHERE EmployeeId = @SupervisorId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO



CREATE OR ALTER PROC [dbo].[spIsSupervisorValid]
    @SupervisorId int
AS
BEGIN
    BEGIN TRY
        SELECT COUNT(*)
        FROM [Employee]
        WHERE SupervisorEmployee = @SupervisorId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
GO



CREATE OR ALTER PROC [dbo].[spIsSupervisorDepartmentValid]    
    @SupervisorId int
AS
BEGIN
    BEGIN TRY
        SELECT DepartmentId
        FROM Employee
        WHERE Employee.EmployeeId = @SupervisorId
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
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




CREATE OR ALTER PROC [dbo].[spIsRetirementStatus]
	@EmployeeNumber NVARCHAR(8)	
AS
BEGIN
	BEGIN TRY
		SELECT *			
		FROM
			[Employee]				
		WHERE
			EmployeeNumber = @EmployeeNumber 
			AND StatusId = 2 
				
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spIsTerminationStatus]
	@EmployeeNumber NVARCHAR(8)	
AS
BEGIN
	BEGIN TRY
		SELECT *			
		FROM
			[Employee]				
		WHERE
			EmployeeNumber = @EmployeeNumber 
			AND StatusId = 3 			
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployees]
    @EmployeeNumber nvarchar(8),
    @LastName nvarchar(50)
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
        WHERE EmployeeNumber = @EmployeeNumber OR LastName LIKE '%' + @LastName + '%'
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByActiveDepartment]   
	@DepartmentName nvarchar (128)
AS
BEGIN   
    BEGIN TRY 
        SELECT EmployeeNumber, 
               LastName,
               FirstName,
               WorkPhone,
               OfficeLocation, 
               PositionName as Position,
			   DepartmentName as Department
        FROM Employee
        INNER JOIN Position
        ON Employee.PositionId = Position.PositionId
		INNER JOIN Department
		ON Employee.DepartmentId = Department.DepartmentID		
        WHERE DepartmentName LIKE '%' + @DepartmentName + '%' AND InvocationDate <= GETDATE()
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
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



CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByLastName]    
    @LastName nvarchar(50)
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
        WHERE LastName LIKE '%' + @LastName + '%'
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
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



CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesByLastNameByEmpNumberByDepartmentName]
    @EmployeeNumber nvarchar(8),
    @LastName nvarchar(50),
	@DepartmentName nvarchar (128)
AS
BEGIN   
    BEGIN TRY 
        SELECT EmployeeNumber, 
               LastName,
               FirstName,
               WorkPhone,
               OfficeLocation, 
               PositionName as Position,
			   DepartmentName as Department
        FROM Employee
        INNER JOIN Position
        ON Employee.PositionId = Position.PositionId
		INNER JOIN Department
		ON Employee.DepartmentId = Department.DepartmentID
        WHERE EmployeeNumber = @EmployeeNumber AND LastName LIKE '%' + @LastName + '%' AND DepartmentName = @DepartmentName 
        ORDER BY LastName, FirstName  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO




CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesMobileListDepartmentIdAndByEmployeeNumber]
@DepartmentId int,
@EmployeeNumber int
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,             
              PositionName as Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.EmployeeNumber = @EmployeeNumber
	   AND Employee.DepartmentId = @DepartmentId AND Employee.StatusId = 1

       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spSearchEmployeesMobileListDepartmentIdAndByLastName]
@DepartmentId int,
@LastName nvarchar(50)
AS
BEGIN   
    BEGIN TRY 
  
       SELECT EmployeeNumber,			  
              LastName,
              FirstName,             
              PositionName as Position
       FROM Employee
       INNER JOIN Position
       ON Employee.PositionId = Position.PositionId       
	   WHERE Employee.LastName LIKE '%' + @LastName + '%'
	   AND Employee.DepartmentId = @DepartmentId AND Employee.StatusId = 1
       ORDER BY LastName, FirstName
	  
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spSupervisorList]
AS

BEGIN
	SELECT 
		Employee.EmployeeId,
		LastName + ', ' + FirstName AS Name
		
	FROM
		Employee	

	WHERE (RoleId = 1 OR RoleId = 2) OR EmployeeId = 1
	ORDER BY
		Name
END

GO



CREATE OR ALTER PROC [dbo].[spIsSupervisorChanged]
@EmployeeId int
AS

BEGIN
	SELECT 
		SupervisorEmployee
	FROM
		Employee
	WHERE 
		EmployeeId = @EmployeeId
	
END

GO



CREATE OR ALTER PROC [dbo].[spSupervisorEmployeeList]
AS

BEGIN
	SELECT 
		Employee.EmployeeId,
		LastName + ', ' + FirstName AS Name,
		ISNULL(Department.DepartmentName, 'CEO') AS Department
	FROM
		Employee
	LEFT JOIN
	Department
	ON Employee.DepartmentId = Department.DepartmentId

	WHERE (Employee.RoleId = 1 OR Employee.RoleId = 2) OR Employee.EmployeeId = 1
	ORDER BY
		Name
END

GO



CREATE OR ALTER PROCEDURE [spUpdateDepartment]
	@RecordVersion ROWVERSION,
    @DepartmentId INT,
    @DepartmentName NVARCHAR(128),
    @Description NVARCHAR(512),
	@InvocationDate DATETIME2,
	@NewRecordVersion ROWVERSION OUTPUT
AS
BEGIN	
	BEGIN TRY 

	 IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [DepartmentId] = @DepartmentId)
            THROW 50001, 'No such department exists.', 1;

	DECLARE @CurrentRecordVersion ROWVERSION = (SELECT RecordVersion FROM Department WHERE DepartmentId = @DepartmentId);
        IF @RecordVersion <> @CurrentRecordVersion
            THROW 51002, 'The record has been updated since you last retrieved it.', 1;

	BEGIN TRANSACTION
		 UPDATE [dbo].[Department]
			SET 
				[DepartmentName] = @DepartmentName, 
				[Description] = @Description,
				[InvocationDate] = @InvocationDate
			WHERE 
            [DepartmentId] = @DepartmentId;  
			
			SET @NewRecordVersion = (SELECT RecordVersion FROM Department WHERE DepartmentId = @DepartmentId);  

        COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;
GO



CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeeInfo]
	@RecordVersion ROWVERSION,
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
	@StatusId int,
	@NewRecordVersion ROWVERSION OUTPUT

AS
BEGIN
	BEGIN TRY 
	DECLARE @CurrentRecordVersion ROWVERSION = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId);
        IF @RecordVersion <> @CurrentRecordVersion
            THROW 51002, 'The record has been updated since you last retrieved it.', 1;

    BEGIN TRANSACTION;
    
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

			SET @NewRecordVersion = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId); 

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeePersonal]
    @RecordVersion ROWVERSION,
	@EmployeeId INT,
    @StreetAddress NVARCHAR(255),
    @City NVARCHAR(255),
    @PostalCode NVARCHAR(7),
	@NewRecordVersion ROWVERSION OUTPUT
AS
BEGIN   
    BEGIN TRY 
	DECLARE @CurrentRecordVersion ROWVERSION = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId);
        IF @RecordVersion <> @CurrentRecordVersion
            THROW 51002, 'The record has been updated since you last retrieved it.', 1;
	
	BEGIN TRANSACTION;

	UPDATE Employee
    SET
        StreetAddress = @StreetAddress,
        City = @City,
        PostalCode = @PostalCode
    WHERE
        EmployeeId = @EmployeeId

		SET @NewRecordVersion = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId); 

        COMMIT TRANSACTION;
     
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE [dbo].[spUpdateEmployeePersonalPassword]
	@RecordVersion ROWVERSION,
	@EmployeeId INT,
    @Password char(64),
    @PasswordSalt binary(16),
	@NewRecordVersion ROWVERSION OUTPUT
AS
BEGIN   
    BEGIN TRY 

	DECLARE @CurrentRecordVersion ROWVERSION = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId);
        IF @RecordVersion <> @CurrentRecordVersion
            THROW 51002, 'The record has been updated since you last retrieved it.', 1;

			BEGIN TRANSACTION;

				UPDATE Employee
					SET
					 Password =  @Password,       
					 PasswordSalt = @PasswordSalt
    WHERE
        EmployeeId = @EmployeeId     

		SET @NewRecordVersion = (SELECT RecordVersion FROM Employee WHERE EmployeeId = @EmployeeId); 

        COMMIT TRANSACTION;

   END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH
END
GO



CREATE OR ALTER PROC [dbo].[spIsDepartmantNameIsUnique]
    @DepartmentName NVARCHAR(128)
AS
BEGIN
    BEGIN TRY
        SELECT * 
        FROM [Department]
        WHERE DepartmentName = @DepartmentName
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END
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

USE [master];
GO