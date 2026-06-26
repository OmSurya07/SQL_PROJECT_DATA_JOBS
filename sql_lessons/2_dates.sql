/*
SELECT 
  '2023-02-19'::DATE,
  '123'::INT,
  'true'::BOOLEAN,
  '3.14'::REAL;
*/

-- REMOVE TIMESTAMP FROM DATE COLUMN

SELECT 
  job_title_short AS title,
  job_location AS location,
  job_posted_date::DATE AS date
FROM 
  job_postings_fact
LIMIT 10;

SELECT 
  job_title_short AS title,
  job_location AS location,
  job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' AS date_time,
  EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM 
  job_postings_fact
LIMIT 10;



