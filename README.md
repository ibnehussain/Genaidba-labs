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

## Labs Overview

| Lab | File | Description |
|-----|------|-------------|
| Lab 01 | [lab_01_dba_ticket_to_sql.md](lab_01_dba_ticket_to_sql.md) | Convert a DBA support ticket to SQL |
| Lab 01 SQL | [lab_01.sql](lab_01.sql) | SQL scripts for Lab 01 |
| Lab 02 | [lab_02_explain_execution_plan.md](lab_02_explain_execution_plan.md) | Explain SQL execution plans using Copilot |
| Lab 03 | [lab_03_schema_documentation.md](lab_03_schema_documentation.md) | Generate schema documentation with Copilot |
| Lab 04 | [lab_04_natural_language_to_sql.md](lab_04_natural_language_to_sql.md) | Natural language to SQL conversion |
| Lab 05 | [lab_05_improve_prompt.md](lab_05_improve_prompt.md) | Prompt engineering best practices |

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
- [GitHub Copilot Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [GitHub Copilot Chat Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
- [Prompt Engineering for GitHub Copilot](https://docs.github.com/en/copilot/using-github-copilot/prompt-engineering-for-github-copilot)
