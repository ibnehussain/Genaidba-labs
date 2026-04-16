# Lab 10 — Comment → Stored Procedure Generation

---

## Objective
Practice comment-driven development in VS Code — writing SQL comments that describe intent and letting GitHub Copilot generate the full stored procedure implementation.

## Prerequisites
- GitHub Copilot

---

## Instructions

Create a  new file called `lab10_proc.sql` in VS Code. Type the following comments exactly as shown, pressing **Tab** after each comment line to accept Copilot's suggestion before typing the next comment.

> **Important:** Type slowly and let Copilot suggest after each line. Do NOT paste the whole block at once.

---

## Exercise: Generate `proc_process_month_end_close`

Type this comment block(copy/paste) one line at a time:

```sql
-- ============================================================
-- Stored Procedure: proc_process_month_end_close
-- Purpose: Performs end-of-month financial close processing
-- 
-- Actions performed:
--   1. Validates all open transactions are in a final status
--      (COMPLETED or CANCELLED) — raise error if any PENDING remain
--   2. Calculates month-end account balances for all active accounts
--      from the Transactions table and stores in MonthEndBalances
--   3. Flags the processed month as CLOSED in the AccountingPeriods table
--   4. Generates a summary row in ClosingSummary table with:
--      - total transactions processed, total debit, total credit, net balance
--   5. Sends a notification row to the NotificationQueue table
--
-- Parameters:
--   p_close_month    IN NUMBER  — Month number (1-12)
--   p_close_year     IN NUMBER  — 4-digit year
--   p_processed_by   IN VARCHAR2 — Username running the close
--   p_result         OUT NUMBER  — 0 = Success, -1 = Error
--
-- Error Handling:
--   EXCEPTION block with transaction rollback
--   Errors logged to ErrorLog
--
-- Tables touched:
--   Transactions, AccountingPeriods, MonthEndBalances,
--   ClosingSummary, NotificationQueue, ErrorLog
-- ============================================================

CREATE OR REPLACE PROCEDURE proc_process_month_end_close
```

**At this point — press Tab and watch Copilot generate the procedure parameters and body.**

---

## Reviewing the Generated Output

After Copilot generates the procedure, check:

**Structure Checklist:**
- [ ] Parameters match specification (p_close_month, p_close_year, p_processed_by, p_result)
- [ ] EXCEPTION block present
- [ ] ROLLBACK in exception handler present
- [ ] Steps 1–5 are implemented (may need refining)
- [ ] Error logging to ErrorLog present
- [ ] p_result := 0 / p_result := -1 present
- [ ] Header comment block present

---

## Refine with Follow-Up Prompts

If any part is missing or needs improvement, use targeted follow-up prompts in Copilot Chat:

**If error handling is incomplete:**
```
Add an EXCEPTION block that handles the error, rolls back the transaction,
logs to ErrorLog with columns: error_time TIMESTAMP, error_message VARCHAR2(4000),
proc_name VARCHAR2(200), error_line NUMBER.
Then re-raise using RAISE_APPLICATION_ERROR(-20001, SQLERRM).
```

**If the validation logic (Step 1) is missing:**
```
Add Step 1: Before processing, check if any transactions exist in 
Transactions with status = 'PENDING' for the given month and year.
If any exist, use RAISE_APPLICATION_ERROR(-20002,
  'Month-end close failed: ' || v_pending_count || ' pending transactions remain')
and set p_result := -1.
```

---

## Bonus: Add Unit Test Comments

After the procedure, add these comments and let Copilot generate test scripts:

```sql
-- ============================================================
-- Unit Tests for proc_process_month_end_close
-- Test 1: Happy path — process a clean month with no pending transactions
-- Test 2: Error path — attempt to close a month with pending transactions
-- Test 3: Duplicate close — attempt to close an already-closed period
-- ============================================================
```

---

## Expected Learning Outcome
You can use comment-driven development in VS Code to generate complete, well-structured stored procedures — with built-in documentation — by writing intent comments and accepting Copilot completions.
