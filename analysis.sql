-- ========================================================
-- E-COMMERCE CUSTOMER BEHAVIOR ANALYSIS QUERIES
-- ========================================================

-- 1. Create Base Transactions Table
CREATE TABLE IF NOT EXISTS customer_shopping (
    ID INT PRIMARY KEY,
    Year_Birth INT,
    Education VARCHAR(50),
    Marital_Status VARCHAR(50),
    Income DECIMAL(10,2),
    Kidhome INT,
    Teenhome INT,
    Dt_Customer DATE,
    Recency INT,
    MntWines DECIMAL(10,2),
    MntFruits DECIMAL(10,2),
    MntMeatProducts DECIMAL(10,2),
    MntFishProducts DECIMAL(10,2),
    MntSweetProducts DECIMAL(10,2),
    MntGoldProds DECIMAL(10,2),
    NumDealsPurchases INT,
    NumWebPurchases INT,
    NumCatalogPurchases INT,
    NumStorePurchases INT,
    NumWebVisitsMonth INT,
    Response INT
);

-- 2. Customer Spending Analysis & Loyalty Tier Segmentation
SELECT 
    ID,
    Income,
    (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spending,
    CASE 
        WHEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) >= 1500 THEN 'Platinum'
        WHEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) BETWEEN 800 AND 1499 THEN 'Gold'
        WHEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) BETWEEN 300 AND 799 THEN 'Silver'
        ELSE 'Bronze'
    END AS Customer_Tier
FROM customer_shopping
ORDER BY Total_Spending DESC;

-- 3. Channel Revenue Performance (Web vs. Store vs. Catalog)
SELECT 
    SUM(NumWebPurchases) AS Total_Web_Orders,
    SUM(NumStorePurchases) AS Total_Store_Orders,
    SUM(NumCatalogPurchases) AS Total_Catalog_Orders,
    ROUND(AVG(NumWebVisitsMonth), 2) AS Avg_Monthly_Web_Visits
FROM customer_shopping;

-- 4. Promotional Campaign Acceptance & Discount Driver Analysis
SELECT 
    Marital_Status,
    COUNT(ID) AS Total_Customers,
    ROUND(AVG(NumDealsPurchases), 2) AS Avg_Deals_Used,
    ROUND(AVG(Response) * 100, 2) AS Campaign_Conversion_Rate_Pct
FROM customer_shopping
GROUP BY Marital_Status
ORDER BY Campaign_Conversion_Rate_Pct DESC;