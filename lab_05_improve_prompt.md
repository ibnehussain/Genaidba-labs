# Lab 05 — Improve Weak Prompt → Structured DBA Prompt


---

## Objective
Practise transforming poor-quality, vague prompts into structured, production-grade DBA prompts and observe the quality difference in output.

## Prerequisites
- GitHub Copilot Chat enabled in VS Code

---

## Instructions

For each weak prompt below:
1. Submit the weak prompt to Copilot Chat — note the quality of output
2. Rewrite it using the 4-component structure (Instruction / Context / Constraints / Output)
3. Submit your improved prompt — compare the outputs

---

## Exercise 1 — "Fix My Query"

**Weak Prompt:**
```
Fix my query it's slow
SELECT * FROM Orders WHERE TRUNC(order_date) = DATE '2024-01-15'
-- Rewrite: original used TO_CHAR wrapping which is non-SARGable
```

**Your Task:** Rewrite this prompt to include:
- What RDBMS and version you are using
- What "slow" means (how many seconds? how many rows in table?)
- What specific problem to fix (non-SARGable predicate using TO_CHAR/TRUNC on indexed column)
- What output format you want (fixed SQL + explanation of the change)

**Improved Prompt (fill in the blanks):**
```
You are an Oracle 19c DBA specialising in performance tuning.

INSTRUCTION: Rewrite this query to eliminate the non-SARGable predicate 
and enable an index range scan on the order_date column.

CONTEXT:
- Oracle 19c
- Orders table has 8 million rows
- Index exists: idx_orders_date ON Orders(order_date)
- Current execution time: 22 seconds (full table scan observed)

CONSTRAINTS:
- The query must return the same results (all orders for 2024-01-15)
- Do not change any other logic
- The fix must enable an index range scan, not a full table scan

OUTPUT: 
1. The fixed SQL
2. One-sentence explanation of why the original was slow
3. One-sentence explanation of why the fix works

Original query:
SELECT * FROM Orders WHERE TO_CHAR(order_date,'YYYY-MM-DD') = '2024-01-15'
```

---

## Exercise 2 — "Create a Stored Procedure"

**Weak Prompt:**
```
Create a stored procedure for customer orders
```

**Your Task:** Rewrite this with all required details.

**Hint — Think about:**
- What should the procedure DO exactly?
- What parameters does it need?
- What tables does it touch?
- What are the error handling requirements?
- What should it return?

**Improved Prompt Template:**
```
You are a Senior Oracle DBA following enterprise coding standards.

INSTRUCTION: Create a stored procedure that [specific action]

CONTEXT:
Database: Oracle 19c
Schema: 
  - Customers (cust_id, cust_name, region, status)
  - Orders (order_id, cust_id, order_date, total_amount, status)
Business logic: [describe the logic in detail]

CONSTRAINTS:
- Include EXCEPTION handling with rollback
- Log errors to ErrorLog (error_time, error_message, proc_name)
- Use Oracle PL/SQL syntax (IN/OUT parameters, EXCEPTION block)
- Add a header comment block with: Purpose, Parameters, Returns, Author, Date
- Naming convention: p_[action]_[entity] for parameters

OUTPUT: Complete stored procedure code with comments
```

---

## Exercise 3 — "Document This Database"

**Weak Prompt:**
```
Document my database
```

**Your Task:** Compare outputs and then perfect the prompt for a specific documentation need.

---

## Exercise 4 — Peer Review

Swap your improved prompts with a colleague. Submit each other's prompts and compare:
- Did their prompt produce a different result than yours?
- Whose constraints were more complete?
- What would you add or change?

---

## Scoring Rubric

Rate each of your improved prompts (self-assessment):

| Criterion | 1 | 2 | 3 |
|-----------|---|---|---|
| Has clear INSTRUCTION | Vague | Specific action | Specific + measurable |
| Has useful CONTEXT | No schema/env | Schema only | Schema + env + scale |
| Has CONSTRAINTS | None | 1–2 constraints | 3+ constraints + standards |
| Has OUTPUT spec | None | Format only | Format + length + style |

**Target:** Score 3 in all four categories for each prompt.

---

## Expected Learning Outcome
You understand the direct relationship between prompt quality and output quality — and have practised building the habit of structured prompt writing before submitting to Copilot.
