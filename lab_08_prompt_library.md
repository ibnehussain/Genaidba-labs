# Lab 08 — Create Personal DBA Prompt Library

---

## Objective
Create a reusable DBA prompt library you can immediately use in Copilot Chat for SQL generation, tuning, documentation, and PL/SQL development.

## Prerequisites
- VS Code
- GitHub Copilot Chat is enabled

---

## Step 1 — Create Your Prompt Library File
Create a new file in your folder named `my_dba_prompt_library.md`.

---

## Step 2 — Paste This Complete Starter Library(Markdown file ends before step 3) 
Copy everything in the block below into `my_dba_prompt_library.md`. 

````markdown
# My DBA Prompt Library
**Environment:** Oracle 19c  
**Schema prefix:** SALES_APP  
**Naming convention:** proc_ (procedures), vw_ (views), fn_ (functions)  
**Team standards:** ANSI JOINs, CTEs preferred over nested subqueries, bind variables, explicit column lists

---

## Shared Schema Context (Copy/Paste)
Use this schema block in templates when needed:

```sql
CREATE TABLE customers (
		customer_id     NUMBER PRIMARY KEY,
		customer_name   VARCHAR2(100) NOT NULL,
		region          VARCHAR2(30) NOT NULL,
		signup_date     DATE NOT NULL,
		status          VARCHAR2(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE'))
);

CREATE TABLE orders (
		order_id        NUMBER PRIMARY KEY,
		customer_id     NUMBER NOT NULL,
		order_date      DATE NOT NULL,
		order_status    VARCHAR2(20) NOT NULL,
		total_amount    NUMBER(12,2) NOT NULL,
		CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
		order_item_id   NUMBER PRIMARY KEY,
		order_id        NUMBER NOT NULL,
		product_id      NUMBER NOT NULL,
		quantity        NUMBER(10) NOT NULL,
		unit_price      NUMBER(10,2) NOT NULL,
		CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```

Assume table sizes:
- customers: 250,000 rows
- orders: 12,000,000 rows
- order_items: 48,000,000 rows

---

## TEMPLATE 1 — Query Generation

### Role
You are a Senior Oracle 19c DBA specialising in OLTP systems.

### Prompt
```text
Environment: Oracle 19c
Schema: SALES_APP

Schema DDL:
[paste Shared Schema Context]

Task: Write a SELECT query that returns top 20 ACTIVE customers by total revenue in the last 90 days.

Requirements:
- Output columns: customer_id, customer_name, total_revenue, total_orders
- Exclude cancelled orders (order_status = 'CANCELLED')
- Use bind variable :days_back instead of hardcoded day value

Performance requirements:
- Must complete within 2 seconds on stated table sizes
- Avoid full scan on orders where possible

Coding standards:
- ANSI JOINs only
- Readable CTEs
- Inline comments only

Output: SQL code only
```

---

## TEMPLATE 2 — Stored Procedure Generation

### Role
You are a Senior Oracle 19c DBA following enterprise PL/SQL standards.

### Prompt
```text
Create a stored procedure with this specification.

Name: proc_mark_customer_inactive
Purpose: Mark customers as INACTIVE if they have no completed orders in the past N days.

Parameters:
- p_days_without_order IN NUMBER
- p_rows_updated OUT NUMBER

Schema context:
[paste Shared Schema Context]

Logic:
1. Find ACTIVE customers with no non-cancelled orders in the lookback period.
2. Update status to INACTIVE.
3. Return updated row count in p_rows_updated.

Error handling:
- EXCEPTION block with ROLLBACK
- Log errors to error_log table (create statement included if missing)
- Use RAISE_APPLICATION_ERROR for invalid p_days_without_order <= 0

Output:
- Complete Oracle PL/SQL procedure
- Include header comment block
- Include anonymous block showing how to call and test it
```

---

## TEMPLATE 3 — Query Performance Review

### Role
You are an Oracle 19c DBA specialising in performance tuning.

### Prompt
```text
Review this query for performance issues.

Environment: Oracle 19c
Table sizes:
- customers: 250,000
- orders: 12,000,000
- order_items: 48,000,000

Available indexes:
- idx_orders_customer_date(customer_id, order_date)
- idx_orders_status(order_status)
- idx_order_items_order(order_id)

Think step by step:
1. Identify all performance issues
2. Rate each issue as HIGH / MEDIUM / LOW
3. Suggest a fix for each issue
4. Provide an optimized rewrite

Query:
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE TRUNC(o.order_date) >= TRUNC(SYSDATE) - 90
	AND UPPER(o.order_status) <> 'CANCELLED'
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC;
```

---

## TEMPLATE 4 — Execution Plan Analysis

### Prompt
```text
Analyze this execution plan.

Answer:
1. What is the #1 bottleneck and why?
2. Are there non-SARGable predicates?
3. What does estimated rows vs actual rows indicate?
4. What missing index opportunities are implied?
5. What is your recommended fix?

Query:
SELECT *
FROM orders
WHERE TRUNC(order_date) = TRUNC(SYSDATE)
	AND order_status = 'SHIPPED';

Execution stats:
- Execution time: 9.4 seconds
- Buffer gets: 1,850,000
- Estimated rows: 3,200 vs Actual rows: 74,100
- Key operations: TABLE ACCESS FULL on ORDERS
```

---

## TEMPLATE 5 — Schema Documentation

### Role
You are a technical writer specialising in database documentation.

### Prompt
```text
Generate professional markdown documentation for this schema.

For each table include:
- 2-3 sentence business purpose
- Column table: Name | Type | Nullable | Description | Default
- Primary/Foreign key relationships
- Business rules and valid values where known

Schema:
[paste Shared Schema Context]

Output:
- Markdown only
- Ready for GitHub wiki
```

---

## TEMPLATE 6 — Index Recommendation (Added)

### Role
You are an Oracle performance tuning specialist.

### Prompt
```text
Given the schema and query below, recommend index changes.

Schema:
[paste Shared Schema Context]

Query pattern:
- Frequent filter: order_status, order_date range
- Frequent join: orders.customer_id = customers.customer_id
- Frequent aggregation: SUM(total_amount) by customer

Requirements:
1. Propose candidate indexes (if any)
2. Explain selectivity/cardinality rationale
3. Mention DML tradeoffs (insert/update overhead)
4. Provide CREATE INDEX statements
5. Suggest how to verify benefit using execution plan
```

---

## TEMPLATE 7 — Data Validation (Added)

### Role
You are a Senior DBA responsible for data quality controls.

### Prompt
```text
Generate SQL validation checks for this schema.

Schema:
[paste Shared Schema Context]

Create checks for:
1. Orphan orders without matching customers
2. Orphan order_items without matching orders
3. Negative or zero quantity in order_items
4. Invalid status values in customers
5. Orders with total_amount mismatch vs sum(order_items)

Output:
- SQL only
- One query per check
- Add a short comment before each query describing expected result
```
````

---

## Step 3 — Quick Test
Open Copilot Chat and run this prompt:

```text
#file:my_dba_prompt_library.md
Use TEMPLATE 1 exactly as written and return only the SQL query.
```

Then run this second test:

```text
#file:my_dba_prompt_library.md
Use TEMPLATE 3 exactly as written. Return:
1) issue list with impact levels,
2) optimized SQL rewrite,
3) one-paragraph explanation of why rewrite is faster.
```

---

## Step 4 — Output Quality Checklist
Use this checklist to validate Copilot output:

- Query uses ANSI JOIN syntax
- Query avoids `TRUNC(column)` or `UPPER(column)` on indexed filters unless justified
- Bind variables are used where requested
- SQL is readable and commented
- Response format matches requested output exactly

If any item fails, rerun with this follow-up prompt:

```text
Revise your previous answer to satisfy all checklist items. Keep the same business logic.
```

---

## Optional Personalization(Do not use MCP server as this will be covered in future)
After successful tests, replace sample values with your real environment:
- Schema name and naming conventions
- Your actual tables and indexes
- Team coding standards
- Your common performance SLAs

---

## Expected Learning Outcome
You now have a copy/paste-ready DBA prompt library that is immediately testable, version-controllable, and reusable for daily DBA tasks.
