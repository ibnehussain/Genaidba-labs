# Lab 07 — Suggest Indexes via Prompt

---

## Objective
Use GitHub Copilot to analyse a set of queries and generate index recommendations with full justification.

## Prerequisites
- Familiarity with Oracle index types (B-tree, bitmap, function-based, composite)

---

## The Scenario

You are the DBA for a reporting database. Your team has submitted three frequently-run slow queries. You need index recommendations for each.

---

## Schema

```sql
CREATE TABLE Sales (
    sale_id        NUMBER        NOT NULL PRIMARY KEY,
    cust_id        NUMBER        NOT NULL,
    product_id     NUMBER        NOT NULL,
    sale_date      DATE          NOT NULL,
    salesperson_id NUMBER        NOT NULL,
    region         VARCHAR2(50)  NOT NULL,
    quantity       NUMBER        NOT NULL,
    unit_price     NUMBER(10,2)  NOT NULL,
    discount_pct   NUMBER(5,2)   DEFAULT 0 NOT NULL,
    sale_amount    NUMBER(15,2)  NOT NULL
);

CREATE TABLE Salespersons (
    salesperson_id NUMBER        NOT NULL PRIMARY KEY,
    sp_name        VARCHAR2(100) NOT NULL,
    territory      VARCHAR2(50)  NOT NULL,
    manager_id     NUMBER        NULL
);

-- Current indexes:
-- PK_Sales (on sale_id)
-- PK_Salespersons (on salesperson_id)
-- No other indexes currently exist
```

---

## The Three Slow Queries

**Query 1 — Regional monthly summary (runs every hour):**
```sql
SELECT 
    region,
    EXTRACT(YEAR FROM sale_date)  AS sale_year,
    EXTRACT(MONTH FROM sale_date) AS sale_month,
    SUM(sale_amount)              AS total_revenue,
    COUNT(DISTINCT cust_id)       AS unique_customers
FROM Sales
WHERE sale_date >= DATE '2024-01-01'
  AND sale_date <  DATE '2025-01-01'
GROUP BY region, EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
ORDER BY region, sale_year, sale_month;
```

**Query 2 — Salesperson performance (runs on demand, ~50 times/day):**
```sql
SELECT 
    sp.sp_name,
    sp.territory,
    COUNT(s.sale_id)     AS total_sales,
    SUM(s.sale_amount)   AS total_revenue,
    AVG(s.discount_pct)  AS avg_discount
FROM Sales s
INNER JOIN Salespersons sp ON sp.salesperson_id = s.salesperson_id
WHERE s.sale_date >= ADD_MONTHS(SYSDATE, -3)
GROUP BY sp.sp_name, sp.territory;
```

**Query 3 — Customer purchase history (runs per web request, high frequency):**
```sql
SELECT 
    sale_id, sale_date, product_id, quantity, sale_amount
FROM Sales
WHERE cust_id = :cust_id
ORDER BY sale_date DESC;
```

---

## Part A — Index Analysis Prompt

```
You are an Oracle 19c indexing specialist.

Analyse these 3 queries and recommend the optimal indexes.
For each recommended index:
1. Write the CREATE INDEX statement
2. Explain which query it helps and how (full scan vs. index range scan, covering index benefit)
3. Identify which columns are key columns vs. additional columns and why
4. Note any index maintenance considerations (write overhead, statistics)

Also:
- Identify any redundant indexes among your recommendations
- Recommend the order to create the indexes (highest impact first)

Schema: [paste schema]
Queries: [paste all 3 queries]
Environment: Oracle 19c, Sales has 15M rows, Salespersons has 500 rows
```

---

## Part B — Index Impact Analysis

After receiving recommendations, ask:

```
For each index you recommended:
1. Estimate the performance improvement (table scan → index seek is roughly how much faster?)
2. What is the storage cost of each index (estimate based on 15M rows and column sizes)?
3. What is the INSERT/UPDATE overhead impact?
4. Which index gives the best performance-to-cost ratio?
```

---

## Part C — Index Consolidation

```
Can any of the 3 indexes be consolidated into fewer indexes?
For example, can one covering index serve both Query 1 and Query 3?
Show the consolidated set and explain the tradeoffs.
```

---

## Bonus: Check For Over-Indexing

```
A colleague suggests also adding indexes on:
- (product_id)
- (discount_pct)
- (salesperson_id, region, sale_date, quantity, unit_price, sale_amount)

Evaluate each suggestion. Which are well-justified? Which are over-indexing? Why?
```

---

## Expected Learning Outcome
You can use Copilot to generate well-justified index recommendations — including covering index design, key vs. INCLUDE columns, and write overhead analysis — in a fraction of the time it would take manually.
