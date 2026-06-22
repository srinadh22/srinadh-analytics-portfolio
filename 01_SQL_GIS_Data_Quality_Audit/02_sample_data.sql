-- ============================================================
-- PROJECT: GIS Data Quality Audit
-- File   : Sample Data — 500+ POI records
-- ============================================================

USE gis_data_quality;

-- ── REGIONS ──────────────────────────────────────────────
INSERT INTO regions (region_name, country) VALUES
('North India',   'India'),
('South India',   'India'),
('West India',    'India'),
('East India',    'India'),
('Central India', 'India'),
('North US',      'USA'),
('South US',      'USA'),
('West US',       'USA'),
('East US',       'USA'),
('UK South',      'UK');

-- ── ERROR TYPES ───────────────────────────────────────────
INSERT INTO error_types (error_code, error_desc, severity) VALUES
('ERR_001', 'Missing POI Name',               'Critical'),
('ERR_002', 'Missing or Invalid Coordinates', 'Critical'),
('ERR_003', 'Duplicate Entry',                'High'),
('ERR_004', 'Missing Address',                'High'),
('ERR_005', 'Invalid Phone Format',           'Medium'),
('ERR_006', 'Missing Category',               'Medium'),
('ERR_007', 'Outdated Data (>365 days)',       'Low'),
('ERR_008', 'Missing Website',                'Low'),
('ERR_009', 'Low Quality Score (<60)',        'High'),
('ERR_010', 'Inactive POI Still Listed',      'Medium');

-- ── POI DATA — 500 records ────────────────────────────────
INSERT INTO poi_data
  (poi_name, poi_category, latitude, longitude, address, city, region_id, country,
   phone, website, data_source, quality_score, status, created_date, last_updated, analyst_id)
VALUES
-- South India — Hyderabad (region 2)
('Charminar',              'Landmark',     17.360589, 78.473892, 'Charminar Rd, Hyderabad',       'Hyderabad', 2, 'India', '+914023458888', 'www.charminar.com',         'FieldSurvey',  95.0, 'Active',    '2024-01-10', '2025-01-15', 1),
('Golconda Fort',          'Landmark',     17.383047, 78.401493, 'Golconda, Hyderabad',           'Hyderabad', 2, 'India', '+914023456789', 'www.golconda.gov.in',       'Official',     92.5, 'Active',    '2024-01-12', '2025-02-10', 1),
('HITECH City Metro',      'Transit',      17.445454, 78.369141, 'HITECH City, Hyderabad',       'Hyderabad', 2, 'India', '+914040404040', NULL,                        'FieldSurvey',  88.0, 'Active',    '2024-02-01', '2025-03-01', 2),
('Hussain Sagar Lake',     'Park',         17.425000, 78.474000, 'Tank Bund Rd, Hyderabad',      'Hyderabad', 2, 'India', NULL,            'www.hussainsagar.com',      'Crowdsource',  75.0, 'Active',    '2024-01-20', '2025-01-20', 2),
('Lumbini Park',           'Park',         17.419700, 78.472100, 'Necklace Rd, Hyderabad',       'Hyderabad', 2, 'India', '+914023230002', NULL,                        'FieldSurvey',  82.0, 'Active',    '2024-03-01', '2025-03-15', 3),
('Paradise Biryani',       'Restaurant',   17.431500, 78.457800, 'Paradise Circle, Hyderabad',   'Hyderabad', 2, 'India', '+914027840000', 'www.paradisebiryani.com',   'Official',     91.0, 'Active',    '2024-01-05', '2025-04-01', 1),
('Apollo Hospital Jubilee','Hospital',     17.432700, 78.415600, 'Jubilee Hills, Hyderabad',     'Hyderabad', 2, 'India', '+914023607777', 'www.apollohospitals.com',   'Official',     97.0, 'Active',    '2024-01-08', '2025-05-01', 2),
('Inorbit Mall',           'Shopping Mall',17.432300, 78.380900, 'HITEC City, Hyderabad',        'Hyderabad', 2, 'India', '+914044346500', 'www.inorbitmall.com',       'Official',     89.0, 'Active',    '2024-02-15', '2025-02-20', 3),
('Birla Mandir',           'Temple',       17.408400, 78.467200, 'Naubat Pahad, Hyderabad',      'Hyderabad', 2, 'India', NULL,            NULL,                        'Crowdsource',  65.0, 'Active',    '2024-04-01', '2025-01-05', 1),
('Secunderabad Rly Stn',   'Transit',      17.437700, 78.499200, 'SP Rd, Secunderabad',          'Hyderabad', 2, 'India', '+914027703305', 'www.indianrail.gov.in',     'Official',     93.0, 'Active',    '2024-01-15', '2025-04-10', 2),
-- Duplicates (intentional for audit)
('Charminar',              'Landmark',     17.360589, 78.473892, 'Charminar Rd, Hyderabad',      'Hyderabad', 2, 'India', '+914023458888', 'www.charminar.com',         'Crowdsource',  90.0, 'Duplicate', '2024-06-10', '2025-01-15', 3),
('Paradise Biryani',       'Restaurant',   17.431500, 78.457800, 'Paradise Circle, Hyderabad',   'Hyderabad', 2, 'India', '+914027840000', 'www.paradisebiryani.com',   'Crowdsource',  85.0, 'Duplicate', '2024-07-01', '2025-04-01', 1),
-- Missing data (intentional)
(NULL,                     'Hospital',     17.450000, 78.380000, '123 HITEC City Rd, Hyderabad', 'Hyderabad', 2, 'India', '+914012345678', NULL,                        'FieldSurvey',  55.0, 'Error',     '2024-05-01', '2025-01-01', 2),
('Unnamed Fuel Station',   NULL,           17.410000, 78.490000, NULL,                           'Hyderabad', 2, 'India', NULL,            NULL,                        'Crowdsource',  42.0, 'Error',     '2024-05-15', '2025-01-10', 3),
-- North India — Delhi (region 1)
('Red Fort',               'Landmark',     28.656159, 77.241357, 'Netaji Subhash Marg, Delhi',   'Delhi',     1, 'India', '+911123277705', 'www.redfort.gov.in',        'Official',     96.0, 'Active',    '2024-01-10', '2025-02-01', 4),
('India Gate',             'Landmark',     28.612912, 77.229512, 'Kartavya Path, Delhi',         'Delhi',     1, 'India', NULL,            NULL,                        'Official',     88.0, 'Active',    '2024-01-12', '2025-02-15', 4),
('Indira Gandhi Airport',  'Airport',      28.556160, 77.100281, 'NH 8, New Delhi',              'Delhi',     1, 'India', '+911124337000', 'www.newdelhiairport.in',    'Official',     99.0, 'Active',    '2024-01-01', '2025-05-01', 5),
('Lotus Temple',           'Temple',       28.553492, 77.258942, 'Bahapur, New Delhi',           'Delhi',     1, 'India', '+911126444029', 'www.bahai.in',              'Official',     94.0, 'Active',    '2024-02-01', '2025-03-01', 4),
('Connaught Place',        'Shopping Area',28.632725, 77.219756, 'Rajiv Chowk, Delhi',           'Delhi',     1, 'India', NULL,            NULL,                        'Crowdsource',  72.0, 'Active',    '2024-03-01', '2025-01-20', 5),
('Qutub Minar',            'Landmark',     28.524428, 77.185371, 'Seth Sarai, Mehrauli, Delhi',  'Delhi',     1, 'India', '+911124354812', 'www.qutubminar.gov.in',     'Official',     95.0, 'Active',    '2024-01-15', '2025-04-01', 4),
-- West India — Mumbai (region 3)
('Gateway of India',       'Landmark',     18.921984, 72.834654, 'Apollo Bunder, Mumbai',        'Mumbai',    3, 'India', NULL,            'www.gatewayofindia.com',    'Official',     91.0, 'Active',    '2024-01-10', '2025-03-01', 6),
('Chhatrapati Shivaji Stn','Transit',      18.940304, 72.835526, 'Bori Bunder, Mumbai',          'Mumbai',    3, 'India', '+912222626565', 'www.indianrail.gov.in',     'Official',     97.0, 'Active',    '2024-01-05', '2025-05-01', 6),
('Bandra-Worli Sea Link',  'Landmark',     19.021534, 72.817146, 'Bandra, Mumbai',               'Mumbai',    3, 'India', NULL,            NULL,                        'FieldSurvey',  84.0, 'Active',    '2024-02-01', '2025-02-20', 7),
('Juhu Beach',             'Beach',        19.098000, 72.826800, 'Juhu, Mumbai',                 'Mumbai',    3, 'India', NULL,            NULL,                        'Crowdsource',  68.0, 'Active',    '2024-03-10', '2025-01-15', 7),
('Phoenix Palladium Mall', 'Shopping Mall',18.993400, 72.821900, 'Lower Parel, Mumbai',          'Mumbai',    3, 'India', '+912243509999', 'www.phoenixmall.com',       'Official',     93.0, 'Active',    '2024-01-20', '2025-04-01', 6),
-- East India (region 4)
('Howrah Bridge',          'Landmark',     22.585278, 88.346944, 'Howrah, Kolkata',              'Kolkata',   4, 'India', NULL,            NULL,                        'Official',     89.0, 'Active',    '2024-01-10', '2025-02-01', 8),
('Victoria Memorial',      'Landmark',     22.544727, 88.342898, 'Victoria Memorial Hall, Kolkata','Kolkata', 4, 'India', '+913322231889', 'www.victoriamemorial-cal.org','Official',   96.0, 'Active',    '2024-01-15', '2025-03-01', 8),
('Kolkata Airport',        'Airport',      22.652775, 88.446745, 'Dum Dum, Kolkata',             'Kolkata',   4, 'India', '+913325118787', 'www.aai.aero',              'Official',     94.0, 'Active',    '2024-01-01', '2025-05-01', 9),
('Science City Kolkata',   'Attraction',   22.513600, 88.396300, 'JBS Haldane Ave, Kolkata',     'Kolkata',   4, 'India', '+913322856364', 'www.sciencecitykolkata.org','Official',    91.0, 'Active',    '2024-02-01', '2025-04-01', 8),
-- Central India (region 5)
('Sanchi Stupa',           'Landmark',     23.479444, 77.739444, 'Sanchi, Madhya Pradesh',       'Sanchi',    5, 'India', NULL,            'www.sanchimemorial.com',    'Official',     88.0, 'Active',    '2024-03-01', '2025-01-20', 9),
-- USA Records (regions 6-9)
('Times Square',           'Landmark',     40.758896,-73.985130, '1560 Broadway, New York',      'New York',  9, 'USA',   '+12127687255',  'www.timessquarenyc.org',   'Official',     98.0, 'Active',    '2024-01-10', '2025-05-01', 10),
('Central Park',           'Park',         40.785091,-73.968285, 'New York, NY 10024',           'New York',  9, 'USA',   '+12123106600',  'www.centralparknyc.org',   'Official',     97.0, 'Active',    '2024-01-12', '2025-04-01', 10),
('JFK Airport',            'Airport',      40.641766,-73.780968, 'Queens, NY 11430',             'New York',  9, 'USA',   '+18003978683',  'www.jfkairport.com',        'Official',     99.0, 'Active',    '2024-01-01', '2025-05-01', 10),
('Hollywood Walk of Fame', 'Landmark',     34.101557,-118.326843,'Hollywood Blvd, Los Angeles',  'Los Angeles',8,'USA',  '+12136272000',  'www.walkoffame.com',        'Official',     95.0, 'Active',    '2024-02-01', '2025-04-01', 10),
('Golden Gate Bridge',     'Landmark',     37.819929,-122.478255,'Golden Gate Bridge, SF',       'San Francisco',8,'USA','+14155215858', 'www.goldengate.org',        'Official',     98.0, 'Active',    '2024-01-15', '2025-05-01', 10),
-- UK Records (region 10)
('Big Ben',                'Landmark',     51.500729, -0.124625, 'Westminster, London SW1A 0AA', 'London',   10, 'UK',   '+442072194272', 'www.parliament.uk',         'Official',     97.0, 'Active',    '2024-01-10', '2025-04-01', 10),
('Heathrow Airport',       'Airport',      51.477500, -0.461389, 'Longford, London TW6 1EW',    'London',   10, 'UK',   '+443448351801', 'www.heathrow.com',          'Official',     99.0, 'Active',    '2024-01-01', '2025-05-01', 10),
('British Museum',         'Attraction',   51.519400, -0.126900, 'Great Russell St, London',    'London',   10, 'UK',   '+442073238299', 'www.britishmuseum.org',     'Official',     96.0, 'Active',    '2024-02-01', '2025-03-01', 10),
-- More India records across cities
('Mysore Palace',          'Landmark',     12.305199, 76.655380, 'Sayyaji Rao Rd, Mysuru',       'Mysuru',    2, 'India', '+918212423458', 'www.mysorepalace.gov.in',   'Official',     94.0, 'Active',    '2024-01-10', '2025-03-01', 1),
('Bangalore Airport',      'Airport',      13.198889, 77.706111, 'Devanahalli, Bengaluru',       'Bengaluru', 2, 'India', '+918066782222', 'www.bengaluruairport.com',  'Official',     98.0, 'Active',    '2024-01-01', '2025-05-01', 2),
('UB City Mall',           'Shopping Mall',12.971100, 77.596200, 'Vittal Mallya Rd, Bengaluru',  'Bengaluru', 2, 'India', '+918022112323', 'www.ubcitymall.com',        'Official',     90.0, 'Active',    '2024-02-01', '2025-04-01', 3),
('Cubbon Park',            'Park',         12.976837, 77.592789, 'Kasturba Rd, Bengaluru',       'Bengaluru', 2, 'India', NULL,            NULL,                        'FieldSurvey',  76.0, 'Active',    '2024-03-01', '2025-02-01', 1),
('Lal Bagh Botanical',     'Park',         12.950369, 77.584901, 'Lal Bagh, Bengaluru',          'Bengaluru', 2, 'India', '+918022105757', 'www.lalbagh.org',           'Official',     88.0, 'Active',    '2024-02-15', '2025-03-15', 2),
('Chennai Central Rly',    'Transit',      13.082680, 80.275498, 'Park Town, Chennai',           'Chennai',   2, 'India', '+914425354990', 'www.indianrail.gov.in',     'Official',     93.0, 'Active',    '2024-01-10', '2025-04-01', 3),
('Marina Beach',           'Beach',        13.050900, 80.282200, 'Beach Rd, Chennai',            'Chennai',   2, 'India', NULL,            NULL,                        'Crowdsource',  70.0, 'Active',    '2024-03-01', '2025-01-10', 1),
('Kapaleeshwarar Temple',  'Temple',       13.033389, 80.269667, 'Mylapore, Chennai',            'Chennai',   2, 'India', '+914424641670', NULL,                        'Official',     85.0, 'Active',    '2024-02-01', '2025-02-01', 2),
-- More errors and low quality records for audit realism
('Old Petrol Bunk',        'Fuel Station', 17.390000, 78.480000, NULL,                           'Hyderabad', 2, 'India', NULL,            NULL,                        'Crowdsource',  38.0, 'Inactive',  '2023-01-01', '2023-06-01', 3),
('Closed Restaurant XYZ',  'Restaurant',   17.420000, 78.460000, 'Some Rd, Hyderabad',           'Hyderabad', 2, 'India', '12345',         NULL,                        'Crowdsource',  45.0, 'Inactive',  '2022-05-01', '2023-01-01', 1),
(NULL,                     NULL,           NULL,       NULL,      NULL,                           'Delhi',     1, 'India', NULL,            NULL,                        'Crowdsource',  10.0, 'Error',     '2024-08-01', '2025-01-01', 4),
('Test Record',            'Unknown',      0.000000,  0.000000,  'Test Address',                 'Unknown',   1, 'India', NULL,            NULL,                        'System',        5.0, 'Error',     '2024-09-01', '2025-01-01', 5),
('Duplicate Hospital',     'Hospital',     17.432700, 78.415600, 'Jubilee Hills, Hyderabad',     'Hyderabad', 2, 'India', '+914023607777', 'www.apollohospitals.com',   'Crowdsource',  80.0, 'Duplicate', '2024-10-01', '2025-03-01', 2);

-- Generate more records for 500+ using a stored procedure approach
DELIMITER $$
CREATE PROCEDURE GeneratePOIData()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cats VARCHAR(200);
  DECLARE cities VARCHAR(500);
  DECLARE statuses VARCHAR(100);
  
  WHILE i <= 450 DO
    INSERT INTO poi_data (
      poi_name, poi_category, latitude, longitude, address, city,
      region_id, country, phone, data_source, quality_score,
      status, created_date, last_updated, analyst_id
    ) VALUES (
      CONCAT('POI_', LPAD(i, 4, '0'), '_', ELT(1+MOD(i,8),'Restaurant','Hotel','Hospital','School','Park','Temple','Transit','Mall')),
      ELT(1+MOD(i,8), 'Restaurant','Hotel','Hospital','School','Park','Temple','Transit','Shopping Mall'),
      ROUND(12.0 + (RAND() * 18), 6),
      ROUND(72.0 + (RAND() * 20), 6),
      CASE WHEN MOD(i,7) = 0 THEN NULL
           ELSE CONCAT(i, ' Main Road, Area ', MOD(i,10)) END,
      ELT(1+MOD(i,6), 'Hyderabad','Delhi','Mumbai','Kolkata','Chennai','Bengaluru'),
      1 + MOD(i, 5),
      'India',
      CASE WHEN MOD(i,5) = 0 THEN NULL
           ELSE CONCAT('+9190', LPAD(FLOOR(RAND()*9000000+1000000), 7, '0')) END,
      ELT(1+MOD(i,3), 'FieldSurvey','Crowdsource','Official'),
      ROUND(30 + (RAND() * 70), 1),
      ELT(1+MOD(i,5), 'Active','Active','Active','Inactive','Error'),
      DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*730) DAY),
      DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
      1 + MOD(i, 10)
    );
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

CALL GeneratePOIData();
DROP PROCEDURE IF EXISTS GeneratePOIData;

-- ── AUDIT LOG ENTRIES ─────────────────────────────────────
INSERT INTO poi_audit_log (poi_id, error_id, flagged_date, resolved_date, resolved_by, remarks) VALUES
(11, 3, '2025-01-16', '2025-01-20', 1, 'Confirmed duplicate of POI ID 1 — removed from active'),
(12, 3, '2025-04-02', '2025-04-05', 2, 'Confirmed duplicate of POI ID 6'),
(13, 1, '2025-01-02', NULL,         2, 'POI name missing — awaiting field verification'),
(14, 6, '2025-01-11', NULL,         3, 'Category and address missing — crowdsource record'),
(51, 9, '2024-06-02', '2024-06-15', 1, 'Low quality score resolved after field visit'),
(52, 5, '2024-01-02', '2024-02-01', 1, 'Invalid phone corrected'),
(53, 1, '2024-09-02', NULL,         4, 'Completely blank record — to be deleted'),
(54, 2, '2024-09-02', NULL,         5, 'Zero coordinates — test/system record'),
(55, 3, '2025-03-02', '2025-03-10', 2, 'Duplicate of Apollo Hospital — resolved');
