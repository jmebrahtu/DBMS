SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Amit, Jim, James, Thomas
--Name : addNewCustomers
--Purpose : Adds peak times to peakTime table
-- =============================================
CREATE PROCEDURE addPeakTimes 
	@filePath varchar(max)
AS
BEGIN
	
	CREATE TABLE #peakTimes(
		[ID] int identity(1,1) NOT NULL,
		[sName] [varchar](10) NOT NULL,
		[cName] [varchar](25) NOT NULL,
		[peakStart] [int] NULL,
		[offPeakStart] [int] NULL,
		Primary Key (ID)
	)

	DECLARE @sqlString VARCHAR(MAX);

	INSERT INTO #peakTimes(sName, cName, peakStart,offPeakStart)
		SELECT serviceName AS sName, sourceCountry AS cName, peakPeriodStart as peakStart
		,offPeakPeriodStart as offPeakStart
		FROM OPENROWSET(
		'Microsoft.ACE.OLEDB.16.0'
		,'Excel 12.0;Database=C:\DBMS_Project\PeakTimes.xlsx;HDR=YES'
		,'SELECT * FROM [Sheet1$]')
	
	DECLARE @serviceName varchar(50);
	DECLARE @countryName varchar(50);

	DECLARE @serviceId int;
	DECLARE @countryCode int;
	DECLARE @peakStart int;
	DECLARE @offPeakStart int;
	DECLARE @ID int;

	SELECT @ID = min(ID) FROM #peakTimes;
	PRINT @ID

	WHILE @ID IS NOT NULL
		BEGIN
			SELECT @serviceName = (SELECT sName FROM #peakTimes WHERE ID = @ID);
			SELECT @countryName = (SELECT cName FROM #peakTimes WHERE ID = @ID);
			SELECT @peakStart = (SELECT peakStart FROM #peakTimes WHERE ID = @ID);
			SELECT @offPeakStart = (SELECT offPeakStart FROM #peakTimes WHERE ID = @ID);
			SELECT @serviceId = (SELECT serviceId FROM service WHERE service.serviceName = @serviceName);
			SELECT @countryCode = (SELECT callingCode FROM country WHERE country.countryName = @countryName);

			INSERT INTO peakTime(serviceId, countryCode, peakPeriodStart, offPeakPeriodStart)
			VALUES (@serviceId, @countryCode, @peakStart, @offPeakStart);

			SELECT @ID = min(ID) FROM #peakTimes WHERE ID > @ID;
		END
	DROP TABLE #peakTimes
END

