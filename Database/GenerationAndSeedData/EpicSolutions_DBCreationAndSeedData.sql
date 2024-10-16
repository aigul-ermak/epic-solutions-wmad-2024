/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Create Database and Seed Data
Version: 3.1
*/





USE [master];
GO
-- Delete old database
IF DB_ID('EpicSolutions') IS NOT NULL
BEGIN
	DROP DATABASE EpicSolutions;
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'EpicSolutions database has been DELETED'
		PRINT '------------------------------------------------------------------------------------------';
END

GO

--Create EpicSolutions database 

IF DB_ID('EpicSolutions') IS NULL
BEGIN
	CREATE DATABASE EpicSolutions;
	
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'EpicSolutions database has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
	
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Database exist';
		PRINT '------------------------------------------------------------------------------------------';
	END

GO

USE EpicSolutions;
GO 

-- Create table Role

IF OBJECT_ID('EpicSolutions.dbo.Role ') IS NULL
	BEGIN 
	CREATE TABLE [Role] (
		RoleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		RoleName NVARCHAR(30) NOT NULL
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Role tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Role tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO

-- Create table Status

IF OBJECT_ID('EpicSolutions.dbo.ItemStatus ') IS NULL
	BEGIN 
	CREATE TABLE ItemStatus (
		StatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		StatusName NVARCHAR(20) NOT NULL
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'ItemStatus tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'ItemStatus tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO

-- Create table Status

IF OBJECT_ID('EpicSolutions.dbo.OrderStatus ') IS NULL
	BEGIN 
	CREATE TABLE OrderStatus (
		StatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		StatusName NVARCHAR(20) NOT NULL
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'OrderStatus tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'OrderStatus tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO


-- Create table Department

IF OBJECT_ID('EpicSolutions.dbo.Department ') IS NULL
	BEGIN 
	CREATE TABLE [Department] (
		DepartmentId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		DepartmentName NVARCHAR(128) NOT NULL,
		[Description] NVARCHAR(512) NOT NULL,
		InvocationDate DATETIME2(7) NOT NULL,
		RecordVersion ROWVERSION
		CONSTRAINT UQ_Department_DepartnemtName UNIQUE (DepartmentName)
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Department tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Department tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO

-- Create table Position

IF OBJECT_ID('EpicSolutions.dbo.Position') IS NULL
BEGIN 
    CREATE TABLE [Position] (
        PositionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PositionName NVARCHAR(255) NOT NULL        
    )
    PRINT '------------------------------------------------------------------------------------------';
    PRINT 'Position table has been created';
    PRINT '------------------------------------------------------------------------------------------';
END
ELSE
BEGIN
    PRINT '------------------------------------------------------------------------------------------';
    PRINT 'Position table exists';
    PRINT '------------------------------------------------------------------------------------------';
END


-- Create table EmployeeStatus

IF OBJECT_ID('EpicSolutions.dbo.EmployeeStatus ') IS NULL
	BEGIN 
	CREATE TABLE [EmployeeStatus] (
		StatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		StatusName NVARCHAR(50) NOT NULL
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO

-- Create table Quarter

IF OBJECT_ID('EpicSolutions.dbo.Quarter') IS NULL
	BEGIN 
	CREATE TABLE [Quarter] (
		QuarterId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		QuarterName NVARCHAR(30) NOT NULL,
		StartMonth INT NOT NULL,
		EndMonth INT NOT NULL,
		StartDate INT NOT NULL,
		EndDate INT NOT NULL,
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO

-- Create table Rating

IF OBJECT_ID('EpicSolutions.dbo.Rating') IS NULL
	BEGIN 
	CREATE TABLE [Rating] (
		RatingId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		RatingName NVARCHAR(50) NOT NULL		
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Status tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO


-- Create table Employee
 
IF OBJECT_ID('EpicSolutions.dbo.Employee') IS NULL
	BEGIN
	CREATE TABLE [Employee] (
		EmployeeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		EmployeeNumber AS RIGHT('00000000' + CAST(EmployeeId AS VARCHAR(8)), 8) PERSISTED,
		[Password] CHAR(64) NOT NULL,
		PasswordSalt BINARY(16) NOT NULL,
		FirstName NVARCHAR(50) NOT NULL,
		MiddleInitial NVARCHAR(1) NULL,
		LastName NVARCHAR(50) NOT NULL,
		StreetAddress NVARCHAR(255) NOT NULL,
		City NVARCHAR(255) NOT NULL,
		PostalCode NVARCHAR(7) NOT NULL,
		DOB DATETIME2(7) NOT NULL,
		[SIN] NVARCHAR(50) NOT NULL,
		SeniorityDate DATETIME2(7) NOT NULL,
		RetirementDate DATETIME2(7) NULL,
		TerminationDate DATETIME2(7) NULL,
		JobStartDate DATETIME2(7) NULL,
		SupervisorEmployee INT NULL,
		OfficeLocation NVARCHAR(255) NOT NULL, 
		WorkPhone NVARCHAR(14) NOT NULL,
		CellPhone NVARCHAR(14) NOT NULL,
		Email NVARCHAR(255) NOT NULL,
		isSupervisor BIT NULL,
		DepartmentId INT NULL,
		PositionId INT NULL,
		RoleId INT NULL,
		StatusId INT NOT NULL,
		RecordVersion ROWVERSION,
		CONSTRAINT FK_Employee_Role FOREIGN KEY (RoleId) REFERENCES [Role](RoleId),
		CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
		CONSTRAINT FK_Employee_Position FOREIGN KEY (PositionId) REFERENCES Position(PositionId),
		CONSTRAINT FK_Employee_Supervisor FOREIGN KEY (SupervisorEmployee) REFERENCES [Employee](EmployeeId),
		CONSTRAINT FK_Employee_Status FOREIGN KEY (StatusId) REFERENCES [EmployeeStatus](StatusId),
		CONSTRAINT UQ_Employee_Number UNIQUE (EmployeeNumber),
		CONSTRAINT UQ_Employee_SIN UNIQUE ([SIN])
		)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Employee table has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Employee table exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO




-- Create table Review

IF OBJECT_ID('EpicSolutions.dbo.Review') IS NULL
    BEGIN 
        CREATE TABLE [Review] (
            ReviewId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
            ReviewYear DATE NOT NULL,
            Comment NVARCHAR(MAX) NOT NULL,
            CompletionDate DATETIME2(7) NULL,
            isRead BIT NULL,
            RatingId INT,
            EmployeeId INT, 
            QuarterId INT, 
            SupervisorEmployee INT, 
            CONSTRAINT FK_Employee_Rating FOREIGN KEY (RatingId) REFERENCES [Rating](RatingId),
            CONSTRAINT FK_Employee_Employee FOREIGN KEY (EmployeeId) REFERENCES [Employee](EmployeeId),
            CONSTRAINT FK_Employee_Quarter FOREIGN KEY (QuarterId) REFERENCES [Quarter](QuarterId),
            CONSTRAINT FK_Review_Employee_Supervisor FOREIGN KEY (SupervisorEmployee) REFERENCES [Employee](EmployeeId)
        )
        PRINT '------------------------------------------------------------------------------------------';
        PRINT 'Status table has been created';
        PRINT '------------------------------------------------------------------------------------------';
    END
ELSE
    BEGIN
        PRINT '------------------------------------------------------------------------------------------';
        PRINT 'Status table exists';
        PRINT '------------------------------------------------------------------------------------------';
    END

GO



-- Create table Order


IF OBJECT_ID('EpicSolutions.dbo.Order') IS NULL
BEGIN 
    CREATE TABLE [Order] (
        OrderId INT IDENTITY(101,1) NOT NULL PRIMARY KEY,
		PONumber AS RIGHT('00000000' + CAST(OrderId AS VARCHAR(8)), 8) PERSISTED,
        CreationDate DATETIME2(7) NOT NULL,
        EmployeeId INT NOT NULL,
        StatusId INT NOT NULL,
		RecordVersion ROWVERSION,
        CONSTRAINT FK_Employee_PO FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId),
        CONSTRAINT FK_Status_PO FOREIGN KEY (StatusId) REFERENCES [OrderStatus](StatusId),
		CONSTRAINT UQ_Order_PONumber UNIQUE (PONumber)
    )
    PRINT '------------------------------------------------------------------------------------------';
    PRINT 'Order table has been created'
    PRINT '------------------------------------------------------------------------------------------';
END
ELSE
BEGIN
    PRINT '------------------------------------------------------------------------------------------';
    PRINT 'Order table exists';
    PRINT '------------------------------------------------------------------------------------------';
END
GO

-- Create table Item

IF OBJECT_ID('EpicSolutions.dbo.Item') IS NULL
	BEGIN 
	CREATE TABLE Item (
		ItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ItemName NVARCHAR(45) NOT NULL,
		ItemDescription NVARCHAR(255) NOT NULL,
		ItemQuantity INT NOT NULL,
		ItemPrice MONEY NOT NULL,
		ItemPurchaseLocation NVARCHAR(255) NOT NULL,
		ItemJustification NVARCHAR(255) NOT NULL,
		OrderId Int NOT NULL,
		StatusId Int NOT NULL,
		DenyReason NVARCHAR(255) NULL,
		EditReason NVARCHAR(255) NULL,
		RecordVersion ROWVERSION,
		CONSTRAINT FK_Item_PO FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
		CONSTRAINT FK_Status_Detail FOREIGN KEY (StatusId) REFERENCES [ItemStatus](StatusId)
	)
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Item tabel has been created'
		PRINT '------------------------------------------------------------------------------------------';
	END
ELSE
	BEGIN
		PRINT '------------------------------------------------------------------------------------------';
		PRINT 'Item tabel exist';
		PRINT '------------------------------------------------------------------------------------------';
END

GO





--SEED TABLES
-----------------------------------------------------------------------------------------------

 -- Add Roles

SET IDENTITY_INSERT [dbo].[Role] ON 
GO
 
INSERT INTO [Role] (RoleId, RoleName)
VALUES 
	(1, 'HR Supervisor'),
	(2, 'Regular Supervisor'),
	(3, 'HR Employee'),
	(4, 'Regular Employee')
 

SET IDENTITY_INSERT [dbo].[Role] OFF 
GO

SET IDENTITY_INSERT [dbo].[EmployeeStatus] ON

INSERT INTO [EmployeeStatus] (StatusId, StatusName)
VALUES 
    (1, 'Active'),
    (2, 'Retired'),
    (3, 'Terminated');

SET IDENTITY_INSERT [dbo].[EmployeeStatus] OFF


SET IDENTITY_INSERT [dbo].[ItemStatus] ON 
GO
 
INSERT INTO [ItemStatus] (StatusId, StatusName)
VALUES 
	(1, 'Approve'),
	(2, 'Pending'),
	(3, 'Deny')

SET IDENTITY_INSERT [dbo].[ItemStatus] OFF 
GO

SET IDENTITY_INSERT [dbo].[OrderStatus] ON 
GO
 
INSERT INTO [OrderStatus] (StatusId, StatusName)
VALUES 
	(1, 'Close'),
	(2, 'Pending'),
	(3, 'Under Review')
 

SET IDENTITY_INSERT [dbo].[OrderStatus] OFF 
GO

SET IDENTITY_INSERT [dbo].[Department] ON 
GO
 
INSERT INTO [Department] (DepartmentId, DepartmentName, [Description], InvocationDate)
VALUES 
	(1, 'Board of Directors','The Department is responsible for overseeing the strategic direction and governance of the organization','01/01/2010'),
	(2, 'Business Development','The Department is focused on identifying growth opportunities and building strategic partnerships to drive the organization`s expansion and market presence.','01/01/2010'),
	(3, 'Design Services','The Department specializes in crafting creative, visually compelling designs and solutions that align with brand identity and client needs.','01/01/2010'),
	(4, 'Customer Service','The Department is dedicated to providing exceptional support and assistance, ensuring positive customer experiences and resolving inquiries efficiently.','01/01/2010'),
	(5, 'Finance','The Department manages the organization`s financial resources, oversees budgeting, and ensures fiscal stability through accurate accounting and strategic financial planning.','01/01/2010'),
	(6, 'General Management','The Department is responsible for overseeing the organization`s overall operations, ensuring effective leadership, strategic planning, and achieving business objectives across various departments.','01/01/2010'),
	(7, 'Human Resources','The Department manages employee relations, recruitment, training, benefits, and compliance, ensuring a productive and positive workplace culture that aligns with organizational goals.','01/01/2010'),
	(8, 'Information Technology','The Department is responsible for managing the organization`s tech infrastructure, cybersecurity, and digital resources, supporting efficient and secure operations across all departments.','01/01/2010'),
	(9, 'Security Services','The Department ensures the safety of personnel, assets, and information by implementing and overseeing security protocols, threat assessments, and emergency response strategies.','01/01/2010'),
	(10, 'Marketing','The Department crafts and implements strategies to promote products and services, enhancing brand awareness, customer engagement, and market reach.','01/01/2010'),
	(11, 'Operations','The Department optimizes processes and manages resources, ensuring efficient production, quality control, and seamless delivery of goods or services.','01/01/2010'),
	(12, 'Quality Assurance','The Department is responsible for ensuring that products and services meet established standards and specifications, improving customer satisfaction through rigorous testing and continuous process improvement.','01/01/2010'),
	(13, 'Sales','The Department is focused on generating revenue by building and maintaining relationships with clients, promoting products and services, and achieving business targets through effective negotiation and customer engagement strategiest','01/01/2010'),
	(14, 'Purchasing','The Department manages the acquisition of goods and services required by the organization, ensuring cost-effectiveness, quality standards, and timely delivery through strategic supplier relationships and procurement processes.','01/01/2010'),
	(15, 'Production','The Department oversees the transformation of raw materials into finished goods, ensuring efficient manufacturing processes, quality control, and timely delivery to meet customer demands and organizational goals.','01/01/2010'),
	(16, 'N/A','N/A','01/01/2010')
 
SET IDENTITY_INSERT [dbo].[Department] OFF 
GO

SET IDENTITY_INSERT [dbo].[Position] ON 
GO
 
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (1, N'CEO')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (2, N'HR Supervisor')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (3, N'Project Manager Supervisor')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (4, N'HR Talent Acquisition')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (5, N'Developer Supervisor')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (6, N'Infrastructure Supervisor')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (7, N'Systems Analyst')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (8, N'Solution Architect')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (9, N'Software Engineer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (10, N'Network Engineer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (11, N'Database Administrator')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (12, N'Cybersecurity Specialist')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (13, N'QA Engineer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (14, N'Technical Support Engineer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (15, N'Business Analyst')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (16, N'DevOps Engineer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (17, N'Product Supervisor')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (18, N'UI/UX Designer')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (19, N'HR Assistant')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (20, N'HR Specialist')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (21, N'QA Manager')
INSERT [dbo].[Position] ([PositionId], [PositionName]) VALUES (22, N'Desiner Supervisor')

 
SET IDENTITY_INSERT [dbo].[Position] OFF 
GO

SET IDENTITY_INSERT [dbo].[Quarter] ON 

INSERT [dbo].[Quarter] ([QuarterId], [QuarterName], [StartMonth], [EndMonth], [StartDate], [EndDate]) VALUES (1, N'Q1: Jan 1 - Mar 31', 1, 3, 1, 31)
INSERT [dbo].[Quarter] ([QuarterId], [QuarterName], [StartMonth], [EndMonth], [StartDate], [EndDate]) VALUES (2, N'Q2: Apr 1 - Jun 30', 4, 6, 1, 30)
INSERT [dbo].[Quarter] ([QuarterId], [QuarterName], [StartMonth], [EndMonth], [StartDate], [EndDate]) VALUES (3, N'Q3: Jul 1 - Sep 30', 7, 9, 1, 30)
INSERT [dbo].[Quarter] ([QuarterId], [QuarterName], [StartMonth], [EndMonth], [StartDate], [EndDate]) VALUES (4, N'Q4: Oct 1 - Dec 31', 10, 12, 1, 31)
SET IDENTITY_INSERT [dbo].[Quarter] OFF
GO
SET IDENTITY_INSERT [dbo].[Rating] ON 

INSERT [dbo].[Rating] ([RatingId], [RatingName]) VALUES (1, N'Below Expectations')
INSERT [dbo].[Rating] ([RatingId], [RatingName]) VALUES (2, N'Meets Expectations')
INSERT [dbo].[Rating] ([RatingId], [RatingName]) VALUES (3, N'Exceeds Expectations')
SET IDENTITY_INSERT [dbo].[Rating] OFF
GO

SET IDENTITY_INSERT [dbo].[Employee] ON 
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (1, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Quon', N'B', N'Rollins', N'Ap #978-1940 Nunc St.', N'Okotoks', N'S7K 1W8', CAST(N'1986-12-12T00:00:00.0000000' AS DateTime2), N'987-654-604', CAST(N'2018-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, NULL, N'Down Town', N'770-661-2425', N'504-667-8556', N'rollins-quon@epicsolution.org', NULL, 16, 1, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (2, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Paula', N'A', N'King', N'122-3594 Pede, Road', N'Prince George', N'T0J 3K0', CAST(N'1999-12-12T00:00:00.0000000' AS DateTime2), N'987-654-891', CAST(N'2019-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'357-667-2036', N'857-891-9515', N'king.paula@epicsolution.org', NULL, 7, 2, 1, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (3, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Channing', N'B', N'Livingston', N'Ap #592-2505 Dolor St.', N'Morrisburg', N'M1E 3T8', CAST(N'1976-12-12T00:00:00.0000000' AS DateTime2), N'987-654-616', CAST(N'2022-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Industrial park', N'805-362-6887', N'904-224-8237', N'c_livingston2328@epicsolution.org', NULL, 2, 3, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (4, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Piper', N'B', N'Trevino', N'261-4449 Ante St.', N'Edmonton', N'K7L 1C2', CAST(N'2000-12-12T00:00:00.0000000' AS DateTime2), N'987-654-991', CAST(N'2016-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'719-564-2466', N'770-459-4478', N'pipertrevino@epicsolution.org', NULL, 8, 5, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (5, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Oleg', N'L', N'Delaney', N'830-8864 Montes, St.', N'Vancouver', N'K1Z 7B5', CAST(N'1975-12-10T00:00:00.0000000' AS DateTime2), N'987-654-860', CAST(N'2022-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'227-767-8530', N'216-143-4296', N'o_delaney@epicsolution.org', NULL, 4, 6, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (6, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Jesse', N'E', N'Holcomb', N'897-1615 Volutpat. St.', N'Toronto', N'L6W 1Z2', CAST(N'2001-12-12T00:00:00.0000000' AS DateTime2), N'987-654-718', CAST(N'2023-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'615-616-1761', N'535-489-8864', N'holcombjesse@epicsolution.org', NULL, 6, 17, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (7, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Hamilton', N'V', N'Rice', N'P.O. Box 621, 8855 Dis Street', N'Montreal', N'T0M 2A0', CAST(N'1997-12-11T00:00:00.0000000' AS DateTime2), N'987-654-532', CAST(N'2019-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'538-785-1325', N'775-254-4566', N'h_rice@epicsolution.org', NULL, 3, 22, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (8, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Jonah', N'L', N'Guzman', N'4670 Aliquet St.', N'Black Lake', N'H4N 3C5', CAST(N'1992-12-12T00:00:00.0000000' AS DateTime2), N'987-654-539', CAST(N'2016-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'553-191-5911', N'736-147-8705', N'j.guzman9973@epicsolution.org', NULL, 12, 21, 2, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (9, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Mira', N'S', N'Abbott', N'Ap #445-7719 Orci. St.', N'Dieppe', N'V2C 5R8', CAST(N'1983-12-12T00:00:00.0000000' AS DateTime2), N'987-654-359', CAST(N'2019-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 2, N'Industrial park', N'317-719-4529', N'341-943-9333', N'abbott.mira@epicsolution.org', NULL, 7, 4, 3, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (10, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Ayanna', N'P', N'Mays', N'P.O. Box 412, 7047 Imperdiet Av.', N'Burlington', N'S4P 3Y2', CAST(N'1981-12-12T00:00:00.0000000' AS DateTime2), N'987-654-754', CAST(N'2022-12-12T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 6, N'Down Town', N'257-497-3126', N'756-857-5957', N'm_ayanna3228@epicsolution.org', NULL, 6, 7, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (11, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Graham', N'G', N'Sargent', N'642-5801 Ac, Av.', N'Dieppe', N'V0E 2V0', CAST(N'1986-11-11T00:00:00.0000000' AS DateTime2), N'987-654-965', CAST(N'2018-11-07T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 6, N'Down Town', N'479-477-6252', N'248-754-8611', N'g-sargent9584@epicsolution.org', NULL, 6, 8, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (12, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Giacomo', N'J', N'Greer', N'315-9813 Purus. Av.', N'Fort Liard', N'L0H 1G0', CAST(N'1998-08-11T00:00:00.0000000' AS DateTime2), N'987-654-810', CAST(N'2016-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'527-322-3578', N'245-886-7568', N'g-greer@epicsolution.org', NULL, 8, 9, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (13, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Tashya', N'R', N'Conley', N'276-2470 Eget Rd.', N'London', N'J0G 1P0', CAST(N'1986-11-11T00:00:00.0000000' AS DateTime2), N'987-654-536', CAST(N'2021-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'421-932-3790', N'392-348-1551', N'conley_tashya@epicsolution.org', NULL, 8, 10, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (14, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Cameran', N'O', N'Alvarez', N'Ap #171-7363 Tristique Street', N'Muntinlupa', N'G1R 1B8', CAST(N'1978-11-11T00:00:00.0000000' AS DateTime2), N'987-654-815', CAST(N'2019-11-14T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'536-945-2041', N'672-375-1528', N'a-cameran8903@epicsolution.org', NULL, 8, 11, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (15, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Zelda', N'P', N'Ortega', N'Ap #154-3875 Sociis Av.', N'Panabo', N'C1B 3V3', CAST(N'1997-11-11T00:00:00.0000000' AS DateTime2), N'987-654-992', CAST(N'2017-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'442-345-3483', N'316-388-5154', N'z-ortega6898@epicsolution.org', NULL, 8, 12, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (16, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Carly', N'C', N'Humphrey', N'Ap #316-3152 Justo Rd.', N'Woodbridge', N'J0V 1P0', CAST(N'1990-11-11T00:00:00.0000000' AS DateTime2), N'987-654-371', CAST(N'2022-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 8, N'Down Town', N'280-566-7208', N'457-596-5117', N'c_humphrey@epicsolution.org', NULL, 12, 13, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (17, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Kadeem', N'H', N'Bond', N'Ap #561-1065 Et St.', N'Arequipa', N'X0A 0N0', CAST(N'1998-11-11T00:00:00.0000000' AS DateTime2), N'987-654-880', CAST(N'2020-10-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 5, N'Industrial park', N'730-778-1422', N'742-930-6200', N'kadeembond7874@epicsolution.org', NULL, 4, 14, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (18, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Lillith', N'H', N'King', N'613-5544 In Avenue', N'Jilin', N'T4N 2A6', CAST(N'1989-11-04T00:00:00.0000000' AS DateTime2), N'987-654-970', CAST(N'2022-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 3, N'Down Town', N'615-348-1851', N'333-864-5171', N'king.lillith@epicsolution.org', NULL, 2, 15, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (19, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Hedy', N'K', N'Carrillo', N'642-8746 Egestas, Road', N'Kinross', N'V5T 2C1', CAST(N'1991-11-06T00:00:00.0000000' AS DateTime2), N'987-654-941', CAST(N'2022-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'381-280-8614', N'604-657-0724', N'h_carrillo237@epicsolution.org', NULL, 8, 16, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (20, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Inez', N'K', N'Knight', N'Ap #839-8520 Mauris. Road', N'Whangarei', N'L8P 1P8', CAST(N'1982-11-11T00:00:00.0000000' AS DateTime2), N'987-654-436', CAST(N'2020-11-11T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 7, N'Down Town', N'944-989-3221', N'521-121-1661', N'i_knight@epicsolution.org', NULL, 3, 18, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (21, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Jermaine', N'H', N'Casey', N'P.O. Box 352, 1286 Egestas. Street', N'Jayapura', N'J6E 3E8', CAST(N'1997-11-11T00:00:00.0000000' AS DateTime2), N'987-654-937', CAST(N'2017-11-25T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 8, N'Down Town', N'689-617-4367', N'632-507-0154', N'casey.jermaine@epicsolution.org', NULL, 12, 16, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (22, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Katelyn', N'H', N'Schwartz', N'Ap #382-7725 Dignissim Av.', N'Courtenay', N'N9A 7A2', CAST(N'1992-11-11T00:00:00.0000000' AS DateTime2), N'987-654-578', CAST(N'2018-11-15T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 2, N'Down Town', N'594-127-4896', N'184-475-5380', N'schwartzkatelyn5205@epicsolution.org', NULL, 7, 19, 3, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (23, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Jason', N'S', N'Keith', N'497-681 Eu Ave', N'Corby', N'S6V 5R4', CAST(N'1984-11-04T00:00:00.0000000' AS DateTime2), N'987-654-838', CAST(N'2020-11-18T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 2, N'Down Town', N'456-695-7253', N'876-367-8456', N'j_keith3672@epicsolution.org', NULL, 7, 20, 3, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (24, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Elliott', N'Q', N'Bond', N'P.O. Box 200, 1447 Dolor Road', N'Baybay', N'N2H 5A5', CAST(N'1986-11-24T00:00:00.0000000' AS DateTime2), N'987-654-615', CAST(N'2020-11-20T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'506-3774752', N'516-321-0299', N'aaa@gmail.com', NULL, 8, 16, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (25, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Scarlett', N'A', N'Dominguez', N'132-8820 Sed Avenue', N'Winnipeg', N'T0H 0E0', CAST(N'2000-11-13T00:00:00.0000000' AS DateTime2), N'987-654-942', CAST(N'2018-11-07T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 8, N'Industrial park', N'345-271-3419', N'281-258-4542', N's-dominguez@epicsolution.org', NULL, 12, 13, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (26, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Simon', N'L', N'Schultz', N'2061 Mauris Avenue', N'St Pierre', N'K0A 1R0', CAST(N'1995-11-21T00:00:00.0000000' AS DateTime2), N'987-654-645', CAST(N'2023-11-04T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'805-514-3851', N'864-374-6710', N'simonschultz@epicsolution.org', NULL, 8, 9, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (27, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Jameson', N'D', N'Cervantes', N'Ap #489-6566 Lobortis Rd.', N'Stittsville', N'N0N 1G0', CAST(N'1989-11-28T00:00:00.0000000' AS DateTime2), N'987-654-643', CAST(N'2021-11-28T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 4, N'Down Town', N'121-636-8886', N'215-278-7726', N'cervantes-jameson4735@epicsolution.org', NULL, 8, 9, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (28, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Frances', N'J', N'Lambert', N'Ap #507-4123 Lorem Avenue', N'Yurimaguas', N'P0H 1E0', CAST(N'1977-11-07T00:00:00.0000000' AS DateTime2), N'987-654-688', CAST(N'2020-11-11T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-05-01T00:00:00.0000000' AS DateTime2), NULL, 4, N'Down Town', N'578-436-7745', N'200-840-9104', N'lambertfrances8500@epicsolution.org', NULL, 8, 16, 4, 3)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (29, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Melanie', N'J', N'Moon', N'Ap #491-1670 Amet, Avenue', N'Tarbes', N'M6E 1R1', CAST(N'1958-11-14T00:00:00.0000000' AS DateTime2), N'987-654-814', CAST(N'2023-11-23T00:00:00.0000000' AS DateTime2), CAST(N'2024-04-30T00:00:00.0000000' AS DateTime2), NULL, NULL, 4, N'Down Town', N'458-988-1426', N'374-404-3772', N'm-moon@epicsolution.org', NULL, 4, 16, 4, 2)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (30, N'd2a232d95451c7d6a4264ab1fec586560fb8cc6ff59f7ea542260293b1fe5395', 0xDE12A6FD00D1ADDDC5986C978BB1CDA8, N'Keegan', N'J', N'Montgomery', N'P.O. Box 868, 7476 A Avenue', N'Burnaby', N'P3E 5K3', CAST(N'1955-11-25T00:00:00.0000000' AS DateTime2), N'987-654-839', CAST(N'2021-11-09T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 7, N'Industrial park', N'504-282-3230', N'754-287-4073', N'mkeegan@epicsolution.org', NULL, 3, 18, 4, 1)
INSERT [dbo].[Employee] ([EmployeeId], [Password], [PasswordSalt], [FirstName], [MiddleInitial], [LastName], [StreetAddress], [City], [PostalCode], [DOB], [SIN], [SeniorityDate], [RetirementDate], [TerminationDate], [JobStartDate], [SupervisorEmployee], [OfficeLocation], [WorkPhone], [CellPhone], [Email], [isSupervisor], [DepartmentId], [PositionId], [RoleId], [StatusId]) VALUES (31, N'1e9a524fc190fd26a229760838bcc8e78002c99efc2d32d901690ee09f93b329', 0x3D6FAE5D19AEFA146083AA0A33F13FEB, N'Lena', NULL, N'Headdy', N'73 Twin', N'Moncton', N'E1G 6A8', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), N'999-888-777', CAST(N'2024-05-01T00:00:00.0000000' AS DateTime2), NULL, NULL, NULL, 1, N'Down Town', N'121-152-5555', N'506-355-4785', N'aaa@aaa.com', 0, 8, 5, 2, 1)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO


SET IDENTITY_INSERT [dbo].[Order] ON 
GO
 
INSERT INTO [Order] (OrderId, CreationDate, EmployeeId, StatusId)
VALUES 
    (101, '2023-06-01 10:25:00', 22, 2),
    (102, '2023-06-09 09:22:00', 11, 3),
    (103, '2023-06-13 11:11:00', 4, 2),
    (104, '2023-06-21 12:22:00', 12, 2),
    (105, '2023-06-22 10:30:00', 6, 3),
    (106, '2023-07-03 10:34:00', 6, 3),
    (107, '2023-07-06 10:54:00', 9, 2),
    (108, '2023-07-08 10:22:00', 23, 2),
    (109, '2023-07-11 10:00:00', 6, 3),
    (110, '2023-07-12 10:08:00', 6, 1),
    (111, '2023-07-19 13:35:00', 17, 2),
    (112, '2023-07-23 14:00:00', 23, 2),
    (113, '2023-08-02 10:33:00', 20, 2),
    (114, '2023-08-05 12:44:00', 13, 2),
    (115, '2023-08-14 10:55:00', 17, 2),
    (116, '2023-08-22 11:44:00', 1, 2),
    (117, '2023-08-24 09:33:00', 17, 2),
    (118, '2023-08-25 09:22:00', 23, 2),
    (119, '2023-08-26 09:22:00', 6, 3),
    (120, '2023-08-27 06:11:00', 6, 3),
    (121, '2023-09-03 10:00:00', 17, 2), -- generated
	(122, '2023-09-06 14:32:00', 19, 2),
	(123, '2023-09-22 09:56:00', 7, 2),
	(124, '2023-09-27 16:28:00', 8, 2),
	(125, '2023-09-29 12:49:00', 15, 2),
	(126, '2023-10-01 08:37:00', 3, 2),
	(127, '2023-10-03 15:24:00', 10, 1),
	(128, '2023-10-06 11:58:00', 10, 3),
	(129, '2023-10-09 13:41:00', 10, 1),
	(130, '2023-10-12 10:26:00', 14, 2),
	(131, '2023-10-16 17:53:00', 18, 2),
	(132, '2023-10-19 12:38:00', 10, 1),
	(133, '2023-11-02 09:47:00', 10, 1),
	(134, '2023-11-05 15:34:00', 4, 2),
	(135, '2023-11-08 11:21:00', 13, 2),
	(136, '2023-11-10 17:52:00', 6, 3),
	(137, '2023-11-12 13:39:00', 10, 1),
	(138, '2023-12-15 10:46:00', 17, 2),
	(139, '2023-12-18 16:33:00', 12, 2),
	(140, '2023-12-21 12:20:00', 11, 2),
	(141, '2024-01-04 09:51:00', 5, 2),
	(142, '2024-01-17 15:42:00', 7, 2),
	(143, '2024-01-21 11:33:00', 19, 2),
	(144, '2024-01-24 17:24:00', 8, 2),
	(145, '2024-01-27 13:15:00', 15, 2),
	(146, '2024-01-30 10:06:00', 3, 2),
	(147, '2024-02-03 16:57:00', 10, 2),
	(148, '2024-02-06 12:48:00', 20, 2),
	(149, '2024-02-09 09:39:00', 2, 2),
	(150, '2024-02-12 15:30:00', 10, 1),
	(151, '2024-02-15 11:21:00', 18, 2),
	(152, '2024-02-18 17:12:00', 10, 1),
	(153, '2024-03-01 13:03:00', 16, 2),
	(154, '2024-03-04 10:54:00', 4, 2),
	(155, '2024-03-08 16:45:00', 13, 2),
	(156, '2024-03-10 12:36:00', 6, 2),
	(157, '2024-03-13 09:27:00', 9, 2),
	(158, '2024-03-16 15:18:00', 10, 1),
	(159, '2024-03-20 11:09:00', 12, 2),
	(160, '2024-04-03 17:00:00', 11, 1),
	(161, '2024-04-16 13:51:00', 5, 2),
	(162, '2024-04-19 10:42:00', 7, 2),
	(163, '2024-04-22 16:33:00', 10, 1),
	(164, '2024-04-25 12:24:00', 8, 2),
	(165, '2024-05-08 09:15:00', 15, 2),
	(166, '2024-05-13 15:06:00', 3, 2),
	(167, '2024-05-16 11:57:00', 10, 2),
	(168, '2024-05-17 17:48:00', 20, 2),
	(169, '2024-05-18 14:39:00', 10, 1),
	(170, '2024-05-19 11:30:00', 14, 2);


SET IDENTITY_INSERT [dbo].[Order] OFF;
GO



SET IDENTITY_INSERT [dbo].[Item] ON 
GO


INSERT INTO [Item] (ItemId, ItemName, ItemDescription, ItemQuantity, ItemPrice, ItemPurchaseLocation, ItemJustification, OrderId, StatusId)
VALUES 
	(1,'Laptop','High-performance gaming laptop',5,1200,'Amazon','Enhance gaming experience',116,2),
	(2,'Monitor','27-inch 4K display',3,600,'Amazon','Improve work quality',116,2),
	(3,'Keyboard','Mechanical keyboard',10,100,'Amazon','Increase productivity',102,2),
	(4,'Mouse','Wireless mouse',20,30,'Amazon','Reduce strain',102,1),
	(5,'Headphones','Over-ear headphones',15,200,'Amazon',' Enhance listening experience',103,2),
	(6,'Laptop Bag','Durable laptop bag',10,50,'Amazon','Ensure laptop safety',103,2),
	(7,'External Hard Drive','1TB external hard drive',5,150,'Amazon','Backup important files',104,2),
	(8,'Printer','Laser printer',3,300,'Amazon',' Efficient document management',105,2),
	(9,'Webcam','High-resolution webcam',10,50,'Amazon','Improve video quality',105,1),
	(10,'Microphone','USB microphone',2,20,'Amazon','Enhance audio quality',106,2),
	(11,'Tablet','10-inch tablet',5,250,'Amazon','Flexible workspace',107,2),
	(12,'Smartphone','Latest smartphone model',25,500,'Amazon','Stay connected',108,2),
	(13,'Laptop Charger','65W laptop charger',10,30,'Amazon','Ensure device longevity',109,1),
	(14,'Mouse Pad','Ergonomic mouse pad',20,10,'Amazon','Reduce strain',110,1),
	(15,'Keyboard Cover',' Keyboard cover for mechanical keyboards',25,15,'Amazon','Extend keyboard life',111,2),
	(16,'Speakers','2.0 speakers',10,100,'Amazon','Enhance audio experience',112,2),
	(17,'Headset','Gaming headset',5,150,'Amazon','Enhance gaming experience',113,2),
	(18,'Laptop Stand','Adjustable laptop stand',20, 70,'Walmart','Improve posture',114,2),
	(19,'External SSD','500GB external SSD',10,120,'Walmart','Speed up data access',115,2),
	(20,'Webcam Cover','Webcam cover for privacy',15,5,'Walmart','Protect personal space',116,2),
	(21,'Projector','4K projector',2,1000,'Walmart','Enhance presentation quality',117,2),
	(22,'Smartwatch','Fitness smartwatch',5,150,'Walmart','Monitor fitness progress',118,2),
	(23,'Drone','Gaming VR headset',3, 800,'Walmart','Enhance gaming experience',119,2),
	(24,'3D Printer','Basic 3D printer',2,500,'Walmart','Speed up product development',115,2), -- generated
	(25, 'Office Chair', 'Ergonomic chair for long hours of sitting', 10, 250.00, 'Walmart', 'For office needs', 101, 2),
	(26, 'Desk Lamp', 'LED desk lamp for focused lighting', 15, 40.00, 'Amazon', 'For department needs', 102, 2),
	(27, 'Whiteboard', 'Magnetic whiteboard for brainstorming sessions', 5, 80.00, 'BestBuy', 'For personal needs', 103, 2),
	(28, 'Stapler', 'Heavy-duty stapler for bulk documents', 20, 15.00, 'Staples', 'For office needs', 104, 2),
	(29, 'Pencil Holder', 'Acrylic pencil holder for organization', 30, 10.00, 'Walmart', 'For department needs', 105, 1),
	(30, 'Document Tray', 'Stackable document tray for file management', 12, 20.00, 'Amazon', 'For personal needs', 106, 1),
	(31, 'Calculator', 'Scientific calculator for complex calculations', 8, 25.00, 'BestBuy', 'For office needs', 107, 2),
	(32, 'Scissors', 'Precision scissors for cutting materials', 25, 5.00, 'Staples', 'For department needs', 108, 2),
	(33, 'Ruler', 'Metal ruler for accurate measurements', 40, 3.00, 'Walmart', 'For personal needs', 109, 3),
	(34, 'Binder Clips', 'Assorted binder clips for document binding', 50, 6.00, 'Amazon', 'For office needs', 110, 1),
	(35, 'Highlighters', 'Fluorescent highlighters for marking texts', 60, 8.00, 'BestBuy', 'For department needs', 111, 2),
	(36, 'Post-it Notes', 'Colorful post-it notes for reminders', 75, 4.00, 'Staples', 'For personal needs', 112, 2),
	(37, 'Paper Clips', 'Jumbo paper clips for heavy documents', 90, 2.00, 'Walmart', 'For office needs', 113, 2),
	(38, 'Correction Tape', 'Easy-to-use correction tape for mistakes', 45, 5.00, 'Amazon', 'For department needs', 114, 2),
	(39, 'Index Cards', 'Blank index cards for note-taking', 55, 3.00, 'BestBuy', 'For personal needs', 115, 2),
	(40, 'File Folders', 'Colored file folders for categorization', 65, 7.00, 'Staples', 'For office needs', 116, 2),
	(41, 'Hole Puncher', 'Adjustable hole puncher for various sizes', 35, 10.00, 'Walmart', 'For department needs', 117, 2),
	(42, 'Label Maker', 'Electronic label maker for labeling items', 20, 30.00, 'Amazon', 'For personal needs', 118, 2),
	(43, 'Tape Dispenser', 'Desktop tape dispenser for easy access', 50, 15.00, 'BestBuy', 'For office needs', 119, 1),
	(44, 'Glue Stick', 'Non-toxic glue stick for crafts', 60, 2.00, 'Staples', 'For department needs', 120, 1),
	(45, 'Marker Pens', 'Permanent marker pens for labeling', 70, 5.00, 'Walmart', 'For personal needs', 121, 2),
	(46, 'Eraser', 'High-quality eraser for clean corrections', 80, 1.00, 'Amazon', 'For office needs', 122, 2),
	(47, 'Pen Holder', 'Wooden pen holder for decoration', 40, 20.00, 'BestBuy', 'For department needs', 123, 2),
	(48, 'Clipboards', 'Hardcover clipboards for fieldwork', 30, 10.00, 'Staples', 'For personal needs', 124, 2),
	(49, 'Notebooks', 'Spiral notebooks for daily notes', 50, 5.00, 'Walmart', 'For office needs', 125, 2),
	(50, 'Pens', 'Black ink pens for writing', 100, 3.00, 'Amazon', 'For department needs', 126, 2),
	(51, 'Pencils', 'No.2 pencils for drafting', 120, 2.00, 'BestBuy', 'For personal needs', 127, 1),
	(52, 'Sharpener', 'Manual pencil sharpener for precision', 60, 1.00, 'Staples', 'For office needs', 128, 1),
	(53, 'Crayons', 'Washable crayons for kids', 70, 4.00, 'Walmart', 'For department needs', 129, 1),
	(54, 'Colored Pencils', 'Artist colored pencils for drawing', 80, 10.00, 'Amazon', 'For personal needs', 130, 2),
	(55, 'Sketchpad', 'Large sketchpad for art projects', 40, 15.00, 'BestBuy', 'For office needs', 131, 2),
	(56, 'Paint Brushes', 'Set of paint brushes for painting', 30, 20.00, 'Staples', 'For department needs', 132, 1),
	(57, 'Canvas', 'Small canvas for beginners', 50, 5.00, 'Walmart', 'For personal needs', 133, 1),
	(58, 'Watercolors', 'Basic watercolor set for hobbyists', 60, 8.00, 'Amazon', 'For office needs', 134, 2),
	(59, 'Charcoal', 'Soft charcoal sticks for sketching', 70, 3.00, 'BestBuy', 'For department needs', 135, 2),
	(60, 'Drawing Paper', 'Premium drawing paper for artists', 80, 10.00, 'Staples', 'For personal needs', 136, 3),
	(61, 'Art Easel', 'Portable art easel for outdoor painting', 40, 25.00, 'Walmart', 'For office needs', 137, 1),
	(62, 'Palette Knife', 'Flexible palette knife for mixing paints', 30, 5.00, 'Amazon', 'For department needs', 138, 2),
	(63, 'Acrylic Paints', 'Bright acrylic paints for vibrant artwork', 50, 15.00, 'BestBuy', 'For personal needs', 139, 2),
	(64, 'Oil Pastels', 'Rich oil pastels for blending colors', 60, 10.00, 'Staples', 'For office needs', 140, 2),
	(65, 'Clay', 'Air-dry clay for sculpting', 70, 8.00, 'Walmart', 'For department needs', 141, 2),
	(66, 'Craft Scissors', 'Decorative edge craft scissors', 80, 5.00, 'Amazon', 'For personal needs', 142, 2),
	(67, 'Yarn', 'Multicolor yarn for knitting', 40, 3.00, 'BestBuy', 'For office needs', 143, 2),
	(68, 'Needle', 'Embroidery needles for detailed work', 30, 2.00, 'Staples', 'For department needs', 144, 2),
	(69, 'Thread', 'Assorted thread spools for sewing', 50, 4.00, 'Walmart', 'For personal needs', 145, 2),
	(70, 'Fabric', 'Cotton fabric for quilting', 60, 10.00, 'Amazon', 'For office needs', 146, 2),
	(71, 'Buttons', 'Mixed buttons for clothing', 70, 2.00, 'BestBuy', 'For department needs', 147, 2),
	(72, 'Zippers', 'Various zippers for bags', 80, 3.00, 'Staples', 'For personal needs', 148, 2),
	(73, 'Sewing Kit', 'Complete sewing kit for beginners', 40, 15.00, 'Walmart', 'For office needs', 149, 2),
	(74, 'Crochet Hooks', 'Set of crochet hooks for different gauges', 30, 5.00, 'Amazon', 'For department needs', 150, 1),
	(75, 'Knitting Needles', 'Pair of knitting needles for scarves', 50, 8.00, 'BestBuy', 'For personal needs', 151, 2),
	(76, 'Cross Stitch Kit', 'Beginner cross stitch kit for relaxation', 60, 10.00, 'Staples', 'For office needs', 152, 1),
	(77, 'Embroidery Hoop', 'Wooden embroidery hoop for framing', 70, 4.00, 'Walmart', 'For department needs', 153, 2),
	(78, 'Quilting Frame', 'Adjustable quilting frame for large projects', 80, 20.00, 'Amazon', 'For personal needs', 154, 2),
	(79, 'Sewing Machine', 'Compact sewing machine for home use', 40, 100.00, 'BestBuy', 'For office needs', 155, 2),
	(80, 'Iron', 'Steam iron for garment care', 30, 30.00, 'Staples', 'For department needs', 156, 2),
	(81, 'Sewing Pins', 'Glass head sewing pins for visibility', 50, 2.00, 'Walmart', 'For personal needs', 157, 2),
	(82, 'Thimbles', 'Protective thimbles for hand sewing', 60, 3.00, 'Amazon', 'For department needs', 158, 3),
	(83, 'Measuring Tape', 'Retractable measuring tape for accuracy', 70, 5.00, 'BestBuy', 'For office needs', 159, 2),
	(84, 'Pattern Paper', 'Reusable pattern paper for designing', 80, 10.00, 'Staples', 'For personal needs', 160, 1),
	(85, 'Cutting Mat', 'Self-healing cutting mat for crafts', 40, 15.00, 'Walmart', 'For office needs', 161, 2),
	(86, 'Rotary Cutter', 'Safety rotary cutter for fabrics', 30, 20.00, 'Amazon', 'For department needs', 162, 2),
	(87, 'Rulers', 'Clear plastic rulers for precise cuts', 50, 5.00, 'BestBuy', 'For personal needs', 163, 3),
	(88, 'Scrapbooking Paper', 'Assorted scrapbooking paper pack', 60, 8.00, 'Staples', 'For office needs', 164, 2),
	(89, 'Adhesive', 'Acid-free adhesive for photos', 70, 4.00, 'Walmart', 'For department needs', 165, 2),
	(90, 'Scrapbooking Paper', 'Assorted scrapbooking paper pack', 60, 8.00, 'Staples', 'For office needs', 167, 2),
	(91, 'Adhesive', 'Acid-free adhesive for photos', 70, 4.00, 'Walmart', 'For department needs', 169, 1)


SET IDENTITY_INSERT [dbo].[Item] OFF 
GO

SET IDENTITY_INSERT [dbo].[Review] ON 

INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (5, CAST(N'2023-01-01' AS Date), N'I am thoroughly impressed by the exceptional performance over the past year. The dedication and diligence shown have not only exceeded our expectations but have also set a new benchmark for excellence within our team. Consistently high-quality work is del', CAST(N'2023-05-20T00:00:00.0000000' AS DateTime2), 0, 3, 10, 1, 6)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (6, CAST(N'2023-01-01' AS Date), N'This review reflects that the individual consistently meets the expectations set for their role. They reliably fulfill job responsibilities and maintain a professional attitude. Demonstrating a solid understanding of their duties, this person shows a comm', CAST(N'2023-06-20T00:00:00.0000000' AS DateTime2), 0, 2, 10, 2, 6)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (7, CAST(N'2023-01-01' AS Date), N'The performance consistently aligns with the expectations of the role. Tasks are completed efficiently, and responsibilities are managed with a dependable level of competence. The professional demeanor and steady commitment to quality work are commendable', CAST(N'2023-12-20T00:00:00.0000000' AS DateTime2), 0, 2, 10, 3, 6)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (8, CAST(N'2023-01-01' AS Date), N'This review indicates that performance has fallen below the expected standards for the role. While there is an understanding of job responsibilities, there is a noticeable inconsistency in meeting them effectively. Attention to detail and overall producti', CAST(N'2024-01-19T00:00:00.0000000' AS DateTime2), 0, 1, 10, 4, 6)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (9, CAST(N'2022-01-01' AS Date), N'Overview: This performance review evaluates the subject''s achievements and contributions over the evaluation period, noting that their performance consistently exceeds expectations in multiple key areas of their role. This appraisal is intended to provide', CAST(N'2023-03-01T00:00:00.0000000' AS DateTime2), 1, 3, 17, 4, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (10, CAST(N'2023-01-01' AS Date), N'Overview: This performance review assesses the contributions and overall performance of the individual over the evaluation period. The employee has consistently met the expectations required in their role, demonstrating reliability and proficiency in thei', CAST(N'2023-04-20T00:00:00.0000000' AS DateTime2), 0, 2, 17, 1, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (11, CAST(N'2023-01-01' AS Date), N'Overview: This performance review assesses the contributions and overall performance of the individual over the evaluation period. The employee has consistently met the expectations required in their role, demonstrating reliability and proficiency in thei', CAST(N'2023-07-20T00:00:00.0000000' AS DateTime2), 0, 2, 17, 2, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (12, CAST(N'2023-01-01' AS Date), N'Overview: The individual consistently meets expectations, demonstrating solid reliability and good teamwork. They adhere to company standards and effectively handle their responsibilities.  Key Points:  Consistency and Reliability: Reliable completion of ', CAST(N'2023-10-20T00:00:00.0000000' AS DateTime2), 1, 1, 17, 3, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (13, CAST(N'2023-01-01' AS Date), N'Overview: The individual consistently meets expectations, demonstrating solid reliability and good teamwork. They adhere to company standards and effectively handle their responsibilities.  Key Points:  Consistency and Reliability: Reliable completion of ', CAST(N'2024-01-20T00:00:00.0000000' AS DateTime2), 1, 1, 17, 4, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (14, CAST(N'2024-01-01' AS Date), N'Overview: This performance review assesses the contributions and overall performance of the individual over the evaluation period. The employee has consistently met the expectations required in their role, demonstrating reliability and proficiency in thei', CAST(N'2024-04-20T00:00:00.0000000' AS DateTime2), 0, 2, 17, 1, 5)
INSERT [dbo].[Review] ([ReviewId], [ReviewYear], [Comment], [CompletionDate], [isRead], [RatingId], [EmployeeId], [QuarterId], [SupervisorEmployee]) VALUES (15, CAST(N'2024-01-01' AS Date), N'Overview: This performance review assesses the contributions and overall performance of the individual over the evaluation period. The employee has consistently met the expectations required in their role, demonstrating reliability and proficiency in thei', CAST(N'2024-05-20T00:00:00.0000000' AS DateTime2), 0, 2, 17, 2, 5)
SET IDENTITY_INSERT [dbo].[Review] OFF
GO
 
