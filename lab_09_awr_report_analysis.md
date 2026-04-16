# Lab 09 — Performance Tuning Using AWR Report Analysis and Action Planning

---

## Objective
Use GitHub Copilot Chat to analyze a simulated Oracle AWR report, identify bottlenecks, produce a prioritized action plan, and generate SQL-level fixes you can test immediately.

## Prerequisites
- VS Code
- GitHub Copilot Chat is enabled

---

## Step 1 — Copy This AWR Dataset
Copy the block below. You will paste this exact data into each prompt.

```text
AWR Snapshot Info
DB Name: PRODDB  |  DB Version: Oracle 19.11  |  Snap: 4120 -> 4121
Elapsed: 60 min  |  DB Time: 842 min  |  CPUs: 32  |  Sessions: 180

Top 5 Wait Events
Event                          Waits      Time (s)   % DB Time
------------------------------ ---------- ---------- ---------
db file sequential read        1,842,003  24,310     48.1%
log file sync                    89,041   8,220      16.3%
db file scattered read           142,008  6,870      13.6%
latch: cache buffers chains       38,002  3,210       6.4%
CPU time                               -  4,680       9.3%

Top SQL by Elapsed Time
SQL_ID        Elapsed(s)  Executions  Avg(s)  CPU(s)   LReads   PReads
------------- ----------- ----------- ------- -------- -------- -------
7gfnb2k4q8xz   18,420       12        1,535    820    9,420,003  88,420
2xmn9pjd1ayw    9,840       840          11.7   3,400  2,810,000   4,200
5rvq8dhf0kkp    6,210     1,200           5.2   4,100    980,000   1,800
a1pm3xvh7wqr    3,980    48,000          0.083    720    420,000      80
c9qp5ykl2nbt    2,840    96,000          0.030    460    188,000      20

Top SQL by Physical Reads (detail)
SQL_ID: 7gfnb2k4q8xz
SQL Text:
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity, oi.unit_price
FROM orders o, customers c, order_items oi, products p
WHERE o.customer_id = c.customer_id
  AND oi.order_id = o.order_id
  AND oi.product_id = p.product_id
  AND TRUNC(o.order_date) = TRUNC(SYSDATE - 1)
  AND c.region = 'APAC'
ORDER BY o.order_date DESC;

Plan: Full Table Scan on ORDERS (7.2M rows), CUSTOMERS, ORDER_ITEMS
Missing: Index on ORDERS(order_date), CUSTOMERS(region)
Execution count: 12 times in 1 hour (scheduled report job)

Memory and I/O Summary
Buffer Cache Hit Ratio: 87.3%   (Target: >95%)
Library Cache Hit Ratio: 94.1%  (Target: >99%)
PGA Memory Used: 28.4 GB / 32 GB allocated
Redo Log Waits: 16.3% DB Time (I/O pressure on redo path)
```

---

## Step 2 — Run Prompt A (AWR Interpretation)
Open Copilot Chat and paste this prompt exactly:

```text
You are an Oracle 19c DBA expert specializing in AWR analysis and performance tuning.

Task:
Analyze the AWR data and return the answer in this exact structure:

1) Wait Event Analysis
- Event
- Meaning
- Actionability (High/Medium/Low)
- Likely Root Cause

2) Top SQL Analysis
- Top 3 SQL_IDs to fix first (with reason)
- Deep analysis of SQL_ID 7gfnb2k4q8xz

3) Memory and I/O Assessment
- Buffer cache assessment
- Library cache assessment
- PGA utilization assessment
- Redo bottleneck assessment

4) Executive Summary
- 5 bullet points max

AWR Data:
[paste the full dataset from Step 1]
```

---

## Step 3 — Run Prompt B (Prioritized Action Plan)
Paste this prompt:

```text
Based on the AWR analysis, create a prioritized performance action plan.

Return a markdown table with columns:
Priority | Action | Expected Impact | Effort | Risk | Owner | Change Window Fit

Rules:
- Priority must be HIGH/MEDIUM/LOW
- Effort must be LOW (<1h), MEDIUM (half day), or HIGH (multi-day)
- Include only DBA-controllable actions
- No application code changes

Constraints:
- Production system with change management required
- Maintenance window: Sunday 2 AM to 6 AM
- DBA team only (no infra/storage team)

Also include:
1) Top 3 actions to execute this Sunday window
2) Backout note for each of those top 3 actions
```

---

## Step 4 — Run Prompt C (Fix Worst Query)
Paste this prompt:

```text
Fix SQL_ID 7gfnb2k4q8xz for Oracle 19c.

Known issues:
1. TRUNC(o.order_date) predicate is non-SARGable
2. Comma joins instead of ANSI JOIN
3. Missing indexes on filter/join columns

Return exactly these sections:
1) Optimized SQL
2) Index DDL
3) Optional temporary hints (if indexes are not yet deployed)
4) Why this rewrite should reduce elapsed time and physical reads
5) Validation steps using EXPLAIN PLAN / DBMS_XPLAN

Environment:
- ORDERS: 7.2M rows
- CUSTOMERS: 850K rows
- ORDER_ITEMS: large fact-style table
```

---

## Step 5 — Run Prompt D (Post-Change Monitoring)
Paste this prompt:

```text
After implementing the SQL and index changes, define monitoring for before/after verification.

Return exactly:
1) AWR metrics to compare (with formulas where useful)
2) SQL to collect before/after values from AWR views
3) Success thresholds
4) Escalation criteria if results do not improve
5) 24-hour and 7-day follow-up checklist

Scope:
- Oracle 19c
- DBA-only actions
```

---

## Step 6 — Validate Copilot Output (Pass/Fail)
Mark the run as successful only if all checks pass:

- Response uses the exact section/table format requested
- SQL rewrite removes non-SARGable TRUNC(column) filtering
- Join syntax is ANSI JOIN
- Index recommendations align to predicates and joins
- Monitoring includes measurable thresholds, not generic advice
- Action plan respects maintenance window and DBA-only constraint

If any check fails, use this correction prompt:

```text
Revise your previous answer to satisfy every checklist item exactly. Keep business intent unchanged.
```

---

## Optional Team Exercise (5 Minutes)
Ask your friends to compare outputs and agree on:
- Top 2 fixes to execute first
- One risk to track during deployment
- One metric that proves success

---

## Expected Learning Outcome
You can use GitHub Copilot Chat to interpret AWR-style data, prioritize performance actions, rewrite problematic SQL, and define measurable post-change verification without requiring live production access.
