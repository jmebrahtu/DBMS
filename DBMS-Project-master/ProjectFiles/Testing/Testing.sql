DROP TABLE call
DROP TABLE customer
DROP TABLE rate
DROP TABLE peakTime
DROP TABLE salesRep
DROP TABLE service
DROP TABLE country

-- =============================================
-- Author:	Amit, Jim, James, Thomas
-- Name : Testing Sequence
-- Purpose : To test the sequence of actions
-- =============================================

----First Sequence
--Add New Customers
EXEC addNewCustomers 'C:\Users\610514\Desktop\ProjectFiles\Customers.xlsx'
----Add Peak Times
EXEC addPeakTimes 'C:\Users\610514\Desktop\ProjectFiles\PeakTimes.xlsx'
--Add rates effective from 2007-09-01
EXEC updateRates 'C:\Users\610514\Desktop\ProjectFiles\Rates_20070901.xls'
--Add call details for november
EXEC addCallDetails 'C:\Users\610514\Desktop\ProjectFiles\Calls_Nov_2007.xls'
----Create Customer Bills
EXEC createCustomerBill 7139375437, 2007, 11, 'C:\Users\610514\Desktop\ProjectFiles\Bills\Bill.xlsx'
----Generate Traffic Summary
EXEC getMonthlyTrafficSummary 2007, 11, 'C:\Users\610514\Desktop\ProjectFiles\Traffic\november.xlsx'


----Second sequence
--Add rates effective from 2007-12-15
EXEC updateRates 'C:\Users\610514\Desktop\ProjectFiles\Rates_20071215.xls'
--Add call details dec 2007 
EXEC addCallDetails 'C:\Users\610514\Desktop\ProjectFiles\Calls_Dec_2007.xls'
----Create Customer Bills
EXEC createCustomerBill 7413134451, 2008, 1,'C:\Users\610514\Desktop\ProjectFiles\Bills\Bill.xlsx'
----Generate Traffic Summary
EXEC getMonthlyTrafficSummary 2007, 12, 'C:\Users\610514\Desktop\ProjectFiles\Traffic\december.xlsx'


----Third Sequence
--Add rates effective from 2008-01-01
EXEC updateRates 'C:\Users\610514\Desktop\ProjectFiles\Rates_20080101.xls'
--Add call details 
EXEC addCallDetails 'C:\Users\610514\Desktop\ProjectFiles\Calls_Jan15_2008.xls'
--Add rates effective from 2008-01-15
EXEC updateRates 'C:\Users\610514\Desktop\ProjectFiles\Rates_20080115.xls'
--Add call details 
EXEC addCallDetails 'C:\Users\610514\Desktop\ProjectFiles\Calls_Jan_2008.xls'
----Create Customer Bills
EXEC createCustomerBill 7139375437, 2008, 1,'C:\Users\610514\Desktop\ProjectFiles\Bills\Bill.xlsx'
----Generate Traffic Summary
EXEC getMonthlyTrafficSummary 2008, 1, 'C:\Users\610514\Desktop\ProjectFiles\Traffic\january.xlsx'
----Generate Sales Rep Commission
EXEC getSalesRepCommission 2008, 1, 'C:\Users\610514\Desktop\ProjectFiles\Commission\january.xlsx'



--EXEC addSingleCustomer @telephone = 1234565959, @name = "Joaam1", @address = "Fairfield",@serviceName = "GACB",@salesRepId = 12,@commission = 8 

----Rate Sheets
EXEC getRateSheet 'Spectra', 'USA', 'C:\Users\610514\Desktop\ProjectFiles\Rates'
EXEC getRateSheet 'Spectra', 'Denmark', 'C:\Users\610514\Desktop\ProjectFiles\Rates'
EXEC getRateSheet 'GACB', 'Germany', 'C:\Users\610514\Desktop\ProjectFiles\Rates'
EXEC getRateSheet 'GACB', 'Italy', 'C:\Users\610514\Desktop\ProjectFiles\Rates'








