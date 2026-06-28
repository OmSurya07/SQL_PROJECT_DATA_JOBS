/*
Identify TOP paying and HIGH in demand skills
*/

WITH skill_demand AS (
  SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS skills_count
  FROM
    job_postings_fact
  INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    --job_postings_fact.job_location = 'United Kingdom' AND
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
  GROUP BY
    skills_dim.skill_id
), avgPay_for_skill AS (
  SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
  FROM
    job_postings_fact
  INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    --job_postings_fact.job_location = 'United Kingdom' AND
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
  GROUP BY
    skills_dim.skill_id
)


SELECT
  skill_demand.skill_id,
  skill_demand.skills,
  skills_count,
  average_salary
FROM
  skill_demand
INNER JOIN avgPay_for_skill
  ON skill_demand.skills = avgPay_for_skill.skills
ORDER BY
  skills_count DESC,
  average_salary DESC
LIMIT 25;
