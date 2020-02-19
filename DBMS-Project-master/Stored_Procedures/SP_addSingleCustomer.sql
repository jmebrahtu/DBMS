SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : addSingleCustomer
-- Purpose : adds single customer to customer table
-- =============================================
CREATE PROCEDURE [dbo].[addSingleCustomer] 
	@telephone bigint,
	@name varchar(50),
	@address varchar(MAX),
	@serviceName varchar(50),
	@salesRepId int,
	@commission int

AS
BEGIN
		
		DECLARE @length bigint;
		SET @length = LEN (cast(cast(@telephone as bigint) as varchar(100)) )

	IF (@telephone IS NULL OR @length != 10 )
	BEGIN
		PRINT 'Input a Valid Telephone Number'
		RETURN
	END

	IF (@name  is null )
	BEGIN
		PRINT 'Input a Customer Name'
		RETURN
	END

	IF (@address  is null )
	BEGIN
		PRINT 'Input a Customer Address'
		RETURN
	END

	IF (@serviceName  is null )
	BEGIN
		PRINT 'Input a Service Name'
		RETURN
	END

	DECLARE @count int;
	SELECT  @count = COUNT(serviceId) FROM service WHERE serviceName = @serviceName

	IF (@count != 1)
	BEGIN
		PRINT 'Input a Valid Service Name'
		RETURN
	END

	DECLARE @count2 int;
	SELECT  @count2 = COUNT(salesRepId) FROM salesRep WHERE salesRepId = @salesRepId

	IF (@salesRepId  is null OR @count2 != 1)
	BEGIN
		PRINT 'Input a Valid SalesRepId'
		RETURN
	END
	
	IF (@commission  is null OR @commission < 5 OR @commission > 10 )
	BEGIN
		PRINT 'Input a Valid sales commission'
		RETURN
	END

	DECLARE @serviceId int;
	SET @serviceId = (SELECT serviceId FROM service WHERE service.serviceName = @serviceName);

	INSERT INTO customer(telephone, name, address, serviceId, salesRepId,commission)
	VALUES (@telephone, @name, @address, @serviceId, @salesRepId,@commission);
END
