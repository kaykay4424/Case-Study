CREATE DATABASE credit_analysis;
USE credit_analysis;
SELECT * FROM bankchurners LIMIT 10;


-- Q1: Total customers split by churn status
-- Business Question: How many customers have churned vs stayed?
SELECT COUNT(*) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Customer_Stayed,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Customer_Churned
FROM bankchurners
;


-- Q2: Overall churn rate percentage
-- Business Question: What is the bank's overall churn rate?
WITH cte AS(SELECT COUNT(Customer_Age) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Customer_Stayed,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Customer_churned
FROM bankchurners)
SELECT *, ROUND(Customer_churned/total_customers * 100, 2) AS Churned_perc
FROM cte
;


-- Q3: Income category with highest churned customers (count)
-- Business Question: Which income segment loses the most customers?
WITH cte AS(SELECT Income_Category, COUNT(Customer_Age) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Customer_Stayed,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Customer_churned
FROM bankchurners
GROUP BY Income_Category)
SELECT *, ROUND(Customer_churned/total_customers * 100, 2) AS Churned_perc
FROM cte
ORDER BY Customer_churned DESC
LIMIT 1
;


-- Q4: Churn rate across all income categories ranked
-- Business Question: Which income bracket is most at risk by churn rate?
WITH cte AS(SELECT Income_Category, COUNT(Customer_Age) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Customer_Stayed,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Customer_churned
FROM bankchurners
GROUP BY Income_Category)
SELECT *, ROUND(Customer_churned/total_customers * 100, 2) AS Churned_perc
FROM cte
ORDER BY Churned_perc DESC
;
-- Insight: $120K+ has highest churn RATE (17.33%) despite smallest volume high value customers are most at risk


-- Q5: Churn rate by card category
-- Business Question: Which card type loses the most customers?
WITH cte AS(SELECT Card_Category, COUNT(Customer_Age) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Customer_Stayed,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Customer_churned
FROM bankchurners
GROUP BY Card_Category)
SELECT *, ROUND(Customer_churned/total_customers * 100, 2) AS Churned_perc
FROM cte
ORDER BY Churned_perc DESC;
-- Insight: Gold at 18.1% is highest among significant segments. Blue has largest absolute churn (1519 customers)


-- Q6: Average credit limit and utilization for churned vs existing
-- Business Question: Do churned customers behave differently in credit usage?
SELECT Attrition_Flag,
ROUND(AVG(Credit_Limit), 2) AS Avg_Credit_Limit,
ROUND(AVG(Avg_Utilization_Rate), 2) AS Avg_Utilization
FROM bankchurners
GROUP BY Attrition_Flag;
-- Insight: Churned customers had lower utilization (0.16 vs 0.30) : low engagement is an early churn signal


-- Q7: Churn rate by age group
-- Business Question: Which age segment churns the most?
WITH cte AS(
SELECT
CASE
WHEN Customer_Age < 30 THEN 'Below 30'
WHEN Customer_Age BETWEEN 30 AND 40 THEN '30-40'
WHEN Customer_Age BETWEEN 41 AND 50 THEN '41-50'
ELSE '51+'
END AS Age_Group,
Attrition_Flag
FROM bankchurners)
SELECT Age_Group,
COUNT(*) AS total_customers,
SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned,
ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM cte
GROUP BY Age_Group
ORDER BY churn_rate DESC;
-- Insight: 41-50 age group has highest churn rate (16.75%) and largest volume


-- Q 8: What is the average number of transactions and average transaction amount for churned vs existing customers?
-- Business Question: Do churned customers transact less before leaving?
SELECT Attrition_Flag, AVG(Total_Trans_Ct), 
AVG(Total_Trans_Amt) 
FROM bankchurners
GROUP BY Attrition_Flag;
-- Insight: Churned customers averaged 44 transactions vs 68. low frequency is an early warning signal


-- Q 9: Find the top 10 customers by total transaction amount.
-- Business Question: Who are the highest value customers?
SELECT CLIENTNUM, Customer_Age, Income_Category, Card_Category, Total_Trans_Amt
FROM bankchurners
ORDER BY Total_Trans_Amt DESC
LIMIT 10;


-- Q10: Which gender has a higher churn rate?
-- Business Question: Does gender influence churn behaviour?
SELECT Gender,
ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM bankchurners
GROUP BY Gender;
-- Insight: Female customers churn at 17.36% vs 14.62% for males


-- Q 11: Find customers who have been inactive for 3+ months AND have low transaction count (below 50) — these are your highest flight risk customers
-- Business Question: Which customers need immediate retention intervention?
SELECT CLIENTNUM, Months_Inactive_12_mon, Total_Trans_Ct
FROM bankchurners 
WHERE Months_Inactive_12_mon > 3 AND  
Total_Trans_Ct < 50;
-- Insight: 233 customers flagged inactive and low transaction count. THerefore, immediate outreach recommended

SELECT COUNT(*) FROM bankchurners
WHERE Months_Inactive_12_mon > 3 AND Total_Trans_Ct < 50;


-- Q12: Rank customers by transaction amount within each income category
-- Business Question: Who are the top spenders in each income bracket?
WITH cte AS(SELECT CLIENTNUM, Income_Category, Total_Trans_Amt,
RANK() OVER(PARTITION BY Income_Category
ORDER BY Total_Trans_Amt DESC) AS Income_Rank
FROM bankchurners)
SELECT *
FROM cte
WHERE Income_Rank = 1;


-- Q 13: For each customer show their transaction amount AND the average transaction amount of their income category side by side
-- Business Question: Which customers are above or below their income group average?
SELECT CLIENTNUM, Income_Category, Total_Trans_Amt,
ROUND(AVG(Total_Trans_Amt) OVER(PARTITION BY Income_Category), 2) AS Avg_per_income_cat
FROM bankchurners;
SELECT CLIENTNUM, Income_Category, Total_Trans_Amt, 
AVG(Total_Trans_Amt) OVER(PARTITION BY Income_Category) AS Avg_per_income_cat
FROM bankchurners
;


-- Q 14: Show each customers transaction amount and their running total of transactions ordered by transaction amount within their income category
-- Business Question: What is the cumulative spend progression within income segments?
SELECT CLIENTNUM, Total_Trans_Amt, Income_Category,
SUM(Total_Trans_Amt) OVER(PARTITION BY Income_Category
ORDER BY Total_Trans_Amt) AS Running_Total
FROM bankchurners ;


/* Q 15: Create a risk score for each customer based on these rules:
Inactive 3+ months → +2 risk points
Utilization rate below 0.1 → +2 risk points
Transaction count below 40 → +2 risk points
Churned customer → +3 risk points

Output: CLIENTNUM, risk_score, label them as 'High Risk' / 'Medium Risk' / 'Low Risk'

High Risk = score 5+
Medium Risk = score 3-4
Low Risk = below 3 */

WITH cte AS(SELECT CLIENTNUM, 
SUM(CASE WHEN Months_Inactive_12_mon > 3 THEN 2 ELSE 0 END) AS Inactivity,
SUM(CASE WHEN Avg_Utilization_Ratio < 0.1 THEN 2 ELSE 0 END) AS Utilization,
SUM(CASE WHEN Total_Trans_Ct < 40 THEN 2 ELSE 0 END) AS transaction_count,
SUM(CASE WHEN Attrition_Flag = "Attrited Customer" THEN 3 ELSE 0 END) AS churned_customer
FROM bankchurners
GROUP BY CLIENTNUM)
SELECT CLIENTNUM,
Inactivity + Utilization + transaction_count + churned_customer AS Risk_Score,
CASE 
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 5 THEN "High RIsk" 
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 3 THEN "Medium Risk " ELSE "Low Risk"
END AS Risk_Label
FROM cte;
-- Insight: 1,316 High Risk customers (13% of base) require immediate retention action


/*
WITH cte AS(SELECT CLIENTNUM, 
SUM(CASE WHEN Months_Inactive_12_mon > 3 THEN 2 ELSE 0 END) AS Inactivity,
SUM(CASE WHEN Avg_Utilization_Ratio < 0.1 THEN 2 ELSE 0 END) AS Utilization,
SUM(CASE WHEN Total_Trans_Ct < 40 THEN 2 ELSE 0 END) AS transaction_count,
SUM(CASE WHEN Attrition_Flag = "Attrited Customer" THEN 3 ELSE 0 END) AS churned_customer
FROM bankchurners
GROUP BY CLIENTNUM),
risk_table AS(
SELECT CLIENTNUM,
Inactivity + Utilization + transaction_count + churned_customer AS Risk_Score,
CASE 
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 5 THEN "High Risk"
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 3 THEN "Medium Risk" 
ELSE "Low Risk"
END AS Risk_Label
FROM cte)
SELECT Risk_Label, COUNT(*) AS customer_count
FROM risk_table
GROUP BY Risk_Label
ORDER BY customer_count DESC;
*/


-- Q 16: Find all customers whose transaction amount is above the average transaction amount of their own card category
-- Business Question: Who are the high value customers within each card segment?
WITH cte AS(SELECT CLIENTNUM, Total_Trans_Amt, Card_Category, 
AVG(Total_Trans_Amt) OVER(PARTITION BY Card_Category) AS avg_category
FROM bankchurners)
SELECT CLIENTNUM, Card_Category, Total_Trans_Amt, avg_category
FROM cte
WHERE Total_Trans_Amt > avg_category 
;


-- Q 17: Find the top 3 customers by transaction amount within each card category
-- Business Question: Who are the top spenders per card type?
WITH cte AS(SELECT CLIENTNUM, Total_Trans_Amt, Card_Category, 
RANK() OVER(PARTITION BY Card_Category ORDER BY Total_Trans_Amt DESC) AS rn
FROM bankchurners)
SELECT CLIENTNUM, Total_Trans_Amt, Card_Category, rn 
FROM cte 
WHERE rn <= 3
;


-- Q 18: What is the churn rate by marital status? 
-- Business Question: Does marital status correlate with churn behaviour?
SELECT Marital_Status,
ROUND(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM bankchurners
GROUP BY Marital_Status
;
-- Insight: Unknown marital status has highest churn (17.22%), incomplete profiles = higher risk of churning 


-- Q 19: Find customers who have a credit limit above average BUT utilization below 20% — these are underutilized high-value customers 
-- Business Question: Which high-value customers are underusing their credit?
SELECT CLIENTNUM, Credit_Limit, Avg_Utilization_Ratio FROM bankchurners
WHERE Credit_Limit > (SELECT AVG(Credit_Limit) FROM bankchurners)
AND Avg_Utilization_Ratio < 0.20;
-- Insight: Prime targets for upsell campaigns liek rewards, cashback, credit limit increase offers etc.


/* Q 20: Create a complete customer summary — for each customer show: CLIENTNUM, Risk_Label (from Q15), 
Card_Category, Income_Category, Total_Trans_Amt, Avg_Utilization_Ratio, and Attrition_Flag — all in one query */ 
-- Business Question: Complete customer profile with risk classification
WITH cte AS(SELECT CLIENTNUM, Card_Category, Income_Category, Total_Trans_Amt, Avg_Utilization_Ratio, Attrition_Flag,
SUM(CASE WHEN Months_Inactive_12_mon > 3 THEN 2 ELSE 0 END) AS Inactivity,
SUM(CASE WHEN Avg_Utilization_Ratio < 0.1 THEN 2 ELSE 0 END) AS Utilization,
SUM(CASE WHEN Total_Trans_Ct < 40 THEN 2 ELSE 0 END) AS transaction_count,
SUM(CASE WHEN Attrition_Flag = "Attrited Customer" THEN 3 ELSE 0 END) AS churned_customer
FROM bankchurners
GROUP BY CLIENTNUM, Card_Category, Income_Category, Total_Trans_Amt, Avg_Utilization_Ratio, Attrition_Flag)
SELECT CLIENTNUM, Card_Category, Income_Category, Total_Trans_Amt, Avg_Utilization_Ratio, Attrition_Flag,
CASE 
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 5 THEN "High RIsk" 
WHEN Inactivity + Utilization + transaction_count + churned_customer >= 3 THEN "Medium Risk " ELSE "Low Risk"
END AS Risk_Label
FROM cte
;
-- Final deliverable — combines all analysis into one actionable table