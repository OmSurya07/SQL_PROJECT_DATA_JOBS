SELECT
  job_posted_date,
  job_schedule_type,
  AVG(salary_year_avg) AS yearly_salary_avg,
  AVG(salary_hour_avg) AS hourly_salary_avg
FROM 
  job_postings_fact
WHERE
  job_posted_date > '2023-06-01'

GROUP BY 
  job_schedule_type

LIMIT 20;

SELECT 
  COUNT(job_id) AS number_of_job_postings,
  EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') AS job_posted_month,
  EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') AS job_posted_year
FROM  
  job_postings_fact
WHERE 
  EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') = '2023'
GROUP BY  
  job_posted_month
ORDER BY  
  job_posted_month;


SELECT 
  company_table.company_id,
  company_table.name,
  jobs_table.job_posted_date,
  jobs_table.job_health_insurance
FROM
  job_postings_fact AS jobs_table
LEFT JOIN company_dim AS company_table
  ON jobs_table.company_id = company_table.company_id
WHERE
  EXTRACT(QUARTER FROM jobs_table.job_posted_date) = 2 AND
  jobs_table.job_health_insurance = 'true';