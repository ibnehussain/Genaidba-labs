# GenAI for DBA Labs

Hands-on lab files for the **GenAI for DBA** training session. These labs cover using GitHub Copilot to assist with SQL development, execution plan analysis, schema documentation, and prompt engineering.

---

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) installed
- A GitHub account with an active [GitHub Copilot](https://github.com/features/copilot) subscription (Individual, Business, or Enterprise)

---

## Setting Up GitHub Copilot in VS Code

### Step 1: Install the GitHub Copilot Extension

1. Open **Visual Studio Code**.
2. Click the **Extensions** icon in the Activity Bar (`Ctrl+Shift+X`).
3. Search for **GitHub Copilot**.
4. Click **Install** on the extension published by **GitHub**.
5. Also search for and install **GitHub Copilot Chat** for conversational AI assistance.

### Step 2: Sign In to GitHub

1. After installation, click **Sign in to GitHub** when prompted in VS Code.
2. A browser window will open — log in with your GitHub account.
3. Click **Authorize Visual-Studio-Code** to grant access.
4. Return to VS Code — the Copilot icon in the bottom status bar will confirm it is active.

### Step 3: Verify Copilot is Working

1. Open any `.sql` or `.md` file from this repo.
2. Start typing a SQL comment or statement — Copilot suggestions appear as grey ghost text inline.
3. Press `Tab` to accept a suggestion, or `Esc` to dismiss it.

### Step 4: Use Copilot Chat

1. Open Copilot Chat with `Ctrl+Alt+I` or click the **Chat** icon in the Activity Bar.
2. Ask questions about your SQL code, e.g.:
   ```
   Explain this execution plan and suggest index improvements.
   ```
3. Use context helpers to scope your prompts:
   - `#file` — reference a specific file
   - `#selection` — reference highlighted code
   - `@workspace` — ask questions about the entire project

---

## Setting Up GitHub Copilot in IntelliJ IDEA

### Step 1: Install the GitHub Copilot Plugin

1. Open **IntelliJ IDEA**.
2. Go to **Settings/Preferences** → **Plugins**.
3. Search for **GitHub Copilot** and click **Install**.
4. Restart IntelliJ IDEA if prompted.

### Step 2: Sign In to GitHub

1. Open **Tools** → **GitHub Copilot** → **Log in to GitHub**.
2. Follow the browser sign-in flow and authorize IntelliJ IDEA.
3. Return to IntelliJ IDEA and confirm Copilot is connected.

### Step 3: Verify Copilot is Working

1. Open any `.sql` or `.md` file from this repo.
2. Start typing a comment or SQL statement.
3. Accept inline suggestions with `Tab`, or dismiss with `Esc`.

### Step 4: Use Copilot Chat

1. Open the Copilot Chat tool window from the IDE sidebar.
2. Ask questions such as:
   ```
   Explain this query plan and suggest index improvements.
   ```
3. Use file/selection context to get more accurate responses.

---

## Labs Overview

### Day 1 (Labs 1-5)

| Lab | File | Description |
|-----|------|-------------|
| Lab 01 | [lab_01_dba_ticket_to_sql.md](lab_01_dba_ticket_to_sql.md) | Convert a DBA support ticket to SQL |
| Lab 01 SQL | [lab_01.sql](lab_01.sql) | SQL scripts for Lab 01 |
| Lab 02 | [lab_02_explain_execution_plan.md](lab_02_explain_execution_plan.md) | Explain SQL execution plans using Copilot |
| Lab 03 | [lab_03_schema_documentation.md](lab_03_schema_documentation.md) | Generate schema documentation with Copilot |
| Lab 04 | [lab_04_natural_language_to_sql.md](lab_04_natural_language_to_sql.md) | Natural language to SQL conversion |
| Lab 05 | [lab_05_improve_prompt.md](lab_05_improve_prompt.md) | Prompt engineering best practices |

### Day 2 (Labs 6-12)

| Lab | File | Description |
|-----|------|-------------|
| Lab 06 | [lab_06_optimize_slow_query.md](lab_06_optimize_slow_query.md) | Optimize a slow SQL query with Copilot |
| Lab 07 | [lab_07_suggest_indexes.md](lab_07_suggest_indexes.md) | Suggest and evaluate index improvements |
| Lab 08 | [lab_08_prompt_library.md](lab_08_prompt_library.md) | Build a personal DBA prompt library |
| Lab 09 | [lab_09_awr_report_analysis.md](lab_09_awr_report_analysis.md) | Analyze AWR-style data and create action plans |
| Lab 10 | [lab_10_stored_procedure_generation.md](lab_10_stored_procedure_generation.md) | Generate stored procedures from structured comments |
| Lab 11 | [lab_11_copilot_validation_loop.md](lab_11_copilot_validation_loop.md) | Use a validation loop to improve Copilot output quality |
| Lab 12 | [lab_12_working_with_md_files.md](lab_12_working_with_md_files.md) | Work with markdown files as live Copilot context |

---

## Useful Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Accept Copilot suggestion | `Tab` |
| Dismiss suggestion | `Esc` |
| Open Copilot Chat | `Ctrl+Alt+I` |
| Trigger inline suggestion | `Alt+\` |
| View next suggestion | `Alt+]` |
| View previous suggestion | `Alt+[` |

---

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)

- [Prompt Engineering for GitHub Copilot](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)

- [GitHub Status](https://www.githubstatus.com/) — Use this when Copilot sign-in, suggestions, or Chat responses seem unavailable or slow to confirm if there is an ongoing GitHub service incident.
