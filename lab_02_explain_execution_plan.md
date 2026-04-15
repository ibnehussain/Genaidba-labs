# Lab 02 — Explain Execution Plan Using GenAI
---

## Objective
Use GitHub Copilot Chat to interpret an Oracle execution plan, identify the performance bottleneck, and get actionable optimisation recommendations.

## Prerequisites
- GitHub Copilot Chat enabled in VS Code
- Basic familiarity with Oracle execution plan concepts (EXPLAIN PLAN, DBMS_XPLAN)

---

## Background

Execution plans can be daunting — full of icons, arrows, statistics, and cryptic operator names. GenAI excels at translating this technical detail into plain English explanations and actionable recommendations.

---

## Sample Slow Query

```sql
SELECT 
    c.cust_name,
    c.region,
    SUM(o.order_amount) AS total_revenue,
    COUNT(o.order_id)   AS order_count
FROM Customers c
INNER JOIN Orders o ON c.cust_id = o.cust_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2024
    AND c.region IN ('North', 'South', 'East')
GROUP BY c.cust_name, c.region
ORDER BY total_revenue DESC;
```

**Execution Stats (simulated):**
- Execution time: 38 seconds
- Buffer gets (logical reads): 4,200,000 on ORDERS
- Estimated rows: 15,000 | Actual rows: 847,223
- Operation: `TABLE ACCESS FULL` on ORDERS (95% cost)

---

## Execution Plan Output (Oracle DBMS_XPLAN format)

Copy this into your prompt:

```
--------------------------------------------------------------------------------------------------
| Id  | Operation             | Name     | Rows  | Bytes  | Cost  | Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |          |       |        | 38421 |          |
|   1 |  SORT ORDER BY        |          | 15000 |  1171K | 38421 | 00:38:00 |
|   2 |   HASH GROUP BY       |          | 15000 |  1171K | 38400 | 00:38:00 |
|*  3 |    HASH JOIN          |          |847223 |   64M  | 35200 | 00:35:00 |
|*  4 |     TABLE ACCESS FULL | ORDERS   |847223 |   40M  | 34500 | 00:34:30 |
|*  5 |     INDEX RANGE SCAN  | PK_CUST  |  850K |   24M  |   300 | 00:00:01 |
--------------------------------------------------------------------------------------------------
Predicate Information:
   4 - filter(EXTRACT(YEAR FROM order_date)=2024)
   5 - access(region IN ('North','South','East'))

Note: dynamic statistics used (statistics are stale or missing)

Missing Index Recommendation:
  CREATE INDEX idx_orders_date_cust ON Orders(order_date, cust_id)
  -- Adding order_amount, order_id as included columns improves covering
```

---

## Part A — Basic Explanation Prompt

Open Copilot Chat and submit:

```
You are an Oracle 19c DBA specialising in performance tuning. Explain this
execution plan in plain English for a developer who understands SQL but is
not familiar with Oracle execution plans.

Query:
[paste the query above]

Execution plan details:
- TABLE ACCESS FULL on ORDERS: cost 34,500 (95% of total cost)
- HASH JOIN between ORDERS and CUSTOMERS
- Sort operation: cost 2,100
- Estimated rows: 15,000 | Actual rows: 847,223
- Missing index recommendation: idx_orders_date_cust on Orders(order_date, cust_id)

Answer these questions:
1. What is the #1 performance bottleneck and why?
2. Why is the row count estimate so wrong (15K vs 847K)?
3. What is causing the full table scan instead of an index range scan?
4. What does the missing index recommendation mean?
```

---

## Part B — Optimisation Recommendation Prompt

After receiving the explanation, ask:

```
Based on your analysis, provide:
1. The CREATE INDEX statement for the missing index recommendation
2. The rewritten query that fixes the non-SARGable YEAR() predicate
3. What execution time improvement would you estimate after these changes?
4. Are there any other improvements you would recommend?
```

---

## Part C — Apply the Fix

Compare the original query with the AI-suggested fix:

**Original (non-SARGable — prevents index range scan):**
```sql
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
```

**Fixed (SARGable — allows index range scan):**
```sql
WHERE o.order_date >= DATE '2024-01-01'
  AND o.order_date <  DATE '2025-01-01'
```

**Questions to consider:**
- [ ] Why does wrapping `order_date` in `EXTRACT()` prevent an index range scan?
- [ ] What is a SARGable predicate? (Ask Copilot if unsure!)
- [ ] What other Oracle functions commonly cause this issue? (Ask: *"List 5 common non-SARGable patterns in Oracle SQL"*)

---

## Bonus Challenge

Paste this execution plan question into Copilot Chat:

```
What is a Hash Join and when does Oracle choose it 
over a Nested Loop join or Merge Join? 
When would you see a Hash Join on a well-indexed table vs. a poorly-indexed one?
```

---

## Debrief Questions

1. Did Copilot correctly identify the table scan as the bottleneck?
2. Did it explain the row count cardinality mismatch accurately?
3. How useful was the missing index explanation?
4. Would you have reached the same conclusions without AI? In how much time?

---

## Expected Learning Outcome
You can now use GitHub Copilot to interpret complex execution plans, identify root causes of performance issues, and receive concrete optimisation recommendations — reducing plan analysis time from hours to minutes.
