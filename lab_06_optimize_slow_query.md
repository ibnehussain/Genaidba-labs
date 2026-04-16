# Lab 06 — Optimize Slow Query via Prompt

---

## Objective
Use role-based prompting with constraint and step-by-step reasoning to optimise a deliberately slow SQL query.

## Prerequisites
- Completed Day 1 labs

---

## The Problem Query

This query takes 52 seconds on a production table:

```sql
SELECT 
    e.emp_name,
    d.dept_name,
    e.salary,
    (SELECT AVG(salary) FROM Employees WHERE dept_id = e.dept_id) AS dept_avg_salary,
    (SELECT MAX(salary) FROM Employees WHERE dept_id = e.dept_id) AS dept_max_salary,
    (SELECT COUNT(*) FROM Employees WHERE dept_id = e.dept_id) AS dept_headcount
FROM Employees e
INNER JOIN Departments d ON d.dept_id = e.dept_id
WHERE 
    TO_CHAR(e.hire_date, 'YYYY') = '2023'
    AND d.is_active = 1
ORDER BY dept_avg_salary DESC, e.salary DESC;
```

**Schema:**
```sql
CREATE TABLE Departments (
    dept_id    NUMBER       NOT NULL PRIMARY KEY,
    dept_name  VARCHAR2(100) NOT NULL,
    is_active  NUMBER(1,0)  DEFAULT 1 NOT NULL
);

CREATE TABLE Employees (
    emp_id     NUMBER        NOT NULL PRIMARY KEY,
    emp_name   VARCHAR2(100) NOT NULL,
    dept_id    NUMBER        NOT NULL REFERENCES Departments(dept_id),
    salary     NUMBER(10,2)  NOT NULL,
    hire_date  DATE          NOT NULL
);
-- Indexes:
-- idx_emp_dept  ON Employees(dept_id)
-- idx_emp_hire  ON Employees(hire_date)
```

**Execution stats:**
- 2.1M rows in Employees
- TABLE ACCESS FULL on Employees occurring 3 times (correlated subqueries)
- Non-SARGable predicate on hire_date preventing index range scan

---

## Part A — Diagnose First (Step-by-Step Reasoning Prompt)

```
You are a Senior Oracle DBA specialising in performance tuning 
for OLTP systems with multi-million row tables.

Think step by step:

Step 1: Identify ALL performance issues in this query (list each one)
Step 2: For each issue, explain WHY it causes poor performance
Step 3: Prioritise the issues from highest to lowest impact
Step 4: Propose a fix for each issue

Query:
[paste the query]

Schema + Indexes:
[paste schema + index info] or create file in vs code

Environment: Oracle 19c, 2.1M rows in Employees
```

---

## Part B — Optimised Rewrite Prompt

After reviewing the diagnosis, prompt for the fix:

```
Now rewrite the query applying all fixes:
1. Replace the 3 correlated subqueries with a single window function CTE
2. Fix the non-SARGable hire_date predicate (TO_CHAR wrapping prevents index use)
3. Ensure all predicates can use available indexes

Requirements:
- Use CTEs for readability
- Add comments explaining what each section does
- Show the before/after for the hire_date predicate fix with explanation
- Output: Optimised SQL only
```

---

## Part C — Verify with Follow-Up

```
Verify the rewritten query:
1. Does it return the same columns as the original?
2. Are there any edge cases the original handled that the rewrite might miss?
3. What estimated performance improvement would you expect and why?
4. Are there any additional indexes that would further improve performance?
```

---

## Key Concepts to Verify You Understand

After the lab, ask Copilot to explain:
- *"What is a correlated subquery and why does it cause N+1 performance issues?"*
- *"What is the difference between RANK(), DENSE_RANK(), and ROW_NUMBER() in Oracle?"*
- *"What is the benefit of using AVG() OVER(PARTITION BY) vs. a correlated subquery?"*

---

## Expected Learning Outcome
You can identify and fix common SQL performance anti-patterns (correlated subqueries, non-SARGable predicates) using targeted Copilot prompts with step-by-step reasoning.
