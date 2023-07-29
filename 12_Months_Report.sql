DECLARE @minRow INT = 1, @maxRow INT = 12
DECLARE @startDate DATE = DATEFROMPARTS(2022, 9, 1)

;WITH DateFilter(RowNumber,StartDate) AS
(
	SELECT @minRow, @startDate
	UNION ALL
	SELECT
		filter.RowNumber + 1, DATEADD(MONTH, -1, filter.StartDate)
	FROM DateFilter as filter
	WHERE filter.RowNumber < @maxRow
)

SELECT	filters.RowNumber,
		DATENAME(MM, filters.StartDate) AS MonthNumber,
		DATEPART(YEAR, MAX(filters.StartDate)) AS YearNumber,
		FORMAT(SUM(ISNULL(trans.Amount, 0)), 'c', 'en_PH') AS Total

FROM DateFilter filters
LEFT JOIN ActivitySix_Transactions trans ON trans.ProcessedDate BETWEEN filters.StartDate AND EOMONTH(filters.StartDate)
GROUP BY filters.RowNumber,DATENAME(MM, filters.StartDate)
ORDER BY filters.RowNumber ASC