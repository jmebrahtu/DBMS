SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : getSalesRepCommission
-- Purpose : Get total commission for the sales representative for given month and year
-- =============================================
ALTER PROCEDURE [dbo].[getSalesRepCommission]
	-- Enter call details path here
	@year bigint,
	@month bigint,
	@filePath VARCHAR (MAX)
AS
BEGIN
	CREATE TABLE #tempBill( 
				[callID] int identity(1,1) NOT NULL,
				[fromTelephone] [bigint] NULL,
				[toTelephone] [bigint] NULL,
				[destination][VARCHAR](MAX) NULL,
				[duration] [int] NULL,
				[salesRepID] [int] NULL,
				[commission] [float] NULL,
				[callTime] [time] NULL,
				[cost] [float] NULL,
				PRIMARY KEY(callID)
			)	
	DECLARE @telephone bigint;
	DECLARE @salesRepId bigint;
	DECLARE @commission float;
	SELECT @telephone = min(telephone) FROM customer; 
	

	WHILE @telephone IS NOT NULL
	BEGIN
		DECLARE @serviceId int;
		SELECT @salesRepId = (SELECT salesRepId FROM customer WHERE telephone = @telephone);
		SELECT @commission = (SELECT commission FROM customer WHERE telephone = @telephone);
		SELECT @serviceId = (SELECT serviceId from customer WHERE telephone = @telephone);

		DECLARE @date date;
	
		CREATE TABLE #bills(
				[ID] [int] NOT NULL, 
				[fromCode] [int] NULL,
				[toCode] [int] NULL,	
				[serviceId] [int] NULL, 
				[toTelephone] [bigint] NULL, 
				[duration] [int] NULL, 
				[callDate] [date] NULL, 
				[callTime] [int] NULL, 
				[peakRate] [float] NULL,
				[offPeakRate][float] NULL,
				PRIMARY KEY (ID)
				)


		CREATE TABLE #calls( 
			[ID] int identity(1,1) NOT NULL,
			[fromCode] [int] NULL,
			[toCode] [int] NULL,
			[serviceId] [int] NULL,
			[fromTelephone] [bigint] NULL,
			[toTelephone] [bigint] NULL,
			[duration] [int] NULL,
			[callDate] [date] NULL,
			[callTime] [int] NULL,
			PRIMARY KEY(ID)
		)	 

		CREATE TABLE #rates( 
			[ID] int NOT NULL,		
			[callDate] [date] NULL,
			[effectiveDate] [int] NULL,
			[peakRate] [float] NULL,
			[offPeakRate][float] NULL,
			PRIMARY KEY(ID)
		)	

		INSERT INTO #calls SELECT fromCode,ca.toCode, serviceId, telephone, ca.toTelephone, duration, callDate, callTime 
		FROM Customer c LEFT JOIN  Call ca ON c.telephone = ca.fromTelephone
		WHERE c.telephone = @telephone AND YEAR(callDate) = @year AND MONTH(callDate) = @month

		DECLARE @ID int;
		DECLARE @callDate date;
		DECLARE @effectiveDate int;
		DECLARE @fromCode int;
		DECLARE @toCode int;
		DECLARE @peakValue float;
		DECLARE @offPeakValue float;

		SELECT @ID = min(ID) FROM #calls;	

		WHILE @ID IS NOT NULL
			BEGIN
				SELECT @serviceId = (SELECT serviceId FROM #calls WHERE ID = @ID);
				SELECT @callDate = (SELECT callDate FROM #calls WHERE ID = @ID);
				SELECT @fromCode = (SELECT fromCode FROM #calls WHERE ID = @ID);
				SELECT @toCode = (SELECT toCode FROM #calls WHERE ID = @ID);
			
			
				CREATE TABLE #tempRate( 
					[c] int identity(1,1) NOT NULL,						
					[peakRate] [float] NULL,
					[offPeakRate][float] NULL,
					[serviceId] [int] NULL,
					[fromCode] [int] NULL,
					[toCode] [int] NULL,				
					[effectiveDate] [int] NULL,
					PRIMARY KEY(c)
				)	

				declare @c int

				set rowcount 0
				INSERT INTO #tempRate SELECT * FROM rate 
				WHERE destCode = @toCode AND
				sourceCode = @fromCode AND serviceId = @serviceId
			
				set rowcount 1

				select @c = c from #tempRate

				while @@rowcount <> 0
				begin
					set rowcount 0				
					IF @callDate >= (Select cast(left((select effectiveDate from #tempRate where c = @c),8) as date))
					BEGIN
						SET @effectiveDate = (select effectiveDate from #tempRate where c = @c)
					END
					delete #tempRate where c = @c

					set rowcount 1
					select @c = c from #tempRate
				end
				set rowcount 0

				DROP TABLE #tempRate

				SELECT @peakValue = (SELECT peakRate FROM rate WHERE destCode = @toCode
				AND sourceCode = @fromCode AND serviceId = @serviceId AND effectiveDate = @effectiveDate)

				SELECT @offPeakValue = (SELECT offPeakRate FROM rate WHERE destCode = @toCode
				AND sourceCode = @fromCode AND serviceId = @serviceId AND effectiveDate = @effectiveDate)

				INSERT INTO #rates VALUES(@ID, @callDate, @effectiveDate, @peakValue, @offPeakValue)
				SELECT @ID = min(ID) FROM #calls WHERE ID > @ID;	
			END

		INSERT INTO #bills SELECT c.ID, fromCode, toCode, serviceId, toTelephone, duration, c.callDate, callTime, peakRate, offPeakRate
		FROM #calls c LEFT JOIN #rates r ON c.ID = r.ID


		DECLARE @bID int;
		DECLARE @fCode int; 
		DECLARE @tCode int; 
		DECLARE @serID int; 
		DECLARE @toTele bigint; 
		DECLARE @duration int; 
		DECLARE @callTime time;
		DECLARE @peakCost float; 
		DECLARE @offPeakCost float;
		DECLARE @peakTime time; 
		DECLARE @offPeakTime time;
	
		SET @bID = (SELECT MIN(ID) FROM #bills);

		WHILE @bID IS NOT NULL
			BEGIN
				SELECT @fCode = (SELECT fromCode from #bills WHERE ID = @bID);
				SELECT @tCode = (SELECT toCode from #bills WHERE ID = @bID);
				SELECT @serID = (SELECT @serviceId from #bills WHERE ID = @bID);
				SELECT @toTele = (SELECT toTelephone from #bills WHERE ID = @bID);
				SELECT @duration = (SELECT duration from #bills WHERE ID = @bID);
				SELECT @callTime = (STUFF(REPLACE(STR((SELECT callTime from #bills WHERE ID = @bID), 4), ' ', '0'), 3, 0, ':'))
				SELECT @peakCost = (SELECT peakRate from #bills WHERE ID = @bID);
				SELECT @offPeakCost = (SELECT offPeakRate from #bills WHERE ID = @bID);

				SELECT @peakTime = (STUFF(REPLACE(STR((SELECT peakPeriodStart FROM peakTime WHERE serviceId = @serID and countryCode = @fCode), 4), ' ', '0'), 3, 0, ':'))
				SELECT @offPeakTime = (STUFF(REPLACE(STR((SELECT offPeakPeriodStart FROM peakTime WHERE serviceId = @serID and countryCode = @fCode), 4), ' ', '0'), 3, 0, ':'))

				DECLARE @time time;
				DECLARE @cost float;
				DECLARE @count int;
				DECLARE @offDuration float;
				DECLARE @peakDuration float;
				SET @count = 0;

				--SET @time = dateadd(s, @duration, cast(@callTime as time))

				--SELECT
				--	@cost = SUM( CASE WHEN val > 0 THEN val ELSE 0 END )
				--	FROM
				--	(
				--	VALUES
				--	( @peakCost/60 * (CASE WHEN @callTime BETWEEN @peakTime AND @peakTimeEnd and @time BETWEEN @peakTime AND @peakTimeEnd THEN CAST(@duration AS FLOAT) END)),
				--	( @offPeakCost/60 * (CASE WHEN @callTime BETWEEN @offPeakTime AND @offpeakTimeEnd and @time BETWEEN @offPeakTime AND @offpeakTimeEnd THEN CAST(@duration AS FLOAT) END)),
				--	((CASE WHEN @callTime BETWEEN @peakTime AND @peakTimeEnd AND @time BETWEEN @offPeakTime AND @offpeakTimeEnd THEN (@peakCost*datediff(SECOND, @callTime, @offPeakTime) +  @offPeakCost*datediff(SECOND, @offPeakTime, @time)) END)))T(val);
			
				----PRINT @cost
				--PRINT @callTime
				--IF (@callTime BETWEEN @offPeakTime AND @offpeakTimeEnd) 
				--	BEGIN
				--		PRINT 'YES'
				--	END
				SET @peakDuration = 0;
				SET @offDuration = 0;
				SET @time = @callTime
				WHILE @count < @duration
					BEGIN
					
						IF @time >= @peakTime AND @time < @offPeakTime
								BEGIN
								
									SET @time = dateadd(s, 1, cast(@time as time))								
									SET @peakDuration = @peakDuration + 1
								end
						IF (@time >= @offPeakTime)  
								BEGIN
									SET @time = dateadd(s, 1, cast(@time as time))
									SET @offDuration = @offDuration + 1
								end
					
						IF @time >= cast('00:00:00' as time) AND @time < @peakTime
							BEGIN
									SET @time = dateadd(s, 1, cast(@time as time))
									SET @offDuration = @offDuration + 1
							end					

						SET @count = @count + 1
					END

				IF @offDuration <= 0 
							BEGIN 
								SET @offDuration = 0 
							END

				IF @peakDuration <= 0 
							BEGIN 
								SET @peakDuration = 0
							END 
		
				if @offDuration + @peakDuration != @duration
					BEGIN
						SET @offDuration = @offDuration - 12;
					END
			
				SET @cost = @peakCost*@peakDuration/60 + @offPeakCost*@offDuration/60
				INSERT INTO #tempBill VALUES(@telephone, @toTele, 
				(SELECT countryName from country where callingCode = @toCode), @duration, @salesRepId, @commission, @callTime, @cost) 
			
			
				SELECT @bID = min(ID) FROM #bills WHERE ID > @bID;
			END		
			DROP TABLE #bills
			DROP TABLE #calls
			DROP TABLE #rates
			SELECT @telephone = min(telephone) FROM customer WHERE telephone > @telephone;	
		END
		--SELECT * from #tempBill
		CREATE TABLE #commission( 
					[cID] int identity(1,1) NOT NULL,						
					salesRepId [int] NULL,
					fromTelephone [bigint] NULL,
					[commission] [float] NULL,
					PRIMARY KEY(cID)
		)
			
		INSERT INTO #commission SELECT salesRepId, fromTelephone, SUM(cost*commission*0.01) FROM #tempBill GROUP BY fromTelephone, salesRepId

		DECLARE @sqlString VARCHAR(MAX)
		SET @sqlString = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', 
			''Excel 12.0;Database=' + @filePath + 
			';HDR=Yes'', 
			''SELECT salesRepID, commission FROM [Sheet1$]'')
			SELECT salesRepId, SUM(commission) AS commission from #commission GROUP BY salesRepId';
		EXEC(@sqlString)
		SELECT salesRepId, SUM(commission) AS commission from #commission GROUP BY salesRepId

		
END
