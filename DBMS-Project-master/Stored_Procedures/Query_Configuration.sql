/**

Name : Query Configuration
Purpose : Creates all the tables needed for the database

**/

USE [MSDB]
GO

sp_configure 'show advanced options', 1
GO

sp_configure 'xp_cmdshell', '1' 
RECONFIGURE
GO
RECONFIGURE WITH OverRide
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE WITH OverRide
GO

USE TelephoneCompany
GO

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1 
GO 
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1 
GO 

USE [TelephoneCompany]
GO

/** Object:  Table [dbo].[call]    Script Date: 11/17/2019 2:30:16 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/** Object:  Table [dbo].[country]    Script Date: 11/17/2019 2:33:29 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[country](
	[callingCode] [int] NOT NULL,
	[countryName] [varchar](50) NULL,
	PRIMARY KEY ([callingCode])
) ON [PRIMARY]
GO

/** Object:  Table [dbo].[service]    Script Date: 11/17/2019 2:38:00 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[service](
	[serviceId] [int] NOT NULL IDENTITY(1, 1),
	[serviceName] [varchar](50) NULL,
	PRIMARY KEY ([serviceId])
) ON [PRIMARY]
GO

/** Object:  Table [dbo].[rate]    Script Date: 11/17/2019 2:37:19 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rate](
	[destCode] [int] NOT NULL,
	[peakRate] [float] NULL,
	[offPeakRate] [float] NULL,
	[serviceId] [int] NOT NULL,
	[sourceCode] [int] NOT NULL,
	[effectiveDate] [int] NOT NULL,
	CONSTRAINT PK_rate PRIMARY KEY NONCLUSTERED ([destCode], [serviceId], [sourceCode], [effectiveDate]),
	FOREIGN KEY (serviceId) references [dbo].[service](serviceId),
	FOREIGN KEY (sourceCode) references [dbo].[country](callingCode),
	FOREIGN KEY (destCode) references [dbo].[country](callingCode)


) ON [PRIMARY]
GO

/** Object:  Table [dbo].[salesRep]    Script Date: 11/17/2019 2:37:44 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[salesRep](
	[salesRepId] [int] NOT NULL,
	[firstName] [varchar](50) NULL,
	[lastName] [varchar](50) NULL,
	PRIMARY KEY ([salesRepId])
) ON [PRIMARY]
GO

/** Object:  Table [dbo].[customer]    Script Date: 11/17/2019 2:36:21 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[customer](
	[telephone] [bigint] NOT NULL,
	[name] [varchar](500) NULL,
	[address] [varchar](500) NULL,
	[serviceId] [int] NULL,
	[salesRepId] [int] NULL,
	[commission] [float] NULL,
	PRIMARY KEY (telephone),
	FOREIGN KEY (serviceId) references [dbo].[service](serviceId),
	FOREIGN KEY (salesRepId) references [dbo].[salesRep](salesRepId)
) ON [PRIMARY]
GO

/** Object:  Table [dbo].[call]    Script Date: 11/17/2019 2:36:45 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[call](
	[callId] [int] NOT NULL IDENTITY(1, 1),
	[fromCode] [int] NULL,
	[toCode] [int] NULL,
	[fromTelephone] [bigint] NULL,
	[toTelephone] [bigint] NULL,
	[duration] [int] NULL,
	[callDate] [date] NULL,
	[callTime] [int] NULL,
	PRIMARY KEY ([callId]),
	FOREIGN KEY ([fromTelephone]) references [dbo].[customer](telephone),
	FOREIGN KEY (fromCode) references [dbo].[country](callingCode),
	FOREIGN KEY (toCode) references [dbo].[country](callingCode)
) ON [PRIMARY]
GO

/** Object:  Table [dbo].[peakTime]    Script Date: 11/17/2019 2:36:45 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[peakTime](
	[serviceId] [int] NOT NULL,
	[countryCode] [int] NOT NULL,
	[peakPeriodStart] [int] NULL,
	[offPeakPeriodStart] [int] NULL,
	CONSTRAINT PK_peakTime PRIMARY KEY NONCLUSTERED ([serviceId], [countryCode])
) ON [PRIMARY]
GO

USE TelephoneCompany;
GO
INSERT INTO service(serviceName)
	SELECT * FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.16.0'
	,'Excel 12.0;Database=C:\Users\610514\Desktop\ProjectFiles\Services.xlsx;HDR=YES'
	,'SELECT * FROM [Sheet1$]')
GO

USE TelephoneCompany;
GO
INSERT INTO country(callingCode, countryName)
	SELECT CallingCode as callingCode,CountryName as countryName
	FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.16.0'
	,'Excel 12.0;Database=C:\Users\610514\Desktop\ProjectFiles\Calling_Codes.xls;HDR=YES'
	,'SELECT * FROM [Sheet1$]')
GO

USE TelephoneCompany;
GO
INSERT INTO salesRep(salesRepId)
	SELECT DISTINCT salesRepID as salesRepId
	FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.16.0'
	,'Excel 12.0;Database=C:\Users\610514\Desktop\ProjectFiles\salesRep.xlsx;HDR=YES'
	,'SELECT * FROM [Sheet1$]')
GO

USE TelephoneCompany;
GO

CREATE TABLE #peakTimes(
    [ID] int identity(1,1) NOT NULL,
	[sName] [varchar](10) NOT NULL,
	[cName] [varchar](25) NOT NULL,
	[peakStart] [int] NULL,
	[offPeakStart] [int] NULL,
	Primary Key (ID)
)

INSERT INTO #peakTimes(sName, cName, peakStart,offPeakStart)
	SELECT serviceName AS sName, sourceCountry AS cName, peakPeriodStart as peakStart
	,offPeakPeriodStart as offPeakStart
	FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.16.0'
	,'Excel 12.0;Database=C:\Users\610514\Desktop\ProjectFiles\PeakTimes.xlsx;HDR=YES'
	,'SELECT * FROM [Sheet1$]')
GO

DROP TABLE #peakTimes


