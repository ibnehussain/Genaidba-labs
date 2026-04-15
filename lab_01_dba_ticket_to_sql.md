# Lab 01 — Convert DBA Ticket → Prompt → SQL

---

## Objective
Learn to translate a real-world DBA support ticket into a well-structured GitHub Copilot prompt, and then generate production-quality SQL.

## Prerequisites
- GitHub Copilot Chat enabled in VS Code
- **Open `lab_01.sql`** in VS Code — this is your working file for all parts of this lab
  - The file already contains the schema, a placeholder for Part A, the structured prompt template, and reference solutions for Parts B–D
  - Keep `lab_01.sql` as the **active editor tab** so Copilot Chat has it as context throughout the lab

---

## Background: The DBA Ticket

Imagine you receive this ticket in your ticketing system:

> **Ticket #TKT-4821**  
> **Priority:** High  
> **Submitted by:** Finance Team  
> **Description:** We need a report showing all customers whose account balance dropped below $1,000 at any point during Q4 2024 but recovered to above $5,000 by December 31, 2024. We need: customer ID, name, their lowest balance date and amount, their balance on Dec 31, and the region they belong to. Sort by the lowest balance amount ascending.

---

## Schema Reference

```sql
CREATE TABLE Customers (
    cust_id       NUMBER        NOT NULL PRIMARY KEY,
    cust_name     VARCHAR2(100) NOT NULL,
    region        VARCHAR2(50)  NOT NULL,
    status        VARCHAR2(20)  NOT NULL  -- 'ACTIVE', 'INACTIVE', 'CLOSED'
);

CREATE TABLE AccountBalances (
    balance_id    NUMBER          NOT NULL PRIMARY KEY,
    cust_id       NUMBER          NOT NULL REFERENCES Customers(cust_id),
    balance_date  DATE            NOT NULL,
    balance_amt   NUMBER(15, 2)   NOT NULL
);

-- Index available: idx_balances_cust_date ON AccountBalances(cust_id, balance_date)
```

---

## Part A — Weak Prompt (Do this first)

1. Make sure `lab_01.sql` is the **active file** in your editor.
2. Open **GitHub Copilot Chat** (`Ctrl+Alt+I`) and type this weak prompt:

```
Write a query for customer balance recovery.
```

3. Copy the output Copilot returns and paste it into `lab_01.sql` under the comment:
   ```sql
   -- [Paste Copilot weak prompt output here]
   ```

**Observe:** Compare Copilot's output against the ticket requirement above.
- Does it reference the correct tables (`Customers`, `AccountBalances`)?
- Does it filter by Q4 2024 dates?
- Does it apply the $1,000 drop and $5,000 recovery thresholds?
- Does it return all required columns?

---

## Part B — Build the Structured Prompt

1. In `lab_01.sql`, scroll to the **`PART B & C`** section and read the structured prompt written inside the `/* ... */` block.
2. Notice how it fills in all 4 components — **Instruction, Context, Constraints, Output** — directly from the ticket above.
3. Copy the entire prompt text (from `INSTRUCTION:` to `OUTPUT: SQL only...`) out of the comment block.
4. Paste it into **Copilot Chat** and submit.

> **Tip:** Having `lab_01.sql` open as the active file gives Copilot automatic context about the schema. You can also explicitly attach it in chat by typing `#file:lab_01.sql` before your prompt.

The completed 4-component prompt is:

```
INSTRUCTION: Write an Oracle SQL SELECT query

CONTEXT:
Database: Oracle 19c
Schema:
  CREATE TABLE Customers (
      cust_id       NUMBER        NOT NULL PRIMARY KEY,
      cust_name     VARCHAR2(100) NOT NULL,
      region        VARCHAR2(50)  NOT NULL,
      status        VARCHAR2(20)  NOT NULL
  );
  CREATE TABLE AccountBalances (
      balance_id    NUMBER          NOT NULL PRIMARY KEY,
      cust_id       NUMBER          NOT NULL REFERENCES Customers(cust_id),
      balance_date  DATE            NOT NULL,
      balance_amt   NUMBER(15, 2)   NOT NULL
  );
  -- Index available: idx_balances_cust_date ON AccountBalances(cust_id, balance_date)

Business requirement:
  Find all customers whose account balance dropped below $1,000 at any point
  during Q4 2024 (Oct 1 - Dec 31, 2024) but recovered to above $5,000 by
  Dec 31, 2024. Return: cust_id, cust_name, lowest balance date and amount,
  balance on Dec 31, and region. Sort by lowest balance amount ascending.

CONSTRAINTS:
- Use CTEs (not nested subqueries)
- Use the available index: idx_balances_cust_date
- Add inline comments explaining each CTE
- Use ANSI JOIN syntax
- Use Oracle 19c syntax (FETCH FIRST, EXTRACT, TO_DATE, etc.)

OUTPUT: SQL only, with comments. No explanation text.
```

---

## Part C — Submit and Review

1. Submit the structured prompt from Part B into Copilot Chat.
2. Copy the generated SQL and **replace** the reference query in the `PART B & C` section of `lab_01.sql` with Copilot's output.
3. Compare your output against the reference solution already in the file — look for structural similarities and differences.
4. Review against this checklist:

**Validation Checklist:**
- [ ] Does the query correctly identify customers whose balance went below $1,000 in Q4 2024?
- [ ] Does it also filter for balance > $5,000 on Dec 31, 2024?
- [ ] Are all column names correct (check against the schema in `lab_01.sql`)?
- [ ] Does it return: `cust_id`, `cust_name`, lowest balance date, lowest balance amount, Dec 31 balance, `region`?
- [ ] Is it sorted by `lowest_balance_amt` ascending?
- [ ] Does it use CTEs with inline comments?
- [ ] Does it use `INNER JOIN` (ANSI syntax) rather than Oracle legacy comma joins?

> **Reference:** The working solution is already in `lab_01.sql` under `PART B & C` — use it only after attempting the checklist yourself.

---

## Part D — Refine with Follow-Up

1. In Copilot Chat, send the following **follow-up prompt** (keep the same chat thread — Copilot retains context):

```
The query looks correct. Now add:
1. A column called 'recovery_amount' that shows the difference 
   between the Dec 31 balance and the lowest balance
2. Add a CASE WHEN column called 'recovery_tier':
   - 'STRONG' if recovery_amount > $10,000
   - 'MODERATE' if $5,000–$10,000
   - 'WEAK' if under $5,000
```

2. Copy the refined output and **replace** the reference query in the `PART D` section of `lab_01.sql` with Copilot's version.
3. Check that `recovery_amount` is correctly derived as `dec31_balance_amt - lowest_balance_amt`.
4. Verify the `CASE WHEN` thresholds match the spec: `> 10000` → STRONG, `>= 5000` → MODERATE, else WEAK.

> **Reference:** The working solution is already in `lab_01.sql` under `PART D` for comparison.

---

## Debrief Questions

1. Look at both queries saved in `lab_01.sql` (Part A vs Part B&C). What is the biggest structural difference?
2. Which of the 4 components — Instruction, Context, Constraints, Output — had the most impact on result quality? Why?
3. What would Copilot have generated without the schema pasted into the prompt?
4. In `lab_01.sql` Part D, how does the `CASE WHEN` logic handle a customer whose `recovery_amount` is exactly $5,000?

---

## File Reference

| Section | Location in `lab_01.sql` |
|---------|-------------------------|
| Schema  | Lines 10–22              |
| Part A — weak prompt output | Under `PART A` comment |
| Structured prompt template | `/* ... */` block in `PART B & C` |
| Part B & C — reference solution | `WITH q4_balances AS (...)` first query |
| Part D — refined solution | `WITH q4_balances AS (...)` second query |

---

## Expected Learning Outcome
You can now reliably translate any DBA ticket or business requirement into a structured prompt that generates production-quality SQL. You have a working `lab_01.sql` file containing the weak prompt baseline, the structured solution, and the refined version with business classifications — ready to use as a personal prompt template reference.
