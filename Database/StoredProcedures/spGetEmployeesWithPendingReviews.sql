/*
NAME: Andrii Lebid, Aigul Yermagambetova
DATE: 04/26/2024
PURPOSE: Epic Solution
Description: Stored Procedures
Version: 0.0
*/



USE EpicSolutions;
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


