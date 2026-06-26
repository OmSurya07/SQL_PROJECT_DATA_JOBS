-- UNION Example

SELECT
  job_title_short,
  company_id,
  job_location
FROM
  jan_jobs

UNION 

SELECT
  job_title_short,
  company_id,
  job_location
FROM
  feb_jobs

UNION

SELECT
  job_title_short,
  company_id,
  job_location
FROM
  mar_jobs

-- Advanced Problem 1

/*
Find job postings from the first quarter that have a salary greater than $70k
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Get job postings with an average yearly salary > 70,000
*/

-- ALSO ADDED SKILLS AND SKILL TYPE FOR EACH JOB POSTING

SELECT
  quarter1_job.job_title_short,
  quarter1_job.job_location,
  quarter1_job.job_via,
  quarter1_job.job_posted_date::DATE,
  quarter1_job.salary_year_avg,
  skills_dim.skills,
  skills_dim.type
FROM (
  SELECT *
  FROM jan_jobs

  UNION ALL

  SELECT *
  FROM feb_jobs

  UNION ALL

  SELECT *
  FROM mar_jobs
) AS quarter1_job

LEFT JOIN skills_job_dim
  ON quarter1_job.job_id = skills_job_dim.job_id

LEFT JOIN skills_dim
  ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE 
  salary_year_avg > 70000
ORDER BY
  salary_year_avg DESC
LIMIT 10;











