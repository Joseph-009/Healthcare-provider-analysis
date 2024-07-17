SELECT *
 FROM helthcare_provider.helthcare_data
 limit 10;
 
 -- Check the structure of the table
DESCRIBE helthcare_provider.helthcare_data;

# Data Cleaning and Preprocessing

-- Check for missing values
SELECT 
    COUNT(*) AS total_rows,
    COUNT(region) AS non_null_region,
    COUNT(region_code) AS non_null_region_code,
    COUNT(period) AS non_null_period,
    COUNT(state_fips) AS non_null_state_fips,
    COUNT(county_fips) AS non_null_county_fips,
    COUNT(fips) AS non_null_fips,
    COUNT(all_providers) AS non_null_all_providers,
    COUNT(all_primary_care_providers) AS non_null_all_primary_care_providers,
    COUNT(all_physicians) AS non_null_all_physicians,
    COUNT(all_primary_care_physicians) AS non_null_all_primary_care_physicians,
    COUNT(all_nurse_practitioners) AS non_null_all_nurse_practitioners,
    COUNT(all_primary_care_nurse_practitioners) AS non_null_all_primary_care_nurse_practitioners,
    COUNT(all_physician_assistants) AS non_null_all_physician_assistants,
    COUNT(all_primary_care_physician_assistants) AS non_null_all_primary_care_physician_assistants
FROM 
    healthcare_provider.healthcare_data;
    
-- Handle missing values (example: replace NULL with 0)
UPDATE healthcare_provider.healthcare_data
SET 
    all_providers = COALESCE(all_providers, 0),
    all_primary_care_providers = COALESCE(all_primary_care_providers, 0),
    all_physicians = COALESCE(all_physicians, 0),
    all_primary_care_physicians = COALESCE(all_primary_care_physicians, 0),
    all_nurse_practitioners = COALESCE(all_nurse_practitioners, 0),
    all_primary_care_nurse_practitioners = COALESCE(all_primary_care_nurse_practitioners, 0),
    all_physician_assistants = COALESCE(all_physician_assistants, 0),
    all_primary_care_physician_assistants = COALESCE(all_primary_care_physician_assistants, 0);
    
    
#  Descriptive Statistics
-- Summary statistics for each type of healthcare provider
SELECT
    AVG(all_providers) AS avg_all_providers,
    AVG(all_primary_care_providers) AS avg_all_primary_care_providers,
    AVG(all_physicians) AS avg_all_physicians,
    AVG(all_primary_care_physicians) AS avg_all_primary_care_physicians,
    AVG(all_nurse_practitioners) AS avg_all_nurse_practitioners,
    AVG(all_primary_care_nurse_practitioners) AS avg_all_primary_care_nurse_practitioners,
    AVG(all_physician_assistants) AS avg_all_physician_assistants,
    AVG(all_primary_care_physician_assistants) AS avg_all_primary_care_physician_assistants
FROM
    healthcare_provider.healthcare_data;
    
# 3. Regional Analysis

-- Number of healthcare providers by region
SELECT 
    region, 
    SUM(all_providers) AS total_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_providers DESC;

# 4. State and County-Level Analysis
-- Number of healthcare providers by state and county
SELECT 
    state_fips, 
    county_fips, 
    SUM(all_providers) AS total_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    state_fips, 
    county_fips
ORDER BY 
    total_providers DESC;
    
# 5. Primary Care Focus
-- Availability of primary care providers
SELECT 
    region, 
    SUM(all_primary_care_providers) AS total_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_primary_care_providers DESC;
    
# 6. Trends Over Time
-- Trends in the number of healthcare providers over different periods
SELECT 
    period, 
    SUM(all_providers) AS total_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    period
ORDER BY 
    period;

# 7. Resource Allocation Recommendations
-- Identify regions with provider shortages
SELECT 
    region, 
    SUM(all_providers) AS total_providers,
    SUM(all_primary_care_providers) AS total_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
HAVING 
    SUM(all_primary_care_providers) < (SELECT AVG(all_primary_care_providers) FROM healthcare_provider.healthcare_data)
ORDER BY 
    total_primary_care_providers ASC;
    
# Without Having
SELECT 
    region, 
    SUM(all_providers) AS total_providers,
    SUM(all_primary_care_providers)  AS total_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_primary_care_providers ASC;
    
    use healthcare_provider;
    
-- Create a common table expression (CTE) to calculate total providers by region
-- Step 1: Create a common table expression (CTE) to calculate total providers by region
WITH provider_stats AS (
    SELECT 
        region,
        SUM(all_providers) AS total_providers,
        SUM(all_primary_care_providers) AS total_primary_care_providers
    FROM 
        healthcare_provider.healthcare_data
    GROUP BY 
        region
),
-- Step 2: Rank the total primary care providers and find the median value
ranked_providers AS (
    SELECT
        region,
        total_providers,
        total_primary_care_providers,
        DENSE_RANK() OVER (ORDER BY total_primary_care_providers ASC) AS rank_asc,
        DENSE_RANK() OVER (ORDER BY total_primary_care_providers DESC) AS rank_desc
    FROM
        provider_stats
),
-- Step 3: Calculate the median rank
median_rank AS (
    SELECT 
        CEIL(MAX(rank_asc) / 2) AS median_rank
    FROM 
        ranked_providers
)
-- Step 4: Select the median value
SELECT 
    rp.region, 
    rp.total_providers,
    rp.total_primary_care_providers
FROM 
    ranked_providers rp,
    median_rank mr
WHERE 
    rp.rank_asc = mr.median_rank
   OR rp.rank_desc = mr.median_rank
ORDER BY 
    rp.total_primary_care_providers ASC;

-- Step 5: Select regions with total_primary_care_providers below the median
WITH provider_stats AS (
    SELECT 
        region,
        SUM(all_providers) AS total_providers,
        SUM(all_primary_care_providers) AS total_primary_care_providers
    FROM 
        healthcare_provider.healthcare_data
    GROUP BY 
        region
),
ranked_providers AS (
    SELECT
        region,
        total_providers,
        total_primary_care_providers,
        DENSE_RANK() OVER (ORDER BY total_primary_care_providers ASC) AS rank_asc,
        DENSE_RANK() OVER (ORDER BY total_primary_care_providers DESC) AS rank_desc
    FROM
        provider_stats
),
median_rank AS (
    SELECT 
        CEIL(MAX(rank_asc) / 2) AS median_rank
    FROM 
        ranked_providers
),
median_value AS (
    SELECT 
        AVG(total_primary_care_providers) AS median_primary_care_providers
    FROM 
        ranked_providers
    WHERE 
        rank_asc = (SELECT median_rank FROM median_rank)
       OR rank_desc = (SELECT median_rank FROM median_rank)
)
SELECT 
    ps.region, 
    ps.total_providers,
    ps.total_primary_care_providers
FROM 
    provider_stats ps
WHERE 
    ps.total_primary_care_providers < (SELECT median_primary_care_providers FROM median_value)
ORDER BY 
    ps.total_primary_care_providers ASC;


SELECT 
    region,
    COUNT(*) AS row_count,
    SUM(CASE WHEN all_primary_care_providers IS NULL THEN 1 ELSE 0 END) AS null_primary_care_providers,
    SUM(CASE WHEN all_primary_care_providers = 0 THEN 1 ELSE 0 END) AS zero_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region;







    
    
    
    
    
    