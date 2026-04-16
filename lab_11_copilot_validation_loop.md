# Lab 11 — Prompt → Copilot → Validation Loop

---

## Objective
Practise the full iterative DBA workflow: generate SQL with Copilot, validate it systematically, identify gaps, and refine through follow-up prompts — building a disciplined review habit.

## Prerequisites
- GitHub Copilot 

---

## Background

The Prompt → Copilot → Validation Loop is the core professional workflow:

```
┌─────────────┐    ┌──────────────┐    ┌──────────────────┐
│  Write      │ ─► │  Copilot     │ ─► │  Validate:       │
│  Prompt     │    │  Generates   │    │  Logic, Perf,    │
│             │    │  SQL         │    │  Security, Edge  │
└─────────────┘    └──────────────┘    └────────┬─────────┘
       ▲                                         │
       │            Refine prompt                │
       └─────────────────────────────────────────┘
                (repeat until production-ready)
```

---

## The Task

Generate a stored procedure to transfer funds between two accounts with full transactional integrity.

---

## Round 1 — Initial (Insufficient) Prompt

Submit this deliberately incomplete prompt:

```
Write a PL/SQL procedure to transfer money between two bank accounts.
```

**Observe:** What gaps exist in the generated output?

---

## Round 2 — Structured Prompt

Now submit a properly structured prompt:

```
You are a Senior Oracle DBA responsible for a banking application.

Create procedure proc_transfer_funds with these requirements:

PARAMETERS (all IN unless stated):
- p_from_account_id  IN  NUMBER
- p_to_account_id    IN  NUMBER
- p_amount           IN  NUMBER
- p_transfer_ref     IN  VARCHAR2  — client-provided reference
- p_requested_by     IN  VARCHAR2  — username
- p_result           OUT NUMBER   — 0 = success, -1 = error

BUSINESS RULES:
1. Both accounts must exist and be ACTIVE — error if not
2. p_amount must be > 0 — error if not
3. Source account must have sufficient balance (balance >= p_amount) — error if not
4. Deduct p_amount from source account balance
5. Add p_amount to destination account balance
6. Record the transfer in TransferLog table with:
   - transfer_id (sequence), from_account_id, to_account_id, amount,
     transfer_ref, requested_by, transfer_time, status

SCHEMA:
CREATE TABLE Accounts (
    account_id   NUMBER         NOT NULL PRIMARY KEY,
    account_no   VARCHAR2(20)   NOT NULL UNIQUE,
    customer_id  NUMBER         NOT NULL,
    balance      NUMBER(15,2)   NOT NULL,
    status       VARCHAR2(20)   NOT NULL  -- 'ACTIVE', 'FROZEN', 'CLOSED'
);
CREATE TABLE TransferLog (
    transfer_id      NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    from_account_id  NUMBER         NOT NULL,
    to_account_id    NUMBER         NOT NULL,
    amount           NUMBER(15,2)   NOT NULL,
    transfer_ref     VARCHAR2(50)   NOT NULL,
    requested_by     VARCHAR2(100)  NOT NULL,
    transfer_time    TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    status           VARCHAR2(20)   DEFAULT 'COMPLETED' NOT NULL
);

ERROR HANDLING:
- EXCEPTION block with transaction rollback
- Log errors to ErrorLog
- Use RAISE_APPLICATION_ERROR for each failure condition with unique error codes
- Set p_result := 0 on success, p_result := -1 on error

SECURITY:
- Use bind variables only (no dynamic SQL)
- Validate p_amount is positive
- Check account existence before any data modification

OUTPUT: Complete Oracle PL/SQL procedure with comments
```

---

## Round 3 — Self-Validation Prompt

After Copilot generates the procedure, immediately ask it to review its own output:

```
Review the stored procedure you just generated for these issues:

1. CORRECTNESS: 
   - Does it handle the race condition where two concurrent transfers 
     might overdraw the same account? 
   - What locking strategy does it use?

2. SECURITY:
   - Is there any SQL injection risk?
   - Are all inputs validated before use?

3. ERROR HANDLING:
   - Are all error conditions from the specification handled?
   - Does the EXCEPTION block correctly commit or rollback?

4. EDGE CASES:
   - What happens if p_from_account_id = p_to_account_id?
   - What happens if p_amount has more than 2 decimal places?

For each issue found, provide the fix.
```

---

## Round 4 — Apply Fixes and Final Review

Apply any fixes suggested in Round 3, then do a final check:

```
Final check on the stored procedure:
1. Trace through the logic for this scenario:
   - FromAccount balance = $500
   - Transfer amount = $1,000
   What happens? Does it correctly reject the transfer?

2. Trace through for:
   - Both accounts ACTIVE
   - Amount = $200
   - FromAccount balance = $300
   Does it complete successfully and update both balances correctly?

3. Is the TransferLog insert inside the transaction (so it rolls back on failure)?
```

---

## Validation Loop Summary

Document your loop in the file:
```
ROUND 1: [Prompt quality] → [Issues with output]
ROUND 2: [Improved prompt] → [Better output]
ROUND 3: [Self-validation] → [Issues found]
ROUND 4: [Final verification] → [Production ready? Y/N]
```

---

## Expected Learning Outcome
You have internalised the professional Prompt → Copilot → Validation loop. You never accept first-draft AI output without systematic review, and you use Copilot to help review its own output.
