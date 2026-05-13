---
description: Monthly finance import — batch process CSV exports and regenerate dashboard
---

# /ledger — Monthly Finance Import

**Goal**: Import bank CSV exports, generate vault notes, and update the dashboard.

## Privacy Rule

**Do NOT read financial data files during this workflow.** This means:
- Do NOT read `networth-history.json`, account notes, monthly rollups, or `dashboard.html`
- Do NOT examine the full import output — it contains balances and transaction totals
- The ONLY financial data the AI should see is uncategorized vendor descriptions (step 3)
- The user reviews all financial summaries themselves via the browser dashboard

## Steps

// turbo-all

1. **Drop files**: User places downloaded bank CSV/XLSX exports into the vault imports folder.

2. **Run batch import** (silently — output goes to log file):
   ```bash
   node c:\HQ\ledger\import.js --batch > c:\HQ\ledger\output\import.log 2>&1
   ```
   After the command completes, report only whether it succeeded or failed (check exit code).
   **Do NOT read or display the log file** — it contains account balances and transaction totals.

3. **Review uncategorized vendors** (privacy-safe):
   ```bash
   node c:\HQ\ledger\import.js --uncategorized-only
   ```
   This outputs ONLY vendor description strings — no dollar amounts or balances.
   - If uncategorized vendors are found, present each description to the user and ask what category it belongs to.
   - Update `c:\HQ\ledger\config\categories.json` with new keywords based on user answers.
   - If any keywords were added, delete the affected `*-other.md` notes from the vault monthly folder and re-run step 2, then re-run this step.
   - Only proceed once the user confirms they're satisfied with the categorization.

4. **Cleanup imports** (only after review is complete):
   ```bash
   node c:\HQ\ledger\import.js --cleanup-only
   ```

5. **View dashboard**: Open the dashboard in the browser for the user to review:
   ```bash
   start c:\HQ\ledger\output\dashboard.html
   ```
   The user reviews their financial data directly — the AI does not read or summarize it.

6. **Check Obsidian**: Remind the user to verify data in `Budget.base`, `NetWorth.base`, or `Accounts.base`.

## Single File Import

```bash
node c:\HQ\ledger\import.js path/to/file.csv --account "Account Name" > c:\HQ\ledger\output\import.log 2>&1
```

## Supported Banks

Auto-detected by CSV headers — no configuration needed:

| Bank | Accounts |
|---|---|
| Scotiabank | Chequing, Savings |
| Scotia Visa | Momentum VISA Infinite |
| PC Financial | Spending, Savings, Mastercard |
| EQ Bank | Savings (HISA) |
| Servus | Credit Union |
| Servus Mortgage | Mortgage (loan) |
| Questrade | RRSP, LIRA, RESP (XLSX balance snapshot) |
