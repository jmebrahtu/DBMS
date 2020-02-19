
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : updateRates
-- Purpose : Updates rates to the rate table
-- =============================================
CREATE PROCEDURE updateRates 
	@filePath VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @FileName NVARCHAR(MAX)
    DECLARE @ReversedPath NVARCHAR(MAX)
    DECLARE @ExtLength INT
	DECLARE @effectiveDate int

    SET @ReversedPath = REVERSE(@filePath)
    SELECT @ExtLength = CHARINDEX('.', @ReversedPath)
    SELECT @FileName = RIGHT(@filePath, CHARINDEX('\', @ReversedPath)-1)
    SELECT @FileName = LEFT(@FileName, LEN(@FileName) - @ExtLength)
	

	SELECT @effectiveDate = (SELECT RIGHT(@FileName, CHARINDEX('_', REVERSE(@FileName)) - 1));
	PRINT @effectiveDate
	--SELECT @effectiveDate = (SELECT CONVERT(date, convert(varchar(MAX), @intDate)));
	--PRINT @effectiveDate

	DECLARE @serviceName VARCHAR(MAX);
	DECLARE @country VARCHAR(50);

	CREATE TABLE #details(
    [ID] int identity(1,1) NOT NULL,
	[serviceId] [int] NOT NULL,
	[countryCode] [int] NOT NULL,
	[peakStart] [int] NULL,
	[offPeakStart] [int] NULL,
	Primary Key (ID)
	)

	CREATE TABLE #tempRate(
				destCode [int] NOT NULL,
				peak [float] NULL,
				offpeak [float] NULL,
				serviceId [int] NOT NULL,
				sourceCode [int] NOT NULL,
				effectiveDate [int] NOT NULL,
				Primary Key (destCode,serviceId,sourceCode,effectiveDate)
			)

	INSERT into #details SELECT * FROM peakTime;
	DECLARE @dest int;

	DECLARE @serviceId int;
	DECLARE @countryCode int;
	DECLARE @ID int;
	DECLARE @sheetName VARCHAR(MAX);
	DECLARE @sqlString VARCHAR(MAX);

	SELECT @ID = min(ID) FROM #details;	

	WHILE @ID IS NOT NULL
		BEGIN
			SELECT @serviceId = (SELECT serviceId FROM #details WHERE ID = @ID);
			SELECT @countryCode = (SELECT countryCode FROM #details WHERE ID = @ID);
			SELECT @serviceName = (SELECT serviceName FROM service WHERE serviceId = @serviceId);
			SELECT @country = (SELECT countryName FROM country WHERE callingCode = @countryCode);
			SELECT @sheetName = LTRIM(RTRIM((SELECT CONCAT(@serviceName,'_',@country))));
			
			SET @sqlString = 'INSERT INTO #tempRate(destCode, peak, offpeak, serviceId, sourceCode, effectiveDate)
				SELECT dest AS destCode, peak AS peak, offpeak as offpeak,' + CONVERT(varchar(MAX), @serviceId) + ' as serviceId,' 
				+CONVERT(varchar(MAX),  @countryCode) + 'as sourceCode,' +CONVERT(varchar(MAX),  @effectiveDate) + 'as effectiveDate' + '
				FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'',''Excel 12.0;Database=' + @filePath + ';HDR=YES''
					,''SELECT * FROM [' + @sheetName + '$]'')';
			PRINT @sqlString
			BEGIN TRY  
				-- Table does not exist; object name resolution  
				-- error not caught.  
				EXEC(@sqlString)
			END TRY  
			BEGIN CATCH  			
				  
			END CATCH  		
			
			SELECT @ID = min(ID) FROM #details WHERE ID > @ID;	
		END
	SELECT * from #tempRate
	INSERT INTO rate select * from #tempRate
END




