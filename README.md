# Introduction 

This project focuses on analyzing real-world job posting data to uncover useful insights using SQL 📊.

The analysis explores patterns in salaries, skills, and job requirements to understand how data can help identify trends and make informed decisions 💡.

My SQL Queries: [sql_project](/sql_project/)


# Background
With the growing demand for data-driven decision making, understanding the skills and requirements of the Data Analytics field has become important 📈.

The dataset used in this project contains information about companies, job postings, salaries, and the skills required for different positions from the year 2023. It was borrowed from [SQL_course](https://www.lukebarousse.com/sql)

By analyzing this data, I explored trends in the Data Analyst job market, including salary patterns, commonly required skills, and skills that can lead to better-paying opportunities 💡.

# Tools I Used 
For this project, I used different tools for data analysis, database management, and managing my workflow efficiently.

- SQL: Used to query the dataset, perform analysis, and extract meaningful insights using operations like filtering, joins, grouping, and aggregations.

- PostgreSQL: 
Used as the database system to store and manage the job posting data and execute SQL queries.

- VS Code:
Used as my development environment to write SQL queries and connect with my PostgreSQL database.

- Git & GitHub:
Used for version control, tracking changes, and maintaining the project repository.
# The Analysis

### 1. Top paying Data Analyst Jobs
To understand the salary range within Data Analyst roles, I analyzed job postings based on their average yearly salary. This query helped identify the highest-paying positions, companies offering competitive salaries, and how seniority levels influence compensation in the field.

```
SELECT 
  job_id,
  job_title,
  name AS company_name,
  job_location,
  job_schedule_type,
  salary_year_avg,
  job_posted_date
FROM
  job_postings_fact
LEFT JOIN company_dim
  ON job_postings_fact.company_id = company_dim.company_id
WHERE
  job_title_short = 'Data Analyst' AND 
  job_work_from_home = true AND
  salary_year_avg IS NOT NULL 
ORDER BY
  salary_year_avg DESC
LIMIT 10;
```

### Key Insights:

- The highest-paying role found was a Data Analyst position at Mantys with an average yearly salary of $650K.

- Senior-level roles such as Director of Analytics and Principal Data Analyst appeared frequently among the highest-paying positions.

- Companies like Meta, AT&T, Pinterest, and SmartAsset offered some of the highest compensation packages.


--- 

### 2. Top Paying Skills 💡

This analysis focused on identifying the skills that were associated with higher-paying Data Analyst roles. By comparing salaries with required skills, I explored which technical skills can have a strong impact on earning potential.

```
WITH top_paying_jobs AS (
  SELECT 
    job_id,
    job_title,
    --job_location,
    name AS company_name,
    salary_year_avg
  FROM
    job_postings_fact
  LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
  WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'United Kingdom' 
    AND salary_year_avg IS NOT NULL 
  ORDER BY
    salary_year_avg DESC
  LIMIT 10
)

SELECT 
  top_paying_jobs.*,
  skills
FROM 
  top_paying_jobs
INNER JOIN skills_job_dim 
  ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
  ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
  salary_year_avg DESC;
```
* Skills associated with higher salaries were not limited to traditional analytics tools and included technologies related to programming, databases, and advanced analytics.
* Tools like **SQL, Python, Tableau, Power BI, and Looker** appeared in high-paying Data Analyst roles.
* Advanced skills such as **Azure, Databricks, SAP, and cloud technologies** showed strong salary potential.
* This suggests that combining analytics skills with technical knowledge can lead to better-paying opportunities.

---

### 3. Most In-Demand Skills 📈

To understand what employers are commonly looking for, I analyzed the frequency of skills mentioned across Data Analyst job postings. This helped identify the most requested skills in the industry.

``` 
SELECT
  skills_dim.skills,
  COUNT(job_postings_fact.job_id) AS skills_count
FROM
  job_postings_fact
INNER JOIN skills_job_dim
  ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
  ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_location = 'United Kingdom' AND
  job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
  skills
ORDER BY  
  skills_count DESC
LIMIT 5;
```
* **SQL** was the most frequently required skill, appearing in **867 job postings**, making it one of the most important skills for Data Analysts.

* Other highly demanded skills included:

  * Excel (776 postings)
  * Power BI (557 postings)
  * Python (455 postings)
  * Tableau (361 postings)

* This highlights the importance of having strong foundations in querying, data manipulation, and visualization.

---

### 4. Average Salary by Skill 💵

This analysis explored the average salary associated with different skills to understand which technologies are linked with better compensation. It helped compare the value of individual skills in the job market.

``` 
SELECT
  skills_dim.skills,
  ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM
  job_postings_fact
INNER JOIN skills_job_dim
  ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
  ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_location = 'United Kingdom' AND
  job_postings_fact.job_title_short = 'Data Analyst' AND
  job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
  skills_dim.skills
ORDER BY  
  average_salary DESC
LIMIT 20;
```
* Skills like **Shell, Flow, Looker, and SAS** showed higher average salaries among the analyzed roles.
* **Python, Excel, R, Tableau, and Power BI** continued to show strong salary potential while also being widely used in the industry.
* The results indicate that both technical programming skills and business intelligence tools contribute to higher earning potential.

---

### 5. Optimal Skills ⭐

This analysis combined skill demand and salary data to identify skills that provide the best balance between being frequently required and offering strong earning potential.

```
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
```
* The analysis identified skills that have a balance between being frequently requested and offering strong salary potential.

* Some of the most valuable skills were:

  * **Python** → High demand with an average salary of ~$101K
  * **SQL** → Most demanded skill with an average salary of ~$96K
  * **Tableau** → Strong demand and salary potential
  * **Azure & AWS** → Lower demand compared to SQL/Python but higher average salaries
  * **Snowflake & Spark** → Specialized skills with higher salary potential

* These skills represent a strong combination for professionals looking to improve their opportunities in Data Analytics.


# What I Learned 📚

Working on this project helped me gain practical experience with SQL, databases, and analyzing real-world datasets. Some of the key things I learned were:

* **Working with Databases:** Learned how to connect VS Code with PostgreSQL, manage datasets, and work with relational database structures.

* **Writing SQL Queries:** Improved my understanding of SQL concepts like joins, filtering, grouping, aggregations, and sorting to extract meaningful insights.

* **Data Analysis Process:** Learned how to transform raw job posting data into useful insights by identifying patterns, trends, and relationships within the data.

* **Understanding Real-World Data:** Gained experience in analyzing a practical dataset and answering business-related questions using data.

* **Version Control with Git/GitHub:** Learned how to track project changes, organize my work, and maintain a project repository using Git and GitHub.

* **Turning Data into Insights:** Improved my ability to interpret query results and communicate findings in a clear and meaningful way.

# Conclusion

This project helped me understand how SQL and data analysis can be used to explore real-world datasets and uncover meaningful insights.

The analysis showed that while foundational skills like **SQL, Excel, Power BI, Python, and Tableau** remain highly important, additional knowledge in areas like **cloud technologies, programming, and data platforms** can create better career opportunities.

Overall, this project gave me hands-on experience in working with databases, writing analytical queries, and converting raw data into insights that can help understand industry trends. 🚀
