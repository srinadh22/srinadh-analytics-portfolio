# GIS Data Quality Audit — SQL Analytics Project

**Author:** Srinadh Upputholla  
**Tool:** MySQL  
**Domain:** GIS / Maps & Navigation Data Operations  
**Level:** Intermediate — Advanced SQL  

---

## Project Overview

This project simulates a **real-world GIS data quality audit** based on 13+ years of experience managing enterprise mapping operations for Apple Maps and Google Maps-equivalent programmes.

The dataset contains **500+ POI (Point of Interest) records** across India, USA, and UK — with intentional data quality issues including duplicates, missing fields, low quality scores, inactive records, and SLA breaches — exactly what a Data Analyst or Data Operations Lead deals with daily.

---

## Business Problem

In large-scale map data operations, poor data quality directly impacts:
- **End-user experience** — wrong pins, duplicate locations, outdated information
- **SLA compliance** — client contracts require minimum quality scores and freshness standards
- **Operational efficiency** — analysts waste time on avoidable errors

This project answers 10 real business questions using SQL.

---

## Database Schema

```
gis_data_quality
├── poi_data        — 500+ POI records (main table)
├── regions         — 10 geographic regions
├── error_types     — 10 error categories with severity
└── poi_audit_log   — error flagging and resolution tracking
```

---

## Files

| File | Description |
|---|---|
| `01_schema.sql` | Database and table creation |
| `02_sample_data.sql` | 500+ POI records + audit log entries |
| `03_queries.sql` | 10 business analytics queries |
| `README.md` | This file |

---

## How to Run

1. Open MySQL Workbench (or any MySQL client)
2. Run `01_schema.sql` first — creates the database and tables
3. Run `02_sample_data.sql` — loads all sample data
4. Run any query from `03_queries.sql` — each query is independent

---

## 10 Queries — Business Use Cases

| # | Query | SQL Concepts Used |
|---|---|---|
| 1 | Overall Data Quality Summary Dashboard | Aggregation, CASE WHEN, calculated KPIs |
| 2 | Quality Score by Region | GROUP BY, RANK() window function, JOIN |
| 3 | Missing Data Audit — Field-Level Null Check | NULL checks, COUNT, percentage calculations |
| 4 | Duplicate Detection | CTE, ROW_NUMBER(), PARTITION BY window function |
| 5 | SLA Compliance — Data Freshness Check | DATEDIFF, GROUP BY, SLA calculation |
| 6 | Analyst Performance Report | Aggregation, DENSE_RANK(), error rate metrics |
| 7 | Category-wise Quality Breakdown | GROUP BY, BETWEEN, multi-level scoring |
| 8 | Monthly Trend Analysis | CTE, LAG() window function, MoM growth |
| 9 | Error Pattern Analysis — RCA | Multi-table JOIN, resolution rate, avg resolution time |
| 10 | Data Source Quality Comparison | CTE, RANK(), trust label classification |

---

## Key SQL Concepts Demonstrated

- **Joins** — INNER JOIN across 4 tables
- **CTEs** — Common Table Expressions for readable multi-step logic
- **Window Functions** — RANK(), DENSE_RANK(), ROW_NUMBER(), LAG(), PARTITION BY
- **Aggregations** — COUNT, SUM, AVG, MIN, MAX with GROUP BY
- **CASE WHEN** — Conditional logic for categorisation and scoring
- **Date Functions** — DATEDIFF, DATE_FORMAT for SLA and trend analysis
- **Subqueries** — Nested logic for complex business questions
- **NULL Handling** — NULLIF, IS NULL checks for data quality validation

---

## Sample Output — Query 1 (Quality Dashboard)

| total_pois | active_pois | duplicate_pois | error_pois | avg_quality | quality_pass_rate |
|---|---|---|---|---|---|
| 504 | 441 | 4 | 8 | 76.4 | 68.2% |

---

## Real-World Context

These exact analytics were performed manually in Excel and ad-hoc reporting tools during my career managing **Apple Maps GIS data operations** across **9+ data layers** with a **30+ member team**.

This project demonstrates how the same operational insights can be delivered faster, at scale, and more accurately using structured SQL — replacing manual Excel-based reporting.

---

## Connect

**LinkedIn:** linkedin.com/in/srinadhupputholla-788390145  
**Email:** srinadh.u123@gmail.com
