/* 

CREATE TABLES FROM OTHER TABLES

- Create Three tables:
  1. Jan 2023 jobs
  2. Feb 2023 Jobs
  3. Mar 2023 jobs

*/

-- JAN
CREATE TABLE Jan_jobs AS
  SELECT * 
  FROM 
    job_postings_fact
  WHERE 
    EXTRACT(MONTH FROM job_posted_date) = 1;

-- FEB
CREATE TABLE feb_jobs AS
  SELECT * 
  FROM 
    job_postings_fact
  WHERE 
    EXTRACT(MONTH FROM job_posted_date) = 2;

-- MAR
CREATE TABLE mar_jobs AS
  SELECT * 
  FROM 
    job_postings_fact
  WHERE 
    EXTRACT(MONTH FROM job_posted_date) = 3;


-- Subquery
SELECT * 
FROM ( 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;


-- CTE
WITH january_jos AS ( 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT * 
FROM january_jobs;
