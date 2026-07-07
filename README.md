# Credit Card Churn Analysis - SQL Case Study (by Krish Kamboj)

## Project Overview
I Analysed 10,127 credit card customers for a bank to identify churn patterns, 
risk segments, and retention opportunities using advanced SQL. The data was take from kaggle datasets. 

## Business Problem
The bank is losing customers and needs to understand:
- Who is churning and why?
- Which segments are highest risk?
- Where should retention efforts be focused? etc.

## Dataset
- Source: Kaggle - Bank Churners Dataset
- 10,127 customers | 20 columns
- Key fields: Demographics, card type, income, transaction behaviour, churn status.....

## Tools Used
- MySQL / MySQL Workbench
- Advanced SQL -CTEs, Window Functions, Subqueries, CASE WHEN, Risk Scoring

## Key Findings

| # | Insight |
|---|---------|
| 1 | Overall churn rate is 16.07% |
| 2 | $120K+ earners have highest churn RATE (17.33%) despite being smallest segment |
| 3 | Gold card holders churn at 18.1% - highest among significant card segments |
| 4 | Female customers churn at 17.36% vs 14.62% for males |
| 5 | Churned customers average only 44 transactions vs 68 for existing - low activity is an early warning signal |
| 6 | 233 customers flagged as immediate flight risk - inactive 3+ months with <50 transactions |
| 7 | Risk model identified 1,316 High Risk customers (13% of base) requiring immediate retention action |
| 8 | Unknown marital status correlates with highest churn (17.22%) — incomplete profiles = higher risk |

## SQL Concepts Covered
- CTEs (Common Table Expressions)
- Window Functions — RANK(), AVG() OVER, SUM() OVER, PARTITION BY
- CASE WHEN for bucketing and scoring
- Subqueries
- Aggregate functions with GROUP BY
- Multi-condition filtering
- Customer risk scoring model

## Business Recommendations
1. **Immediate:** Reach out to 1,316 high-risk customers with retention offers
2. **Premium segment:** Design loyalty program specifically for $120K+ earners
3. **Early warning system:** Flag customers with <50 transactions and 3+ inactive months
4. **Upsell opportunity:** Target high credit limit / low utilization customers with rewards campaigns

## File Structure
- [case_study_bankchurners_krishkamboj.sql](https://github.com/user-attachments/files/29737275/case_study_bankchurners_krishkamboj.sql) - All 20 queries with business questions and insights written 

## Key Findings

### 1. Overall Churn Overview
<img width="729" height="269" alt="q1_churn_overview" src="https://github.com/user-attachments/assets/99397a3a-aa6c-47d2-9f26-4f4e95b94c33" />


### 2. Churn Rate by Income Category
<img width="853" height="458" alt="q4_income_churn" src="https://github.com/user-attachments/assets/8734439e-44b7-48ee-b278-71432c002645" />


### 3. Churn Rate by Card Category
<img width="885" height="399" alt="q5_card_churn" src="https://github.com/user-attachments/assets/7532e6d4-a0a3-41b1-baee-459b9589f9a4" />


### 4. Gender Churn Rate
<img width="897" height="301" alt="q10_gender_churn" src="https://github.com/user-attachments/assets/13b10d2b-b3dc-43ef-a2f5-b2f41dcfe7f1" />


### 5. Risk Segmentation Summary
<img width="876" height="570" alt="q15_risk_summary_query" src="https://github.com/user-attachments/assets/e2fcd020-6337-4e82-bdb6-e51c70b3817d" />

<img width="650" height="613" alt="q15_result_table" src="https://github.com/user-attachments/assets/b0556134-c65a-41f3-b928-7afdfb938771" />


### 6. Flight Risk Customers
<img width="1130" height="721" alt="q11_flight_risk" src="https://github.com/user-attachments/assets/1357f3e6-23c7-464e-8fc4-4b764ef3b485" />


### 7. Age Group Churn
<img width="855" height="654" alt="q7_churn_age_group" src="https://github.com/user-attachments/assets/1862f636-c030-4a08-b5f9-855b0654d378" />


### 8. Master Customer Summary
<img width="901" height="637" alt="q20_master_summary" src="https://github.com/user-attachments/assets/a2381977-8f78-4400-ab22-4a827d99742d" />


