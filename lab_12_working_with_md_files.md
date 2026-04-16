# Lab 12 — Working with Markdown Files in VS Code

---

## Objective
Learn to use VS Code's Markdown features alongside GitHub Copilot to create and maintain professional DBA documentation — runbooks, schema docs, and prompt libraries.

## Prerequisites
- GitHub Copilot 

## Why Markdown for DBAs?

- **Runbooks:** Document procedures that humans can read and Copilot can reference
- **Schema docs:** See Lab 03 — AI-generated, version-controlled
- **Prompt libraries:** See Lab 08 — reusable prompt templates
- **Change logs:** Track schema changes over time with readable history
- **`#file:` context:** Reference your `.md` files in Copilot Chat for context

---

## Part A — VS Code Markdown Basics

### Preview Mode
1. Create a new file: `my_runbook.md`
2. Press `Ctrl+Shift+V` to open **Markdown Preview**
3. Or split the editor: right-click the tab → *Open Preview to the Side*

### Useful Markdown for DBAs

````markdown
# H1 — Document Title
## H2 — Major Section  
### H3 — Sub-section

**Bold text** for emphasis
`inline code` for column names, table names, function names
```sql  
-- Code blocks for SQL
SELECT * FROM Customers;
```

| Column | Type | Description |
|--------|------|-------------|
| cust_id | INT | Primary key |

> Blockquote for important notes or warnings

- [ ] Checkbox for checklists (great for validation steps)
- [x] Completed checkbox

````

---

## Part B — Generate a Runbook with Copilot

In Copilot Chat, submit:

```
Generate a professional DBA runbook in markdown format for this task:

Task: Oracle Monthly Index Maintenance

Include:
1. Overview section (purpose, when to run, who runs it, estimated duration)
2. Prerequisites checklist
3. Step-by-step procedure with Oracle SQL/DBMS_STATS commands for each step
4. Verification steps (how to confirm success)
5. Rollback/Recovery section (what to do if it fails)
6. Common issues and solutions

Format: Clean markdown with headers, code blocks for SQL, 
checkboxes for steps, warning blockquotes for critical steps.
```

**Copy the generated markdown into `my_runbook.md` and preview it.**

---

## Part C — Reference MD Files in Copilot

With `my_runbook.md` open in VS Code, try this in Copilot Chat:

```
#file:my_runbook.md

Based on this runbook, generate a PowerShell script that automates 
steps 3 and 4 using the sqlcmd command-line tool. 
Include logging to a text file with timestamps.
```

> This demonstrates how your markdown documentation becomes live context for further AI generation — creating a virtuous cycle.

---

## Part D — Create a Schema Change Log

In a new file `schema_changelog.md`, use this template:

````markdown
# Schema Change Log — [Your Database Name]

## Version 2.4.0 — 2024-01-15

### Changes
| Object | Change Type | Description | Author |
|--------|-------------|-------------|--------|
| Customers | ADD COLUMN | Added `referral_code VARCHAR2(20) NULL` | DBA Team |
| Orders | ADD INDEX | Created idx_orders_status_date | DBA Team |

### Migration Script
```sql
-- Applied: 2024-01-15 02:30 UTC
ALTER TABLE Customers ADD referral_code VARCHAR2(20) NULL;
CREATE INDEX idx_orders_status_date ON Orders(status, order_date);
```

### Rollback Script
```sql
DROP INDEX idx_orders_status_date ON Orders;
ALTER TABLE Customers DROP COLUMN referral_code;
```
````

Now ask Copilot:
```
#file:schema_changelog.md

Based on this change log format, generate an entry for the following change:
Adding a new table DiscountCodes (code_id NUMBER PRIMARY KEY, code VARCHAR2(20) UNIQUE,
discount_pct NUMBER(5,2), valid_from DATE, valid_to DATE, is_active NUMBER(1,0))
with a corresponding rollback script.
```

---

## Tips for Markdown + Copilot Workflow

| Tip | How |
|-----|-----|
| Reference files in chat | `#file:schema.md` in your chat prompt |
| Use headers as structure | Copilot uses document structure as context |
| Keep SQL in code blocks | Copilot extracts and reuses fenced SQL blocks |
| Add `<!-- TODO: -->` comments | Copilot can find and complete TODOs |

---

## Expected Learning Outcome
You can create, edit, and preview professional DBA documentation in VS Code, and reference your markdown files as live context in Copilot Chat — creating an integrated documentation-and-generation workflow.
