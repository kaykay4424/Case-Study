# Credit Card Churn Analysis — SQL Case Study

## Project Overview
Analysed 10,127 credit card customers for a bank to identify churn patterns, 
risk segments, and retention opportunities using advanced SQL.

## Business Problem
The bank is losing customers and needs to understand:
- Who is churning and why?
- Which segments are highest risk?
- Where should retention efforts be focused?

## Dataset
- Source: Kaggle — Bank Churners Dataset
- 10,127 customers | 20 columns
- Key fields: Demographics, card type, income, transaction behaviour, churn status

## Tools Used
- MySQL / MySQL Workbench
- Advanced SQL — CTEs, Window Functions, Subqueries, CASE WHEN, Risk Scoring

## Key Findings

| # | Insight |
|---|---------|
| 1 | Overall churn rate is 16.07% |
| 2 | $120K+ earners have highest churn RATE (17.33%) despite being smallest segment |
| 3 | Gold card holders churn at 18.1% — highest among significant card segments |
| 4 | Female customers churn at 17.36% vs 14.62% for males |
| 5 | Churned customers average only 44 transactions vs 68 for existing — low activity is an early warning signal |
| 6 | 233 customers flagged as immediate flight risk — inactive 3+ months with <50 transactions |
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
- `case_study_bankchurners_krishkamboj.sql` — All 20 queries with business questions and insights
