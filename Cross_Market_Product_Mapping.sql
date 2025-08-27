-- =====================================================
-- Cross-Market Product Opportunity Analysis - Complete SQL Queries
-- African Fintech Market Expansion Analysis
-- Dataset: 9+ African markets with comprehensive metrics
-- Analyst: Chituru Chikwem
-- =====================================================

-- Table Structure (for reference)
-- CREATE TABLE cross_market_dataset (
--     Country VARCHAR(50) PRIMARY KEY,
--     Market_Score DECIMAL(5,3),
--     Population_M DECIMAL(5,1),
--     GDP_per_Capita INTEGER,
--     Mobile_Money_Users_M DECIMAL(4,1),
--     Digital_Adoption_Pct DECIMAL(4,1),
--     Regulatory_Score DECIMAL(3,1),
--     Expected_ROI_Pct INTEGER,
--     Risk_Factor DECIMAL(4,3),
--     Market_Tier VARCHAR(10)
-- );

-- =====================================================
-- 1. OVERALL MARKET OVERVIEW AND DATASET VALIDATION
-- =====================================================

-- Basic dataset overview
SELECT 
    COUNT(*) as total_markets,
    COUNT(DISTINCT Market_Tier) as tier_levels,
    AVG(Market_Score) as avg_market_score,
    SUM(Population_M) as total_population,
    AVG(GDP_per_Capita) as avg_gdp_per_capita,
    SUM(Mobile_Money_Users_M) as total_mobile_money_users,
    AVG(Digital_Adoption_Pct) as avg_digital_adoption,
    AVG(Regulatory_Score) as avg_regulatory_score,
    AVG(Expected_ROI_Pct) as avg_expected_roi,
    AVG(Risk_Factor) as avg_risk_factor
FROM cross_market_dataset;

-- Market distribution by tier
SELECT 
    Market_Tier,
    COUNT(*) as market_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cross_market_dataset), 1) as percentage,
    AVG(Market_Score) as avg_score,
    SUM(Population_M) as total_population,
    AVG(Expected_ROI_Pct) as avg_roi,
    AVG(Risk_Factor) as avg_risk
FROM cross_market_dataset
GROUP BY Market_Tier
ORDER BY AVG(Market_Score) DESC;

-- =====================================================
-- 2. TIER 1 MARKETS ANALYSIS (Nigeria, Kenya, South Africa)
-- =====================================================

-- Tier 1 market performance metrics (matching webpage data)
SELECT 
    Country,
    Market_Score,
    Population_M,
    GDP_per_Capita,
    Mobile_Money_Users_M,
    Digital_Adoption_Pct,
    Regulatory_Score,
    Expected_ROI_Pct,
    Risk_Factor,
    CASE 
        WHEN Expected_ROI_Pct >= 150 THEN '$1.2M'
        WHEN Expected_ROI_Pct >= 120 THEN '$0.8M'
        ELSE '$0.6M'
    END as Investment_Recommendation
FROM cross_market_dataset
WHERE Market_Tier = 'Tier 1'
ORDER BY Market_Score DESC;

-- Tier 1 detailed comparison
SELECT 
    'Tier 1 Summary' as analysis_type,
    COUNT(*) as market_count,
    ROUND(AVG(Market_Score), 1) as avg_market_score,
    ROUND(SUM(Population_M), 1) as total_population_m,
    ROUND(AVG(GDP_per_Capita), 0) as avg_gdp_per_capita,
    ROUND(SUM(Mobile_Money_Users_M), 1) as total_mobile_users_m,
    ROUND(AVG(Digital_Adoption_Pct), 1) as avg_digital_adoption,
    ROUND(AVG(Regulatory_Score), 1) as avg_regulatory_score,
    ROUND(AVG(Expected_ROI_Pct), 0) as avg_expected_roi,
    ROUND(AVG(Risk_Factor), 3) as avg_risk_factor
FROM cross_market_dataset
WHERE Market_Tier = 'Tier 1';

-- =====================================================
-- 3. COMPREHENSIVE TIER ANALYSIS
-- =====================================================

-- All tiers performance comparison
SELECT 
    Market_Tier,
    COUNT(*) as market_count,
    ROUND(AVG(Market_Score), 1) as avg_market_score,
    ROUND(SUM(Population_M), 1) as total_population,
    ROUND(AVG(GDP_per_Capita), 0) as avg_gdp,
    ROUND(SUM(Mobile_Money_Users_M), 1) as total_mobile_users,
    ROUND(AVG(Digital_Adoption_Pct), 1) as avg_digital_adoption,
    ROUND(AVG(Regulatory_Score), 1) as avg_regulatory,
    ROUND(AVG(Expected_ROI_Pct), 0) as avg_roi,
    ROUND(AVG(Risk_Factor), 3) as avg_risk,
    CASE 
        WHEN AVG(Expected_ROI_Pct) >= 150 THEN '$1.2M'
        WHEN AVG(Expected_ROI_Pct) >= 120 THEN '$0.8M'
        ELSE '$0.6M'
    END as recommended_investment
FROM cross_market_dataset
GROUP BY Market_Tier
ORDER BY AVG(Market_Score) DESC;

-- Market ranking within each tier
SELECT 
    ROW_NUMBER() OVER (PARTITION BY Market_Tier ORDER BY Market_Score DESC) as tier_rank,
    Country,
    Market_Tier,
    Market_Score,
    Population_M,
    Mobile_Money_Users_M,
    Expected_ROI_Pct,
    Risk_Factor
FROM cross_market_dataset
ORDER BY Market_Tier, tier_rank;

-- =====================================================
-- 4. TOP PERFORMERS ANALYSIS (Matching webpage metrics)
-- =====================================================

-- Highest mobile money adoption (Kenya: 94.3%)
SELECT 
    'Mobile Money Adoption' as metric,
    Country,
    Digital_Adoption_Pct as value,
    Market_Score,
    Expected_ROI_Pct,
    Market_Tier
FROM cross_market_dataset
ORDER BY Digital_Adoption_Pct DESC
LIMIT 5;

-- Highest regulatory scores (Kenya: 9.2/10)
SELECT 
    'Regulatory Environment' as metric,
    Country,
    Regulatory_Score as value,
    Market_Score,
    Expected_ROI_Pct,
    Risk_Factor
FROM cross_market_dataset
ORDER BY Regulatory_Score DESC
LIMIT 5;

-- Largest markets by population
SELECT 
    'Market Size (Population)' as metric,
    Country,
    Population_M as value,
    Mobile_Money_Users_M,
    Market_Score,
    Expected_ROI_Pct
FROM cross_market_dataset
ORDER BY Population_M DESC
LIMIT 5;

-- Highest Expected ROI markets
SELECT 
    'Expected ROI Performance' as metric,
    Country,
    Expected_ROI_Pct as value,
    Market_Score,
    Risk_Factor,
    Market_Tier
FROM cross_market_dataset
ORDER BY Expected_ROI_Pct DESC
LIMIT 5;

-- =====================================================
-- 5. RISK-RETURN ANALYSIS
-- =====================================================

-- Risk-adjusted returns analysis
SELECT 
    Country,
    Market_Score,
    Expected_ROI_Pct,
    Risk_Factor,
    ROUND(Expected_ROI_Pct / (Risk_Factor * 100), 2) as risk_adjusted_return,
    Market_Tier,
    CASE 
        WHEN Risk_Factor <= 0.15 THEN 'Low Risk'
        WHEN Risk_Factor <= 0.25 THEN 'Medium Risk'
        ELSE 'High Risk'
    END as risk_category
FROM cross_market_dataset
ORDER BY risk_adjusted_return DESC;

-- Risk distribution by tier
SELECT 
    Market_Tier,
    COUNT(*) as market_count,
    ROUND(AVG(Risk_Factor), 3) as avg_risk,
    ROUND(MIN(Risk_Factor), 3) as min_risk,
    ROUND(MAX(Risk_Factor), 3) as max_risk,
    ROUND(AVG(Expected_ROI_Pct), 1) as avg_roi,
    ROUND(AVG(Expected_ROI_Pct / (Risk_Factor * 100)), 2) as avg_risk_adjusted_return
FROM cross_market_dataset
GROUP BY Market_Tier
ORDER BY avg_risk_adjusted_return DESC;

-- =====================================================
-- 6. MOBILE MONEY MARKET PENETRATION ANALYSIS
-- =====================================================

-- Mobile money penetration rates
SELECT 
    Country,
    Population_M,
    Mobile_Money_Users_M,
    ROUND((Mobile_Money_Users_M / Population_M) * 100, 1) as penetration_rate,
    Digital_Adoption_Pct,
    Market_Score,
    Expected_ROI_Pct,
    Market_Tier
FROM cross_market_dataset
ORDER BY penetration_rate DESC;

-- Mobile money market opportunity sizing
SELECT 
    Market_Tier,
    COUNT(*) as markets,
    ROUND(SUM(Population_M), 1) as total_population_m,
    ROUND(SUM(Mobile_Money_Users_M), 1) as total_mobile_users_m,
    ROUND(AVG((Mobile_Money_Users_M / Population_M) * 100), 1) as avg_penetration_rate,
    ROUND(SUM(Population_M - Mobile_Money_Users_M), 1) as untapped_population_m,
    ROUND(AVG(Expected_ROI_Pct), 1) as avg_expected_roi
FROM cross_market_dataset
GROUP BY Market_Tier
ORDER BY total_mobile_users_m DESC;

-- =====================================================
-- 7. GDP AND MARKET MATURITY ANALYSIS
-- =====================================================

-- GDP per capita vs Market Score correlation
SELECT 
    Country,
    GDP_per_Capita,
    Market_Score,
    Population_M,
    Expected_ROI_Pct,
    Market_Tier,
    CASE 
        WHEN GDP_per_Capita >= 5000 THEN 'High Income'
        WHEN GDP_per_Capita >= 2000 THEN 'Upper Middle Income'
        WHEN GDP_per_Capita >= 1000 THEN 'Lower Middle Income'
        ELSE 'Low Income'
    END as income_category
FROM cross_market_dataset
ORDER BY GDP_per_Capita DESC;

-- Income category analysis
SELECT 
    CASE 
        WHEN GDP_per_Capita >= 5000 THEN 'High Income'
        WHEN GDP_per_Capita >= 2000 THEN 'Upper Middle Income'
        WHEN GDP_per_Capita >= 1000 THEN 'Lower Middle Income'
        ELSE 'Low Income'
    END as income_category,
    COUNT(*) as market_count,
    ROUND(AVG(Market_Score), 1) as avg_market_score,
    ROUND(AVG(GDP_per_Capita), 0) as avg_gdp,
    ROUND(AVG(Expected_ROI_Pct), 1) as avg_roi,
    ROUND(AVG(Digital_Adoption_Pct), 1) as avg_digital_adoption
FROM cross_market_dataset
GROUP BY income_category
ORDER BY avg_gdp DESC;

-- =====================================================
-- 8. INVESTMENT RECOMMENDATION ENGINE
-- =====================================================

-- Investment allocation by tier (matching webpage recommendations)
SELECT 
    Market_Tier,
    COUNT(*) as market_count,
    ROUND(AVG(Expected_ROI_Pct), 1) as avg_roi,
    ROUND(AVG(Risk_Factor), 3) as avg_risk,
    CASE 
        WHEN AVG(Expected_ROI_Pct) >= 150 THEN '$1.2M'
        WHEN AVG(Expected_ROI_Pct) >= 120 THEN '$0.8M'
        ELSE '$0.6M'
    END as recommended_investment_per_market,
    CASE 
        WHEN AVG(Expected_ROI_Pct) >= 150 THEN COUNT(*) * 1.2
        WHEN AVG(Expected_ROI_Pct) >= 120 THEN COUNT(*) * 0.8
        ELSE COUNT(*) * 0.6
    END as total_tier_investment_m
FROM cross_market_dataset
GROUP BY Market_Tier
ORDER BY avg_roi DESC;

-- Individual market investment recommendations
SELECT 
    Country,
    Market_Score,
    Expected_ROI_Pct,
    Risk_Factor,
    Population_M,
    Mobile_Money_Users_M,
    Market_Tier,
    CASE 
        WHEN Expected_ROI_Pct >= 150 THEN '$1.2M'
        WHEN Expected_ROI_Pct >= 120 THEN '$0.8M'
        ELSE '$0.6M'
    END as investment_recommendation,
    CASE 
        WHEN Market_Score >= 80 THEN 'Immediate Entry'
        WHEN Market_Score >= 65 THEN 'Phased Entry'
        ELSE 'Monitor & Evaluate'
    END as entry_strategy
FROM cross_market_dataset
ORDER BY Market_Score DESC;

-- =====================================================
-- 9. COMPETITIVE LANDSCAPE METRICS
-- =====================================================

-- Market concentration and competition analysis
SELECT 
    Country,
    Market_Score,
    Population_M,
    Mobile_Money_Users_M,
    Digital_Adoption_Pct,
    Regulatory_Score,
    Expected_ROI_Pct,
    Risk_Factor,
    CASE 
        WHEN Digital_Adoption_Pct >= 90 THEN 'Highly Competitive'
        WHEN Digital_Adoption_Pct >= 70 THEN 'Moderately Competitive'
        ELSE 'Emerging Market'
    END as competitive_landscape
FROM cross_market_dataset
ORDER BY Digital_Adoption_Pct DESC;

-- Market attractiveness matrix
SELECT 
    Country,
    Market_Score,
    CASE 
        WHEN Market_Score >= 80 AND Risk_Factor <= 0.20 THEN 'Star Markets'
        WHEN Market_Score >= 70 AND Risk_Factor <= 0.25 THEN 'Promising Markets'
        WHEN Market_Score >= 60 THEN 'Potential Markets'
        ELSE 'Monitor Markets'
    END as market_category,
    Expected_ROI_Pct,
    Risk_Factor,
    Population_M,
    Market_Tier
FROM cross_market_dataset
ORDER BY Market_Score DESC, Risk_Factor ASC;

-- =====================================================
-- 10. VALIDATION QUERIES (Matching webpage statistics)
-- =====================================================

-- Nigeria market validation (87.3 score, 218M population, 45.2M mobile users, 150% ROI)
SELECT 
    'Nigeria Validation' as check_type,
    Country,
    Market_Score,
    Population_M,
    Mobile_Money_Users_M,
    Expected_ROI_Pct,
    Market_Tier
FROM cross_market_dataset
WHERE Country = 'Nigeria';

-- Kenya market validation (84.1 score, 54M population, 32.1M mobile users, 165% ROI)
SELECT 
    'Kenya Validation' as check_type,
    Country,
    Market_Score,
    Population_M,
    Mobile_Money_Users_M,
    Expected_ROI_Pct,
    Digital_Adoption_Pct,
    Regulatory_Score,
    Market_Tier
FROM cross_market_dataset
WHERE Country = 'Kenya';

-- South Africa market validation (78.9 score, 60.4M population, 18.5M mobile users, 140% ROI)
SELECT 
    'South Africa Validation' as check_type,
    Country,
    Market_Score,
    Population_M,
    GDP_per_Capita,
    Mobile_Money_Users_M,
    Expected_ROI_Pct,
    Risk_Factor,
    Market_Tier
FROM cross_market_dataset
WHERE Country = 'South Africa';

-- =====================================================
-- 11. EXECUTIVE SUMMARY DASHBOARD QUERY
-- =====================================================

-- Complete executive summary matching webpage presentation
WITH market_summary AS (
    SELECT 
        COUNT(*) as total_markets,
        COUNT(CASE WHEN Market_Tier = 'Tier 1' THEN 1 END) as tier1_markets,
        COUNT(CASE WHEN Market_Tier = 'Tier 2' THEN 1 END) as tier2_markets,
        COUNT(CASE WHEN Market_Tier = 'Tier 3' THEN 1 END) as tier3_markets,
        ROUND(SUM(Population_M), 1) as total_population,
        ROUND(SUM(Mobile_Money_Users_M), 1) as total_mobile_users,
        ROUND(AVG(Market_Score), 1) as avg_market_score,
        ROUND(AVG(Expected_ROI_Pct), 1) as avg_expected_roi,
        ROUND(AVG(Risk_Factor), 3) as avg_risk_factor
    FROM cross_market_dataset
)
SELECT 
    total_markets,
    tier1_markets,
    tier2_markets,
    tier3_markets,
    total_population as total_population_m,
    total_mobile_users as total_mobile_users_m,
    avg_market_score,
    avg_expected_roi,
    avg_risk_factor,
    ROUND((total_mobile_users / total_population) * 100, 1) as overall_penetration_rate
FROM market_summary;

-- Top 3 investment priorities
SELECT 
    ROW_NUMBER() OVER (ORDER BY Market_Score DESC) as priority_rank,
    Country,
    Market_Score,
    Expected_ROI_Pct,
    Population_M,
    Mobile_Money_Users_M,
    Risk_Factor,
    Market_Tier,
    CASE 
        WHEN Expected_ROI_Pct >= 150 THEN '$1.2M'
        WHEN Expected_ROI_Pct >= 120 THEN '$0.8M'
        ELSE '$0.6M'
    END as recommended_investment
FROM cross_market_dataset
ORDER BY Market_Score DESC
LIMIT 3;
