-- =====================================================
-- Insurance Policy & Claims Portfolio Analysis
-- Business Intelligence Internship Assignment
-- =====================================================

-- =====================================================
-- 1. Portfolio Overview
-- =====================================================

CREATE DATABASE insurance_analysis;
USE insurance_analysis;


SELECT 
COUNT(*) AS Total_Policies
FROM policy_sales_data;

-- ===========================================================================================================
-- 1.The dataset contains approximately 1 million insurance policies, which aligns closely with the simulation 
-- assumption of 1,000,000 customers purchasing policies in 2024.
-- ===========================================================================================================

SELECT 
SUM(Premium) AS Total_Premium_Collected
FROM policy_sales_data;

-- ====================================================================================
-- 2.The company generated ₹24.01 crores in premium revenue from policies sold in 2024.
-- ====================================================================================

SELECT 
SUM(Claim_Amount) as Total_Claim_Amount
FROM claims_data;

-- ===============================================================================================================
-- 3.The total claim amount across all policies is approximately ₹98.81 Crores, representing the total payouts the 
-- insurer may need to cover for reported claims during the analyzed period.
-- ===============================================================================================================

SELECT 
AVG(Claim_Amount) AS Avg_Claim
FROM claims_data;

-- ==============================================================
-- 4.The average claim amount is approximately ₹20,000 per claim.
-- ==============================================================

SELECT 
COUNT(*) / (SELECT COUNT(*) FROM policy_sales_data) * 100
AS Claim_Frequency
FROM claims_data;

-- ====================================================================================================
-- 5.The claim frequency is approximately 4.94%, meaning that about 5 out of every 100 policies result 
-- in a claim during the analyzed period.
-- ====================================================================================================

SELECT 
Claim_Type,
COUNT(*) AS Total_Claims
FROM claims_data
GROUP BY Claim_Type;

-- =========================================================================================================================
-- 6.Most claims are first-time claims (49,064), while only 342 are repeat claims. This indicates that repeat claim behavior 
-- is relatively rare, suggesting that the majority of policyholders file only one claim during the policy period.
-- =========================================================================================================================

SELECT 
Policy_Tenure,
COUNT(*) AS Total_Policies
FROM policy_sales_data
GROUP BY Policy_Tenure;

-- ===========================================================================================================================
-- 7.The policy distribution closely follows the expected tenure mix, with 3-year policies forming the largest portion of the 
-- portfolio, followed by 2-year and 1-year policies, while 4-year policies represent the smallest share. This confirms that 
-- the dataset aligns with the intended policy tenure assumptions.
-- ============================================================================================================================

SELECT 
Policy_Tenure,
SUM(Premium) AS Total_Premium
FROM policy_sales_data
GROUP BY Policy_Tenure;

-- ==================================================================================================================================
-- 8. 3-year policies contribute the highest premium revenue (₹11.99 Cr) due to their large share in the portfolio. 
-- Shorter-tenure policies generate lower revenue, while 4-year policies generate moderate revenue despite higher premiums per policy 
-- because they represent a smaller portion of the portfolio.
-- ==================================================================================================================================

SELECT 
DATE_FORMAT(Claim_Date, '%Y-%m') AS Claim_Month,
SUM(Claim_Amount) AS Monthly_Claims
FROM claims_data
GROUP BY Claim_Month
ORDER BY Claim_Month;

-- ============================================================================================================
-- 9.Monthly claim costs remain relatively stable throughout 2025, averaging around ₹6.4–₹6.7 Crores per month.
-- ============================================================================================================

SELECT 
p.Policy_Tenure,
SUM(p.Premium) AS Total_Premium,
SUM(c.Claim_Amount) AS Total_Claims,
SUM(c.Claim_Amount) / SUM(p.Premium) AS Loss_Ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY p.Policy_Tenure;

-- ==============================================================================================================================
-- 10. 3-year policies are the most profitable, with the lowest loss ratio (2.60). Short-term policies,
-- particularly 1-year policies, show the highest loss ratio (7.85), indicating higher claim costs relative to premium revenue.
-- ==============================================================================================================================

SELECT 
MONTH(p.Policy_Purchase_Date) AS Sales_Month,
SUM(p.Premium) AS Total_Premium,
SUM(c.Claim_Amount) AS Total_Claims,
SUM(c.Claim_Amount) / SUM(p.Premium) AS Loss_Ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY Sales_Month
ORDER BY Sales_Month;

-- =======================================================================================================================================
-- 11.Loss ratios remain stable across most months, indicating consistent claim behavior relative to premium revenue. However, July shows 
-- an extremely high loss ratio (~25.64) due to a spike in claims, suggesting a concentration of defect-related claims for policies sold 
-- during that period.
-- =======================================================================================================================================

SELECT 
SUM(p.Vehicle_Value * 0.10) AS Potential_Future_Liability
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
WHERE c.Vehicle_ID IS NULL;

-- ============================================================================================================================================
-- 12.The estimated potential future claim liability is approximately ₹950.85 Crores, representing the maximum claim exposure if all remaining
-- policies eventually file a claim. This metric helps insurers evaluate long-term financial risk and reserve requirements.
-- ============================================================================================================================================

SELECT 
SUM(Premium) / SUM(DATEDIFF(Policy_End_Date, Policy_Start_Date)) 
AS Daily_Premium
FROM policy_sales_data;

-- =================================================================================================================================================
-- 13.The average daily premium is approximately ₹0.27, representing the portion of premium revenue earned each day over the policy coverage period.
-- This helps insurers recognize revenue gradually as risk is covered over time.
-- =================================================================================================================================================

SELECT 
p.Policy_Tenure,
SUM(p.Premium) AS Total_Premium,
SUM(c.Claim_Amount) AS Total_Claims,
SUM(c.Claim_Amount) / SUM(p.Premium) AS Loss_Ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY p.Policy_Tenure
ORDER BY Loss_Ratio;

-- ============================================================================================================================================
-- 14.The profitability analysis shows that 3-year policies are the most profitable, with the lowest loss ratio (2.60). In contrast,
-- 1-year policies have the highest loss ratio (7.85), making them the least profitable due to higher claim costs relative to premium revenue.
-- ============================================================================================================================================

SELECT 
SUM(c.Claim_Amount) / SUM(p.Premium) AS Portfolio_Loss_Ratio
FROM policy_sales_data p
LEFT JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID;

-- =======================================================================================================================================
-- 15.The portfolio loss ratio is 4.11 (411%), indicating that total claims significantly exceed premium revenue. This suggests that the 
-- portfolio is financially unsustainable without adjustments to pricing or risk management strategies.
-- =======================================================================================================================================

SELECT 
SUM(Claim_Amount) AS Current_Claims,
SUM(Claim_Amount)*1.05 AS Claims_Next_Year,
SUM(Claim_Amount)*1.10 AS Claims_In_2_Years
FROM claims_data;

-- ================================================================================================================================================
-- 16.If claim frequency increases by 5% annually, total claim costs could rise from ₹98.81 Crores currently to ₹103.75 Crores next year
-- and ₹108.69 Crores within two years. This growth in claim costs may significantly impact portfolio profitability if premiums remain unchanged.
-- =================================================================================================================================================

SELECT 
SUM(
    Premium *
    (LEAST('2026-02-28', Policy_End_Date) - Policy_Start_Date) /
    (Policy_End_Date - Policy_Start_Date)
) AS Earned_Premium_Till_Feb_2026
FROM policy_sales_data
WHERE Policy_Start_Date <= '2026-02-28';

-- ===============================================================================================================================
-- The insurer has earned approximately ₹9.58 Crores in premium revenue by February 28, 2026, representing the portion of premium
-- corresponding to the coverage period that has already elapsed.
-- ===============================================================================================================================