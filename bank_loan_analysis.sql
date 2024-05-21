create database bank_loan_analysis;
use bank_loan_analysis;


select * from financial_loan;

select count(*) from financial_loan;
# KPI- Key Performance Indicator

#1 Total Loan Applications
SELECT CONCAT(ROUND(COUNT(id) / 1000, 1), 'k') AS Total_Applications
FROM financial_loan;


#1.1 MTD Loan Application
SELECT CONCAT(ROUND(COUNT(id) / 1000, 1), 'k') AS Total_Applications
FROM financial_loan
WHERE DATE_FORMAT(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12';

#1.2 PMTD Loan Applications
SELECT CONCAT(ROUND(COUNT(id) / 1000, 1), 'k') AS Total_Applications
FROM financial_loan
WHERE DATE_FORMAT(STR_TO_DATE(issue_date, '%Y-%m-%d'),  '%m') ='11';

#1.3 MoM Loan Application

#2. Total Funded Amount
select concat(FORMAT(round(sum(loan_amount)/ 1000000.0, 2),2),'M') AS Total_Funded_Amount
from financial_loan;

#2.1 MTD Total Funded Amount
select concat(format(round(sum(loan_amount)/1000000.0,2),2),'M') AS Total_Funded_Amount
from financial_loan
where DATE_FORMAT(str_to_date(issue_date,'%Y-%m-%d'), '%m') = '12';

#2.2 PMTD Total Funded Amount
select concat(format(round(sum(loan_amount)/1000000.0,2),2),'M') AS Total_Funded_Amount
from financial_loan
where date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11';

#2.3 MoM Total Funded Amount
SELECT 
    concat(format((mtd.total_funded_amount - pmtd.total_funded_amount) / pmtd.total_funded_amount * 100,2), '%') AS MoM_total_funded_amount
FROM
    (
        select sum(loan_amount) as total_funded_amount
        from financial_loan
        where DATE_FORMAT(str_to_date(issue_date,'%Y-%m-%d'), '%m') = '12'
    ) as mtd,
    (
        select sum(loan_amount) as total_funded_amount
        from financial_loan
        where date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11'
    ) as pmtd;


#3 Total Amount Received
select concat(format(round(sum(total_payment)/1000000.0,2),2),'M') AS Total_Amount_Collected
from financial_loan;


#3.1 MTD Total Amount Received 
select concat(format(round(sum(total_payment)/1000000.0,2),0),'M') AS Total_Amount_Collected
from financial_loan
where date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12';


#3.2 PMTD Total Amount Recevied
select concat(format(round(sum(total_payment)/1000000.0,2),0),'M') AS Total_Amount_Collected
from financial_loan
where date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11';

# 3.3 MoM Total Amount Recevied
SELECT 
    concat(format((mtd.total_amount_collected - pmtd.total_amount_collected) / pmtd.total_amount_collected * 100,0), '%') AS MoM_total_amount_recevied
FROM
    (
        select sum(total_payment) as total_amount_collected
        from financial_loan
        where DATE_FORMAT(str_to_date(issue_date,'%Y-%m-%d'), '%m') = '12'
    ) as mtd,
    (
        select sum(total_payment) as total_amount_collected
        from financial_loan
        where date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11'
    ) as pmtd;

#4 Average Interest Rate 
select concat(round(avg(int_rate)*100),'%') AS   Avg_Int_Rate from financial_loan;

# 4.1 MTD Average Interest
SELECT concat(format(round(avg(int_rate)*100,1),1), '%') AS MTD_Avg_Int_Rate FROM financial_loan
WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12';

# 4.2 
# PMTD Average Interest
SELECT concat(format(round(avg(int_rate)*100,1),1), '%') AS PMTD_Avg_Int_Rate FROM financial_loan
WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11';



# 4.3 MoM Average Interest Rate
SELECT 
    concat(format((mtd.Avg_Int_Rate - pmtd.Avg_Int_Rate) / pmtd.Avg_Int_Rate * 100,0), '%') AS MoM_Avg_Int_Rate
FROM
    (
	 SELECT concat(format(round(avg(int_rate)*100,1),1), '%') AS Avg_Int_Rate FROM financial_loan
      WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12'
    ) as mtd,
    (
      SELECT concat(format(round(avg(int_rate)*100,1),1), '%') AS Avg_Int_Rate FROM financial_loan
	  WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11' 
    ) as pmtd;
    
#5 Avg DTI
select concat(round(avg(dti)*100),'%') AS   Avg_DTI from financial_loan;

# 5.1 MTD Avg DTI
SELECT concat(format(round(avg(dti)*100,1),1), '%') AS MTD_Avg_DTI FROM financial_loan
WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12';

#5.2 PMTD Average DTI
SELECT concat(format(round(avg(dti)*100,1),1), '%') AS PMTD_Avg_DTI FROM financial_loan
WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11';

# 5.3 MoM Average DTI
SELECT 
    concat(format((mtd.Avg_DTI - pmtd.Avg_DTI) / pmtd.Avg_DTI * 100,0), '%') AS MoM_Avg_DTI
FROM
    (
	 SELECT concat(format(round(avg(DTI)*100,1),1), '%') AS Avg_DTI FROM financial_loan
      WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12'
    ) as mtd,
    (
      SELECT concat(format(round(avg(DTI)*100,1),1), '%') AS Avg_DTI FROM financial_loan
	  WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '11' 
    ) as pmtd;
    
    /* ----------------------------------GOOD LOAN ISSUED------------------------------*/
# Good Loan Percentage
SELECT 
    CONCAT(
        ROUND((COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / COUNT(id), 1),
        '%'
    ) AS Good_Loan_Percentage
FROM financial_loan;

# Good Loan Applications
SELECT concat(round(count(id)/1000.0,0),'k') AS Good_Loan_Applications FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

# Good Loan Funded Amount
SELECT concat('$',round(SUM(loan_amount)/1000000.0,0),'M') AS Good_Loan_Funded_amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

# Good Loan Amount Received
SELECT concat('$',round(SUM(total_payment)/1000000.0,0),'M') AS Good_Loan_amount_received FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

/*------------------------------BAD LOAN ISSUED ----------------------------*/
# Bad Loan Percentage
SELECT 
    CONCAT(
        ROUND((COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) * 100.0) / COUNT(id), 1),
        '%'
    ) AS Bad_Loan_Percentage
FROM financial_loan;


#Bad Loan Applications
SELECT concat(round(COUNT(id)/1000.0,0),'k') AS Bad_Loan_Applications FROM financial_loan
WHERE loan_status = 'Charged Off';

# Bad Loan Funded Amount
SELECT concat('$',round(SUM(loan_amount)/1000000.0,0),'M') AS Bad_Loan_Funded_amount FROM financial_loan
WHERE loan_status = 'Charged Off';


# LOAN STATUS
	SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        financial_loan
    GROUP BY
        loan_status;
        
	 SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM financial_loan
WHERE date_format(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%m') = '12'
GROUP BY loan_status;

# B. BANK LOAN REPORT | OVERVIEW
# MONTH
SELECT 
    DATE_FORMAT(STR_TO_DATE(issue_date,'%Y-%m-%d'), '%m') AS Month_Number,
    DATE_FORMAT(STR_TO_DATE(issue_date, '%Y-%m-%d'), '%M') AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY Month_Number, Month_Name
ORDER BY Month_Number;


# STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY address_state
ORDER BY address_state;
# TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY term
ORDER BY term;

# EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

#PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY purpose
ORDER BY purpose;

#HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;

/*Note: We have applied multiple Filters on all the dashboards. You can check the results for the filters as well by modifying the query and comparing the results.
For e.g
See the results when we hit the Grade A in the filters for dashboards. */

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;
