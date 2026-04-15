-- =============================================================================
-- Lab 01: Convert DBA Ticket -> Prompt -> SQL
-- Ticket #TKT-4821 | Submitted by: Finance Team | Priority: High
-- =============================================================================

-- =============================================================================
-- SCHEMA REFERENCE
-- =============================================================================

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


-- =============================================================================
-- PART A: WEAK PROMPT RESULT
-- Prompt used: "Write a query for customer balance recovery."
-- Paste Copilot output below and observe how it differs from the requirement.
-- =============================================================================

        SELECT
            c.cust_id,
            c.cust_name,
            ab.balance_date,
            ab.balance_amt
        FROM Customers c
        JOIN AccountBalances ab ON c.cust_id = ab.cust_id
        WHERE ab.balance_amt > 0
        ORDER BY ab.balance_date;


-- =============================================================================
-- PART B & C: STRUCTURED PROMPT -> GENERATED SQL
-- =============================================================================

/*
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
*/


-- =============================================================================
-- PART D: REFINED QUERY
-- Added: recovery_amount column and recovery_tier classification
--