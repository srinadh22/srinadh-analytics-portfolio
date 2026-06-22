-- ============================================================
-- PROJECT : GIS Data Quality Audit — SQL Analytics
-- Author  : Srinadh Upputholla
-- Tool    : MySQL
-- Desc    : 10 real-world data quality audit queries
--           Based on actual GIS operations experience
--           across enterprise mapping programmes
-- ============================================================

USE gis_data_quality;

-- ============================================================
-- QUERY 1: Overall Data Quality Summary Dashboard
-- Business Use: Executive KPI report — first thing leadership
--               sees every Monday morning
-- ============================================================

SELECT
    COUNT(*)                                                        AS total_pois,
    SUM(CASE WHEN status = 'Active'    THEN 1 ELSE 0 END)          AS active_pois,
    SUM(CASE WHEN status = 'Inactive'  THEN 1 ELSE 0 END)          AS inactive_pois,
    SUM(CASE WHEN status = 'Duplicate' THEN 1 ELSE 0 END)          AS duplicate_pois,
    SUM(CASE WHEN status = 'Error'     THEN 1 ELSE 0 END)          AS error_pois,
    SUM(CASE WHEN status = 'Pending'   THEN 1 ELSE 0 END)          AS pending_pois,
    ROUND(AVG(quality_score), 2)                                    AS avg_quality_score,
    SUM(CASE WHEN quality_score >= 80  THEN 1 ELSE 0 END)          AS high_quality_count,
    SUM(CASE WHEN quality_score < 60   THEN 1 ELSE 0 END)          AS low_quality_count,
    ROUND(
        SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS active_percentage,
    ROUND(
        SUM(CASE WHEN quality_score >= 80 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS quality_pass_rate
FROM poi_data;


-- ============================================================
-- QUERY 2: Quality Score by Region — Regional Performance
-- Business Use: Identify which regions need more field ops
--               attention or analyst resource allocation
-- ============================================================

SELECT
    r.region_name,
    r.country,
    COUNT(p.poi_id)                                                 AS total_pois,
    ROUND(AVG(p.quality_score), 2)                                  AS avg_quality_score,
    MIN(p.quality_score)                                            AS min_score,
    MAX(p.quality_score)                                            AS max_score,
    SUM(CASE WHEN p.quality_score >= 80 THEN 1 ELSE 0 END)         AS passed_qa,
    SUM(CASE WHEN p.quality_score < 60  THEN 1 ELSE 0 END)         AS failed_qa,
    ROUND(
        SUM(CASE WHEN p.quality_score >= 80 THEN 1 ELSE 0 END) * 100.0
        / COUNT(p.poi_id), 2
    )                                                               AS qa_pass_rate_pct,
    RANK() OVER (ORDER BY AVG(p.quality_score) DESC)                AS quality_rank
FROM poi_data p
JOIN regions r ON p.region_id = r.region_id
GROUP BY r.region_id, r.region_name, r.country
ORDER BY avg_quality_score DESC;


-- ============================================================
-- QUERY 3: Missing Data Audit — Field-Level Null Check
-- Business Use: Data completeness check — critical for SLA
--               compliance reporting and field team tasking
-- ============================================================

SELECT
    COUNT(*)                                                        AS total_records,
    SUM(CASE WHEN poi_name     IS NULL THEN 1 ELSE 0 END)          AS missing_name,
    SUM(CASE WHEN latitude     IS NULL THEN 1 ELSE 0 END)          AS missing_latitude,
    SUM(CASE WHEN longitude    IS NULL THEN 1 ELSE 0 END)          AS missing_longitude,
    SUM(CASE WHEN address      IS NULL THEN 1 ELSE 0 END)          AS missing_address,
    SUM(CASE WHEN phone        IS NULL THEN 1 ELSE 0 END)          AS missing_phone,
    SUM(CASE WHEN website      IS NULL THEN 1 ELSE 0 END)          AS missing_website,
    SUM(CASE WHEN poi_category IS NULL THEN 1 ELSE 0 END)          AS missing_category,
    -- Percentage of each field missing
    ROUND(SUM(CASE WHEN poi_name  IS NULL THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS pct_missing_name,
    ROUND(SUM(CASE WHEN address   IS NULL THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS pct_missing_address,
    ROUND(SUM(CASE WHEN phone     IS NULL THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2) AS pct_missing_phone
FROM poi_data;


-- ============================================================
-- QUERY 4: Duplicate Detection using Window Functions
-- Business Use: Find exact and near-duplicate POIs based on
--               same name + same coordinates — critical for
--               map accuracy (duplicate pins on map = bad UX)
-- ============================================================

WITH DuplicateCheck AS (
    SELECT
        poi_id,
        poi_name,
        latitude,
        longitude,
        city,
        status,
        quality_score,
        COUNT(*) OVER (
            PARTITION BY poi_name, ROUND(latitude,4), ROUND(longitude,4)
        )                                                           AS duplicate_count,
        ROW_NUMBER() OVER (
            PARTITION BY poi_name, ROUND(latitude,4), ROUND(longitude,4)
            ORDER BY quality_score DESC
        )                                                           AS row_rank
    FROM poi_data
    WHERE poi_name IS NOT NULL
)
SELECT
    poi_id,
    poi_name,
    latitude,
    longitude,
    city,
    status,
    quality_score,
    duplicate_count,
    CASE WHEN row_rank = 1 THEN 'KEEP'
         ELSE 'REMOVE — DUPLICATE'
    END                                                             AS recommendation
FROM DuplicateCheck
WHERE duplicate_count > 1
ORDER BY poi_name, row_rank;


-- ============================================================
-- QUERY 5: SLA Compliance Report — Data Freshness Check
-- Business Use: Check which POIs haven't been updated in
--               365+ days — SLA breach for freshness standard
-- ============================================================

SELECT
    r.region_name,
    p.city,
    p.poi_category,
    COUNT(p.poi_id)                                                 AS total_pois,
    SUM(CASE WHEN DATEDIFF(CURDATE(), p.last_updated) > 365
             THEN 1 ELSE 0 END)                                     AS overdue_update,
    SUM(CASE WHEN DATEDIFF(CURDATE(), p.last_updated) <= 365
             THEN 1 ELSE 0 END)                                     AS within_sla,
    ROUND(
        SUM(CASE WHEN DATEDIFF(CURDATE(), p.last_updated) <= 365
                 THEN 1 ELSE 0 END) * 100.0
        / COUNT(p.poi_id), 2
    )                                                               AS sla_compliance_pct,
    MAX(DATEDIFF(CURDATE(), p.last_updated))                        AS max_days_since_update,
    ROUND(AVG(DATEDIFF(CURDATE(), p.last_updated)), 0)              AS avg_days_since_update
FROM poi_data p
JOIN regions r ON p.region_id = r.region_id
WHERE p.status = 'Active'
GROUP BY r.region_name, p.city, p.poi_category
ORDER BY sla_compliance_pct ASC;


-- ============================================================
-- QUERY 6: Analyst Performance Report
-- Business Use: Measure each analyst's output, quality score,
--               and error rate — used in performance reviews
-- ============================================================

SELECT
    p.analyst_id,
    COUNT(p.poi_id)                                                 AS total_pois_handled,
    ROUND(AVG(p.quality_score), 2)                                  AS avg_quality_score,
    SUM(CASE WHEN p.status = 'Active'    THEN 1 ELSE 0 END)        AS active_count,
    SUM(CASE WHEN p.status = 'Error'     THEN 1 ELSE 0 END)        AS error_count,
    SUM(CASE WHEN p.status = 'Duplicate' THEN 1 ELSE 0 END)        AS duplicate_count,
    ROUND(
        SUM(CASE WHEN p.status = 'Error' THEN 1 ELSE 0 END) * 100.0
        / COUNT(p.poi_id), 2
    )                                                               AS error_rate_pct,
    ROUND(
        SUM(CASE WHEN p.quality_score >= 80 THEN 1 ELSE 0 END) * 100.0
        / COUNT(p.poi_id), 2
    )                                                               AS quality_pass_rate_pct,
    DENSE_RANK() OVER (ORDER BY AVG(p.quality_score) DESC)          AS performance_rank
FROM poi_data p
GROUP BY p.analyst_id
ORDER BY avg_quality_score DESC;


-- ============================================================
-- QUERY 7: Category-wise Data Quality Breakdown
-- Business Use: Which POI categories have worst data quality?
--               Helps prioritise which layer needs more ops work
-- ============================================================

SELECT
    poi_category,
    COUNT(*)                                                        AS total_count,
    ROUND(AVG(quality_score), 2)                                    AS avg_quality,
    SUM(CASE WHEN quality_score >= 90 THEN 1 ELSE 0 END)           AS excellent,
    SUM(CASE WHEN quality_score BETWEEN 75 AND 89 THEN 1 ELSE 0 END) AS good,
    SUM(CASE WHEN quality_score BETWEEN 60 AND 74 THEN 1 ELSE 0 END) AS average,
    SUM(CASE WHEN quality_score < 60  THEN 1 ELSE 0 END)           AS poor,
    SUM(CASE WHEN address  IS NULL    THEN 1 ELSE 0 END)           AS missing_address,
    SUM(CASE WHEN phone    IS NULL    THEN 1 ELSE 0 END)           AS missing_phone,
    ROUND(
        SUM(CASE WHEN quality_score >= 80 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS pass_rate_pct
FROM poi_data
WHERE poi_category IS NOT NULL
GROUP BY poi_category
ORDER BY avg_quality ASC;


-- ============================================================
-- QUERY 8: Monthly Trend Analysis using CTEs
-- Business Use: Month-over-month comparison of POIs created
--               vs quality scores — trend report for leadership
-- ============================================================

WITH MonthlyStats AS (
    SELECT
        DATE_FORMAT(created_date, '%Y-%m')                          AS month_year,
        COUNT(*)                                                     AS pois_created,
        ROUND(AVG(quality_score), 2)                                AS avg_quality,
        SUM(CASE WHEN status = 'Error' THEN 1 ELSE 0 END)          AS errors_created,
        SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END)         AS active_created
    FROM poi_data
    WHERE created_date IS NOT NULL
    GROUP BY DATE_FORMAT(created_date, '%Y-%m')
),
MonthlyWithLag AS (
    SELECT
        month_year,
        pois_created,
        avg_quality,
        errors_created,
        active_created,
        LAG(pois_created)  OVER (ORDER BY month_year)               AS prev_month_count,
        LAG(avg_quality)   OVER (ORDER BY month_year)               AS prev_month_quality
    FROM MonthlyStats
)
SELECT
    month_year,
    pois_created,
    avg_quality,
    errors_created,
    active_created,
    prev_month_count,
    ROUND(
        (pois_created - prev_month_count) * 100.0
        / NULLIF(prev_month_count, 0), 2
    )                                                               AS mom_growth_pct,
    ROUND(avg_quality - prev_month_quality, 2)                      AS quality_change
FROM MonthlyWithLag
ORDER BY month_year DESC
LIMIT 12;


-- ============================================================
-- QUERY 9: Error Pattern Analysis — Top Errors by Region
-- Business Use: Root Cause Analysis (RCA) — which errors are
--               most frequent in which region? Feed into CAPA
-- ============================================================

SELECT
    r.region_name,
    et.error_code,
    et.error_desc,
    et.severity,
    COUNT(al.audit_id)                                              AS error_count,
    SUM(CASE WHEN al.resolved_date IS NOT NULL THEN 1 ELSE 0 END)  AS resolved_count,
    SUM(CASE WHEN al.resolved_date IS NULL     THEN 1 ELSE 0 END)  AS open_count,
    ROUND(
        SUM(CASE WHEN al.resolved_date IS NOT NULL THEN 1 ELSE 0 END) * 100.0
        / COUNT(al.audit_id), 2
    )                                                               AS resolution_rate_pct,
    ROUND(AVG(
        CASE WHEN al.resolved_date IS NOT NULL
             THEN DATEDIFF(al.resolved_date, al.flagged_date)
        END
    ), 1)                                                           AS avg_resolution_days
FROM poi_audit_log al
JOIN poi_data    p  ON al.poi_id   = p.poi_id
JOIN regions     r  ON p.region_id = r.region_id
JOIN error_types et ON al.error_id = et.error_id
GROUP BY r.region_name, et.error_code, et.error_desc, et.severity
ORDER BY error_count DESC, et.severity DESC;


-- ============================================================
-- QUERY 10: Data Source Quality Comparison
-- Business Use: Which data source (FieldSurvey, Crowdsource,
--               Official) delivers best quality? Used to decide
--               source weighting in data operations strategy
-- ============================================================

WITH SourceStats AS (
    SELECT
        data_source,
        COUNT(*)                                                     AS total_pois,
        ROUND(AVG(quality_score), 2)                                AS avg_quality,
        SUM(CASE WHEN status = 'Error'     THEN 1 ELSE 0 END)      AS error_count,
        SUM(CASE WHEN status = 'Duplicate' THEN 1 ELSE 0 END)      AS duplicate_count,
        SUM(CASE WHEN status = 'Active'    THEN 1 ELSE 0 END)      AS active_count,
        SUM(CASE WHEN quality_score >= 80  THEN 1 ELSE 0 END)      AS high_quality_count,
        SUM(CASE WHEN address  IS NULL     THEN 1 ELSE 0 END)      AS missing_address,
        SUM(CASE WHEN phone    IS NULL     THEN 1 ELSE 0 END)      AS missing_phone
    FROM poi_data
    WHERE data_source IS NOT NULL
    GROUP BY data_source
)
SELECT
    data_source,
    total_pois,
    avg_quality,
    error_count,
    duplicate_count,
    active_count,
    ROUND(error_count     * 100.0 / total_pois, 2)                 AS error_rate_pct,
    ROUND(duplicate_count * 100.0 / total_pois, 2)                 AS duplicate_rate_pct,
    ROUND(high_quality_count * 100.0 / total_pois, 2)              AS quality_pass_rate_pct,
    ROUND(missing_address * 100.0 / total_pois, 2)                 AS missing_address_pct,
    RANK() OVER (ORDER BY avg_quality DESC)                         AS quality_rank,
    CASE
        WHEN avg_quality >= 85 THEN 'Trusted Source'
        WHEN avg_quality >= 70 THEN 'Acceptable Source'
        ELSE                        'Needs Review'
    END                                                             AS source_trust_label
FROM SourceStats
ORDER BY avg_quality DESC;

-- ============================================================
-- END OF QUERIES
-- ============================================================
