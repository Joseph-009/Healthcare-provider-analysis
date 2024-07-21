# Project Scenario: Healthcare Provider Data Analysis

## Introduction
I am a junior data analyst employed with a health care consulting company. Our company specialises in the analysis of healthcare organisations’ data and the subsequent enhancement of their service delivery and resource management. Recently, in my regular working, my manager, Dr. Sarah Thompson, provided me with the task of the statistical analysis of a large set of data regarding healthcare providers throughout the different regions in the United States of America. This dataset mainly provides data on various categories of healthcare, including doctors, certified nurse practitioners/health officers, and licensed or certified physician assistants, classified by region, state, and county.

## Objective
This project aims to examine the geographic accessibility of primary care providers and detect regions potentially lack/oversupplying in primary health workforce. The results can be used to improve resource distribution, estimating future healthcare demand and needs [4] or disparity in access to care from a public health perspective.

## Analysis Plan
### Data Cleaning and Preprocessing
- Check for any missing or inconsistent data and handle appropriately.
- Check that to all numerical data columns are of the right type for analysis.

### Descriptive Statistics
- Calculate summary statistics for each type of healthcare provider.
- Visualize the distribution of healthcare providers using histograms.

### Regional Analysis
- Compare the number of healthcare providers across different regions.
- Identify regions with the highest and lowest number of providers.

### State and County-Level Analysis
- The target area can be further narrowed down to the state or even county level to determine those areas with provider deficit.

### Primary Care Focus
- Focus more on the measures that relate to primary care providers in particular.
- This means, identify the ratio of primary care physicians to the people in each of the regions of the country.

### Trends Over Time
- Analyse changes in healthcare providers’ count within distinct periods.
- Identify any significant increases or decreases in provider numbers.

### Resource Allocation Recommendations
- From the calculation, suggest specialty areas where more health care workers are required.
- Offer recommendations concerning the identified disparities in accesing health care service.


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
Following my analysis, I identified that a number of rural and underserved urban areas have acute shortages primary care providers especially nurse practitioners and physician assistants. Lower ratios of primary care providers to population in regions such as the Midwest and certain Southern states underscore possible targets for policy intervention or resource distribution.

These findings can inform policymakers and healthcare organizations about how to tailor interventions that improve recruitment efforts in underserved regions, resulting in better primary care access and quality.

___
