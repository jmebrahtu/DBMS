
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : addCallDetails
-- Purpose : Adds the call details to the call table
-- =============================================
CREATE PROCEDURE [dbo].[addCallDetails]
	-- Enter call details path here
	@filePath VARCHAR(MAX)	
AS
BEGIN
SET NOCOUNT ON;

DECLARE @sqlString VARCHAR(MAX);
	
	CREATE TABLE #calls(
		[callId] int identity(1,1) NOT NULL,
		[fromCode] [int] NULL,
		[toCode] [int] NULL,
		[fromTelephone] [float] NULL,
		[toTelephone] [float] NULL,
		[duration] [int] NULL,
		[callDate] [date] NULL,
		[callTime] [int] NULL
		Primary Key (callId)
	)

	SET @sqlString = 
	'INSERT INTO #calls(fromCode,toCode,fromTelephone,toTelephone,duration,callDate,callTime)
	SELECT from_code as fromCode,to_code as toCode,from_tel as fromTelephone,to_tel as toTelephone,duration as duration,call_date as callDate, call_time as callTime
	FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0;Database=' + @filePath + ';HDR=YES''
	,''SELECT * FROM [Sheet1$]'')';	
	EXEC(@sqlString)
	
		DECLARE @callId int;
		DECLARE @fromCode int;
		DECLARE @toCode int;
		DECLARE @fromTelephone bigint;
		DECLARE @toTelephone bigint;
		DECLARE @salesRepId int;
		DECLARE @duration int;
		DECLARE @callDate date;
		DECLARE @callTime int;
		DECLARE @commission float;

	SELECT @callId = min(callId) FROM #calls;

	WHILE @callId IS NOT NULL
		BEGIN
			SELECT @fromCode = (SELECT fromCode FROM #calls WHERE callId = @callId);
			SELECT @toCode = (SELECT toCode FROM #calls WHERE callId = @callId);
			SELECT @fromTelephone = (SELECT fromTelephone FROM #calls WHERE callId = @callId);
			SELECT @toTelephone = (SELECT toTelephone FROM #calls WHERE callId = @callId);
			SELECT @duration = (SELECT duration FROM #calls WHERE callId = @callId);
			SELECT @callDate = (SELECT callDate FROM #calls WHERE callId = @callId);
			SELECT @callTime = (SELECT callTime FROM #calls WHERE callId = @callId);
			
			IF EXISTS (SELECT telephone FROM customer WHERE telephone = @fromTelephone)
			BEGIN
				IF EXISTS (SELECT callingCode FROM country WHERE callingCode = @fromCode)
				BEGIN
					IF EXISTS (SELECT callingCode FROM country WHERE callingCode = @toCode)
					BEGIN

						INSERT INTO call(fromCode, toCode, fromTelephone, toTelephone, duration,callDate, callTime)
						SELECT @fromCode, @toCode, @fromTelephone, @toTelephone, @duration,@callDate, @callTime
						WHERE NOT EXISTS (
						SELECT * FROM call WHERE fromCode = @fromCode AND toCode = @toCode AND
						fromTelephone = @fromTelephone AND toTelephone = @toTelephone AND 
						duration = @duration AND callDate = @callDate AND callTime = @callTime); 

						
					END
				END
			END			
			
			SELECT @callId = min(callId) FROM #calls WHERE callId > @callId;
		END
		PRINT 'Inserted call details file ' + @filePath
		select * from  call
END
GO