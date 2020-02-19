
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : getRateSheet
-- Purpose : generate rate sheet for given service name and source country
-- =============================================
ALTER PROCEDURE getRateSheet 
	-- Add the parameters for the stored procedure here
	@serviceName VARCHAR(MAX),
	@sourceCountry VARCHAR(MAX),
	@path VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @serviceId int;
	DECLARE @countryCode int;
	DECLARE @effectiveDate int;
	DECLARE @sqlString VARCHAR(MAX);
	DECLARE @ID int;
	DECLARE @destination VARCHAR(MAX);
	DECLARE @peakRate float;
	DECLARE @offPeakRate float;
	SET @path = @path + '\' +@serviceName + '_' + @sourceCountry + '.xlsx';
	
	CREATE TABLE #tempRate(
				[ID] int identity(1,1) NOT NULL,
				destCode [int] NOT NULL,
				peakRate [float] NULL,
				offPeakRate [float] NULL,
				serviceId [int] NOT NULL,
				sourceCode [int] NOT NULL,
				effectiveDate [int] NOT NULL,
				Primary Key (ID)
			)

	CREATE TABLE #tempSheet(
				destination [varchar](50) NOT NULL,
				peakRate [float] NULL,
				offPeakRate [float] NULL,
				
			)


	SELECT @serviceId = (SELECT TOP 1 serviceId FROM service WHERE serviceName = @serviceName)
	SELECT @countryCode = (SELECT TOP 1 callingCode FROM country WHERE countryName = @sourceCountry)
	SELECT @effectiveDate = (SELECT MAX(effectiveDate) FROM rate WHERE serviceId = @serviceId AND sourceCode = @countryCode)	
	
	INSERT INTO #tempRate SELECT * FROM rate WHERE serviceId = @serviceId AND sourceCode = @countryCode AND effectiveDate = @effectiveDate;
	
	SELECT @ID = min(ID) FROM #tempRate;	

	WHILE @ID IS NOT NULL
		BEGIN
			SELECT @destination = (SELECT countryName FROM country WHERE callingCode = (SELECT destCode FROM #tempRate WHERE ID = @ID));
			SELECT @peakRate = 	(SELECT peakRate FROM #tempRate WHERE ID = @ID);
			SELECT @offPeakRate = 	(SELECT offPeakRate FROM #tempRate WHERE ID = @ID);

			INSERT INTO #tempSheet VALUES (@destination, @peakRate, @offPeakRate)

			SELECT @ID = min(ID) FROM #tempRate WHERE ID > @ID;	
		END
	CREATE TABLE #finalRate( 			
				[name] [VARCHAR](MAX) NULL,
				[country][VARCHAR](MAX) NULL,
				[date] [date] NULL,
		)	
		 
	INSERT INTO #finalRate VALUES(@serviceName, @sourceCountry, (Select cast(left(@effectiveDate,8) as date)));
	SELECT * from #finalRate
	DECLARE @sqlString1 VARCHAR(MAX)
	SET @sqlString1 = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', 
			''Excel 12.0;Database=' + @path + 
			';HDR=Yes'', 
			''SELECT ServiceName, Country, Date FROM [Sheet1$]'')
			select * from #finalRate';
	
	EXEC(@sqlString1)

	SET @sqlString = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', 
			''Excel 12.0;Database=' + @path + 
			';HDR=Yes'', 
			''SELECT destination,peakRate,offPeakRate FROM [Sheet1$]'')
			SELECT * FROM #tempSheet ORDER BY destination';

	EXEC(@sqlString)
	SELECT * FROM #tempSheet
	DROP TABLE #tempRate
	DROP TABLE #tempSheet
END

