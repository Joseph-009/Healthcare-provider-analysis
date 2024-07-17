# Project Scenario: Healthcare Provider Data Analysis

## Introduction
I am a junior data analyst working for a healthcare consulting firm. Our company provides data-driven insights to healthcare organizations to improve their service delivery and resource allocation. Recently, my manager, Dr. Sarah Thompson, assigned me the task of analyzing a comprehensive dataset on healthcare providers across various regions in the United States. This dataset includes information on different types of healthcare providers, such as physicians, nurse practitioners, and physician assistants, segmented by region, state, and county.

## Objective
The primary goal of this project is to analyze the distribution and availability of healthcare providers in different regions and identify potential areas with shortages or surpluses of primary care providers. The insights derived from this analysis will help healthcare organizations and policymakers to better allocate resources, plan for future healthcare needs, and address any disparities in healthcare access.

## Dataset Description
The dataset includes the following columns:

- **region**: The name of the region.
- **region_code**: The code corresponding to the region.
- **period**: The time period for the data.
- **state_fips**: Federal Information Processing Standard code for states.
- **county_fips**: Federal Information Processing Standard code for counties.
- **fips**: Combined state and county FIPS code.
- **all_providers**: Total number of healthcare providers.
- **all_primary_care_providers**: Total number of primary care providers.
- **all_physicians**: Total number of physicians.
- **all_primary_care_physicians**: Total number of primary care physicians.
- **all_nurse_practitioners**: Total number of nurse practitioners.
- **all_primary_care_nurse_practitioners**: Total number of primary care nurse practitioners.
- **all_physician_assistants**: Total number of physician assistants.
- **all_primary_care_physician_assistants**: Total number of primary care physician assistants.

## Analysis Plan

### Data Cleaning and Preprocessing
- Check for any missing or inconsistent data and handle appropriately.
- Ensure that all numeric columns are in the correct format for analysis.

### Descriptive Statistics
- Calculate summary statistics for each type of healthcare provider.
- Visualize the distribution of healthcare providers using histograms and box plots.

### Regional Analysis
- Compare the number of healthcare providers across different regions.
- Identify regions with the highest and lowest number of providers.

### State and County-Level Analysis
- Drill down into state and county-level data to identify specific areas with provider shortages.

### Primary Care Focus
- Analyze the availability of primary care providers specifically.
- Determine the ratio of primary care providers to the population in each region.

### Trends Over Time
- Examine trends in the number of healthcare providers over different periods.
- Identify any significant increases or decreases in provider numbers.

### Resource Allocation Recommendations
- Based on the analysis, recommend areas where additional healthcare providers are needed.
- Suggest strategies for addressing identified disparities in healthcare access.


___

# SQL Queries for Healthcare Provider Data Analysis
-- view the 10 rows of the table
```sql
SELECT *
FROM healthcare_provider.healthcare_data
LIMIT 10;
```
___

**Check the structure of the table**


`DESCRIBE healthcare_provider.healthcare_data;`

# Database Table Structure

| Field                                | Type | Null | Key | Default | Extra |
|--------------------------------------|------|------|-----|---------|-------|
| region                               | text | YES  |     | NULL    |       |
| region_code                          | text | YES  |     | NULL    |       |
| period                               | int  | YES  |     | NULL    |       |
| state_fips                           | int  | YES  |     | NULL    |       |
| all_providers                        | int  | YES  |     | NULL    |       |
| all_primary_care_providers           | int  | YES  |     | NULL    |       |
| all_physicians                       | int  | YES  |     | NULL    |       |
| all_primary_care_physicians          | int  | YES  |     | NULL    |       |
| all_nurse_practitioners              | int  | YES  |     | NULL    |       |
| all_primary_care_nurse_practitioners | int  | YES  |     | NULL    |       |
| all_physician_assistants             | int  | YES  |     | NULL    |       |

___

### Data Cleaning and Preprocessing
-- Check for missing values
```sql
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

```                                       
___

-- Handle missing values (example: replace NULL with 0)
```sql
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
```

___

### Descriptive Statistics
-- Summary statistics for each type of healthcare provider
```sql
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
```

___

# Regional Analysis
-- Number of healthcare providers by region
```sql
SELECT 
    region, 
    SUM(all_providers) AS total_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_providers DESC;
```
___

# State and County-Level Analysis
-- Number of healthcare providers by state and county
```sql
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

```

___

# Primary Care Focus
-- Availability of primary care providers
```sql
SELECT 
    region, 
    SUM(all_primary_care_providers) AS total_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_primary_care_providers DESC;
```

___
# Trends Over Time
-- Trends in the number of healthcare providers over different periods
```sql
SELECT 
    period, 
    SUM(all_providers) AS total_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    period
ORDER BY 
    period;
```
___
# Resource Allocation Recommendations Analysis
-- Identify regions with provider shortages
```sql
SELECT 
    region, 
    SUM(all_providers) AS total_providers,
    SUM(all_primary_care_providers)  AS total_primary_care_providers,
    AVG(all_primary_care_providers) AS avg_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region
ORDER BY 
    total_primary_care_providers ASC;

```
___

-- Calculate total providers by region
```sql
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

```
___
-- Identify regions with null or zero primary care providers
```sql
SELECT 
    region,
    COUNT(*) AS row_count,
    SUM(CASE WHEN all_primary_care_providers IS NULL THEN 1 ELSE 0 END) AS null_primary_care_providers,
    SUM(CASE WHEN all_primary_care_providers = 0 THEN 1 ELSE 0 END) AS zero_primary_care_providers
FROM 
    healthcare_provider.healthcare_data
GROUP BY 
    region;
```

___
[Visualization using Tableau](https://public.tableau.com/views/Healthcare_Provider/Health_Provider_Analysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
___

## Conclusion
___
After completing the analysis, I found that certain rural and underserved urban areas have significant shortages of primary care providers, particularly in the categories of nurse practitioners and physician assistants. Regions such as the Midwest and certain Southern states exhibited lower ratios of primary care providers to population, indicating potential areas for policy intervention and resource reallocation.

These insights will help healthcare organizations and policymakers to develop targeted strategies for recruiting and retaining healthcare providers in underserved areas, ultimately improving access to primary care and overall health outcomes.

___
