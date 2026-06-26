--Subquery

SELECT 
  name as company_name
FROM 
  company_dim
WHERE 
  company_id IN (
    SELECT 
      company_id
    FROM 
      job_postings_fact
    WHERE
      job_no_degree_mention = true
  );


-- CTE

/*
Find the companies that have the most job openings.
-- Get the total number of job postings per company id (job_posting_fact)
-- Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_count AS ( 
  SELECT 
    company_id,
    COUNT(*) AS total_number_of_postings
  FROM 
    job_postings_fact
  GROUP BY 
    company_id
)

SELECT 
  company_dim.name,
  company_job_count.company_id,
  company_job_count.total_number_of_postings
FROM 
  company_dim
LEFT JOIN company_job_count
  ON company_dim.company_id = company_job_count.company_id
ORDER BY
  total_number_of_postings DESC;


-- Practice Poblem

1

SELECT
  skill_id,
  skills
FROM
  skills_dim

SELECT * 
FROM skills_job_dim
LIMIT 10;

SELECT
  job_id,
  job_title_short
FROM
  job_postings_fact
ORDER BY
  job_id
LIMIT 10;


WITH frequent_skills AS (
  SELECT
    skill_id,
    COUNT(job_id) AS total_jobs_requiring_this_skill
  FROM
    skills_job_dim
  GROUP BY
    skill_id
  ORDER BY
    total_jobs_requiring_this_skill DESC
  LIMIT 5
)

SELECT 
  skills_dim.skills,
  frequent_skills.skill_id,
  frequent_skills.total_jobs_requiring_this_skill
FROM
  frequent_skills
LEFT JOIN skills_dim
  ON frequent_skills.skill_id = skills_dim.skill_id


SELECT * 
FROM frequent_skills


-- 2

SELECT
  total_postings,
  CASE 
    WHEN total_postings < 10 THEN 'SMALL'
    WHEN total_postings BETWEEN 10 AND 50 THEN 'MEDIUM'
    ELSE 'LARGE'
  END AS company_size
FROM (
  SELECT
    company_id,
    COUNT(job_id) AS total_postings
  FROM
    job_postings_fact
  GROUP BY
    company_id
  ORDER BY
    total_postings DESC
)


-- Advanced Problem

/*
Find the count of the number of remote job postings per skill
  - Display the top 5 skills by their demand in remote jobs
  - Include skill ID, name, and count of postings requiring the skill
*/
WITH remote_job_skills AS (
  SELECT
    skills_job_dim.skill_id,
    COUNT(*) AS skill_count
  FROM
    skills_job_dim
  INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
  WHERE 
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
  GROUP BY 
    skill_id
  ORDER BY skill_count DESC
)

SELECT
  remote_job_skills.skill_id,
  skills_dim.skills,
  remote_job_skills.skill_count
FROM
  remote_job_skills
INNER JOIN skills_dim
  ON remote_job_skills.skill_id = skills_dim.skill_id
ORDER BY skill_count DESC
LIMIT 5;


SELECT * from remote_job_skills;







