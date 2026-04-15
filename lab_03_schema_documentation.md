# Lab 03 — Generate Schema Documentation Summary
**Day:** 1 | **Duration:** 10 minutes | **Difficulty:** Beginner

---

## Objective
Use GitHub Copilot Chat to automatically generate clear, professional markdown documentation for a database schema.

## Prerequisites
- GitHub Copilot Chat enabled in VS Code

---

## Background

Schema documentation is one of the most time-consuming DBA tasks — and one of the most neglected. GenAI can generate complete, structured documentation in seconds.

---

## Sample Schema

```sql
CREATE TABLE Customers (
    cust_id       NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cust_name     VARCHAR2(100) NOT NULL,
    email         VARCHAR2(150) UNIQUE NOT NULL,
    phone         VARCHAR2(20)  NULL,
    region        VARCHAR2(50)  NOT NULL,
    status        VARCHAR2(20)  DEFAULT 'ACTIVE' NOT NULL,
    created_date  TIMESTAMP     DEFAULT SYSDATE NOT NULL,
    modified_date TIMESTAMP     NULL
);

CREATE TABLE Products (
    product_id    NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name  VARCHAR2(200) NOT NULL,
    category      VARCHAR2(100) NOT NULL,
    unit_price    NUMBER(10,2)  NOT NULL,
    stock_qty     NUMBER        DEFAULT 0 NOT NULL,
    is_active     NUMBER(1,0)   DEFAULT 1 NOT NULL
);

CREATE TABLE Orders (
    order_id      NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cust_id       NUMBER        NOT NULL REFERENCES Customers(cust_id),
    order_date    DATE          NOT NULL,
    status        VARCHAR2(20)  DEFAULT 'PENDING' NOT NULL,
    total_amount  NUMBER(15,2)  NOT NULL,
    notes         VARCHAR2(500) NULL
);

CREATE TABLE OrderItems (
    item_id       NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id      NUMBER        NOT NULL REFERENCES Orders(order_id),
    product_id    NUMBER        NOT NULL REFERENCES Products(product_id),
    quantity      NUMBER        NOT NULL,
    unit_price    NUMBER(10,2)  NOT NULL,
    line_total    NUMBER(12,2)  GENERATED ALWAYS AS (quantity * unit_price) VIRTUAL
);
```

---

## Part A — Generate Table Documentation

Submit this prompt to Copilot Chat:

```
You are a technical writer specialising in database documentation.
Generate professional markdown documentation for the following Oracle 19c schema.

For each table include:
1. A 2–3 sentence description of the table's business purpose
2. A markdown table listing all columns with: Column Name | Data Type | Nullable | Description
3. Primary Key and Foreign Key relationships
4. Any virtual (computed) columns and what they calculate
5. Default values and their business meaning

Schema:
[paste all 4 CREATE TABLE statements above]

Output format: Clean markdown, suitable for a Confluence or GitHub wiki page.
```

---

## Part B — Generate ERD Description

Follow up with:

```
Based on these 4 tables, write a plain English description of the 
Entity Relationship Diagram (ERD):
1. Describe each relationship (one-to-many, many-to-many, etc.)
2. Describe the data flow: how an order is created from a customer 
   selecting products
3. Identify any missing tables that would typically exist in this schema 
   (e.g., for a full e-commerce system)
```

---

## Part C — Generate Data Dictionary Entry

```
Create a data dictionary entry for the 'status' column that appears
in both Customers and Orders tables.

For each table's status column, document:
- All valid values
- What each value means
- Allowed transitions (e.g., PENDING → CONFIRMED → SHIPPED)
- Who/what system typically sets each value

Make reasonable assumptions for an e-commerce system.
```

---

## Bonus — Auto-Generate INSERT Examples

```
Generate example INSERT statements for all 4 tables that demonstrate 
a realistic scenario: a customer placing an order for 2 different products.
Include realistic but fictional data. Add comments explaining each insert.
```

---

## Debrief Questions

1. How long would it have taken you to write this documentation manually?
2. What assumptions did Copilot make that were reasonable? Were any wrong?
3. How would you use this in a real project? (Version control, Confluence, README?)

---

## Expected Learning Outcome
You can now generate complete database documentation — table descriptions, data dictionaries, ERD narratives — in minutes instead of hours, using structured Copilot prompts.
