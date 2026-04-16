# Lab 04 — Generate SELECT/JOIN from Natural Language


---

## Objective
Practice translating natural language business questions into SQL using Copilot Chat, using the schema from Lab 03.

## Prerequisites
- Completed Lab 03 (familiarity with sample schema)
- GitHub Copilot Chat enabled

---

## Schema Reminder

Tables: `Customers`, `Orders`, `OrderItems`, `Products`  
*(Full DDL in Lab 03)*

---

## Instructions

For each business question below, use this prompt structure in Copilot Chat:

```
Using this Oracle 19c schema:
[paste the 4 CREATE TABLE statements from Lab 03]

Write an Oracle SQL query that answers this question:
[insert question]

Requirements:
- Use ANSI JOIN syntax
- Add a comment above each major section
- Use CTEs if more than 2 joins are needed
- Use Oracle-native functions (SYSDATE, ADD_MONTHS, EXTRACT, TO_CHAR, etc.)
```

---

## Question Set A — Simple SELECT & JOINs

**Question 1:**
> "Show me all active customers from the North region who have never placed an order."

**Question 2:**
> "List all orders placed in the last 7 days with the customer name, total amount, and number of line items."

**Question 3:**
> "Find all products that have been ordered at least 50 times in total, show product name, category, and total quantity ordered."

---

## Question Set B — Aggregation & Grouping

**Question 4:**
> "Show total revenue and order count per region per month for 2024. Include months with zero orders."

**Question 5:**
> "Find the top 3 best-selling products in each category by total revenue."

---

## Question Set C — Advanced Joins & Subqueries

**Question 6:**
> "Show me customers who placed more than 5 orders but have an average order value below $200. Include their name, region, order count, and average order value."

**Question 7:**
> "For each customer, show their most recent order date and whether they are 'Active' (last order within 90 days), 'At Risk' (91–180 days), or 'Churned' (over 180 days ago)."

---

## Validation Steps

For each generated query:
1. Read through it — does the logic match the question?
2. Check all table/column names are correct
3. Ask Copilot: *"Are there any edge cases this query doesn't handle?"*
4. For Question 4 (including zero months), verify the LEFT JOIN or cross-join logic is correct

---

## Reflection

After completing the questions:

Ask Copilot: *"For Question 5, what are the different ways to write a 'top N per group' query in Oracle? Show me 3 approaches (ROW_NUMBER, RANK, FETCH FIRST) and explain the tradeoffs."*

---

## Expected Learning Outcome
You can convert any business question into SQL using Copilot — with schema context ensuring column names and joins are always correct.
