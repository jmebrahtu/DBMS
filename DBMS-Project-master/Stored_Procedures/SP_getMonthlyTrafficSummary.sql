SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : getMonthlyTrafficSummary
-- Purpose : generate monthly traffic summary for given month and year
-- =============================================
CREATE PROCEDURE getMonthlyTrafficSummary 
	-- Add the filepath, year and month here
	@year int, 
	@month int,
	@filePath VARCHAR (MAX)
AS
BEGIN 
	SET NOCOUNT ON;

	DECLARE @date date;

	CREATE TABLE #traffic(
		[serviceName] VARCHAR(50) NULL,
		[sourceCountry] VARCHAR(50) NULL,
		[toCountry] VARCHAR(50) NULL,
		[totalCallMinutes] time NULL,
	)

	    INSERT INTO #traffic (serviceName, sourceCountry, toCountry, totalCallMinutes)
		SELECT	s.serviceName as serviceName, (select countryName FROM country where callingCode = c.fromCode) as sourceCountry,
				(select countryName FROM country where callingCode = c.toCode) as toCountry,
				dateAdd(s,SUM(c.duration), cast('00:00:00' as time)) as totalCallMinutes
		FROM call c, service s, customer cs
		WHERE cs.serviceId = s.serviceId AND c.fromTelephone = cs.telephone AND MONTH(c.callDate) = @month AND YEAR(c.callDate) = @year
		GROUP BY s.serviceName, c.fromCode, c.toCode
		
		
		--select * from #traffic
		DECLARE @sqlString VARCHAR(MAX)
		SET @sqlString = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', 
			''Excel 12.0;Database=' + @filepath + 
			';HDR=Yes'', 
			''SELECT * FROM [Sheet1$]'')
			SELECT * FROM #traffic';

		EXEC(@sqlString)
		SELECT * from #traffic
		
		drop table #traffic
		
		
END
GO