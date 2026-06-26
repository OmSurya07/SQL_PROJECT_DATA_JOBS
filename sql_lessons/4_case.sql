/*
Label new columns as follows:
  - 'Anywhere' jobs as 'Remote'
  - 'New York, NY'  jobs as 'Local'
  - Otherwise 'Onsite'
*/


SELECT 
  COUNT(job_id) AS num_of_jobs,
  CASE 
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
  END AS location_category
FROM
  job_postings_fact
WHERE 
  job_title_short = 'Data Analyst'
GROUP BY 
  location_category;


-- Practice Problem

--MAX: 960000, MIN: 15000

SELECT 
  job_title_short,
  salary_year_avg,
  CASE 
    WHEN salary_year_avg > 960000 THEN 'High'
    WHEN salary_year_avg > 250000 THEN 'Standard'
    WHEN salary_year_avg > 15000 THEN 'Low'
    ELSE 'Very Low'
  END AS salary_buckets
FROM 
  job_postings_fact
WHERE 
  job_title_short = 'Data Analyst';


SELECT 
  *
FROM 
  job_postings_fact
LIMIT 10;