
SELECT Week_day,Total, Total - LAG(Total) OVER (ORDER BY Week_day) AS Gain, Sunday, Monday, Tuesday, Wednesday,Thursday,Friday, Saturday
FROM
(
SELECT DATEPART(WEEK, t.ProcessedDate) AS Week_day, SUM(t.Amount) AS Total,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 1 THEN t.Amount ELSE null END) AS Sunday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 2 THEN t.Amount ELSE null END) AS Monday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 3 THEN t.Amount ELSE null END) AS Tuesday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 4 THEN t.Amount ELSE null END) AS Wednesday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 5 THEN t.Amount ELSE null END) AS Thursday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 6 THEN t.Amount ELSE null END) AS Friday,
	SUM(CASE WHEN DATEPART(WEEKDAY,t.ProcessedDate) = 7 THEN t.Amount ELSE null END) AS Saturday
FROM Products p
JOIN Transactions t
ON p.id = t.Product_id
GROUP BY DATEPART(WEEK, t.ProcessedDate)
)a1







SELECT	WeekNumber,
		WeeklyAmount,
		WeeklyAmount - LAG(WeeklyAmount) OVER (ORDER BY WeekNumber) AS GAIN,
		[1] AS Sunday,
		[2] AS Monday,
		[3] AS Tuesday,
		[4] AS Wednesday,
		[5] AS Thursday,
		[6] AS Friday,
		[7] AS Saturday
FROM
(
SELECT	t.Amount AS DailyAmount,
		SUM(t.Amount) OVER (PARTITION BY DATEPART(WEEK, t.ProcessedDate)) AS WeeklyAmount,
		DATEPART(WEEKDAY, t.ProcessedDate) AS DayWeek,
		DATEPART(WEEK, t.ProcessedDate) AS WeekNumber
		
FROM Transactions t
)t1
PIVOT(
	SUM(DailyAmount)
	FOR DayWeek
	IN ([7], [1], [2], [3], [4], [5], [6])
)result	