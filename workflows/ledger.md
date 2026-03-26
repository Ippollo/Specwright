---
description: Monthly finance import — batch process CSV exports and regenerate dashboard
---

# /ledger — Monthly Finance Import

**Goal**: Import bank CSV exports, generate vault notes, and update the dashboard.

## Steps

// turbo-all

1. **Drop files**: Place your downloaded bank CSV/XLSX exports into `C:\Workspace\KB\50_Finance\imports\`.

2. **Run batch import** (no cleanup yet):
   ```bash
   node c:\HQ\ledger\import.js --batch
   ```
   This will:
   - Auto-detect each bank from CSV headers
   - Import Questrade XLSX balance snapshots
   - Generate category notes + monthly rollups in `70_Finance/monthly/`
   - Update account balances in `70_Finance/accounts/`
   - Regenerate `ledger/output/dashboard.html`

3. **Review "other" expenses** (**ALWAYS DO THIS — do not skip**):
   - Read the `⚠️ UNCATEGORIZED "OTHER" EXPENSES` section from the import output.
   - **Present each uncategorized description to the user** and ask what category it belongs to.
   - Update `c:\HQ\ledger\config\categories.json` with new keywords based on user answers.
   - If any keywords were added, delete the affected `*-other.md` notes and re-run step 2.
   - Only proceed once the user confirms they're satisfied with the categorization.

4. **Cleanup imports** (only after review is complete):
   ```bash
   node c:\HQ\ledger\import.js --cleanup-only
   ```

5. **View dashboard**: Open the dashboard in your browser:
   ```bash
   start c:\HQ\ledger\output\dashboard.html
   ```

6. **Check Obsidian**: Open `Budget.base`, `NetWorth.base`, or `Accounts.base` in the vault to verify data.

## Single File Import

```bash
node c:\HQ\ledger\import.js path/to/file.csv --account "Account Name"
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
