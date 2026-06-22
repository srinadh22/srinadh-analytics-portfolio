-- ============================================================
-- PROJECT: GIS Data Quality Audit — SQL Analytics
-- Author : Srinadh Upputholla
-- Tool   : MySQL
-- Desc   : Schema for POI (Point of Interest) dataset
--          simulating real-world Apple/Google Maps data ops
-- ============================================================

CREATE DATABASE IF NOT EXISTS gis_data_quality;
USE gis_data_quality;

-- Drop if exists (for clean re-runs)
DROP TABLE IF EXISTS poi_audit_log;
DROP TABLE IF EXISTS poi_data;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS error_types;

-- ── REGIONS ──────────────────────────────────────────────
CREATE TABLE regions (
    region_id   INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(50) NOT NULL,
    country     VARCHAR(50) NOT NULL
);

-- ── ERROR TYPES ───────────────────────────────────────────
CREATE TABLE error_types (
    error_id    INT PRIMARY KEY AUTO_INCREMENT,
    error_code  VARCHAR(20) NOT NULL,
    error_desc  VARCHAR(100) NOT NULL,
    severity    ENUM('Low','Medium','High','Critical') NOT NULL
);

-- ── MAIN POI DATA TABLE ───────────────────────────────────
CREATE TABLE poi_data (
    poi_id          INT PRIMARY KEY AUTO_INCREMENT,
    poi_name        VARCHAR(150),
    poi_category    VARCHAR(50),
    latitude        DECIMAL(9,6),
    longitude       DECIMAL(9,6),
    address         VARCHAR(200),
    city            VARCHAR(80),
    region_id       INT,
    country         VARCHAR(50),
    phone           VARCHAR(20),
    website         VARCHAR(150),
    data_source     VARCHAR(50),
    quality_score   DECIMAL(4,1),
    status          ENUM('Active','Inactive','Pending','Duplicate','Error') DEFAULT 'Pending',
    created_date    DATE,
    last_updated    DATE,
    analyst_id      INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- ── AUDIT LOG ─────────────────────────────────────────────
CREATE TABLE poi_audit_log (
    audit_id        INT PRIMARY KEY AUTO_INCREMENT,
    poi_id          INT,
    error_id        INT,
    flagged_date    DATE,
    resolved_date   DATE,
    resolved_by     INT,
    remarks         VARCHAR(200),
    FOREIGN KEY (poi_id)   REFERENCES poi_data(poi_id),
    FOREIGN KEY (error_id) REFERENCES error_types(error_id)
);
