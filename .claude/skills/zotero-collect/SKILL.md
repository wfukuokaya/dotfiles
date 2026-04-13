---
name: zotero-collect
description: Search Zotero library and create a collection from matching articles. Use when the user wants to build a Zotero collection on a topic.
argument-hint: <topic or collection description>
---

Create a Zotero collection from a topic description.

## Your task

The user wants to create a Zotero collection. Their request: $ARGUMENTS

Follow these steps:

### Step 1: Search Zotero

Use the `mcp__zotero__zotero_search_items` tool to search the user's Zotero library with multiple relevant queries (both `titleCreatorYear` and `everything` modes). Run at least 4-6 parallel searches with different keyword combinations to cast a wide net.

For PDF-only results (attachments without metadata), use `mcp__zotero__zotero_item_fulltext` to identify what paper they belong to, then find the parent item key via `mcp__zotero__zotero_item_metadata`.

### Step 2: Present the article list

Present the curated list to the user as a table grouped by theme, showing: key, authors, year, title. Ask the user to confirm or modify the list.

### Step 3: Save keys file and run zotero-collect

Once confirmed:

1. Save a keys file to `~/Zotero/collection-keys/<slugified_name>.txt` with one key per line (include `# Author Year - description` comments).

2. Run the CLI tool:
```
zotero-collect "<Collection Name>" ~/Zotero/collection-keys/<slugified_name>.txt
```

This will automatically close Zotero, add items, and reopen it.

### Important notes

- Only include items that actually exist in the user's Zotero library (verified via search).
- If the user provides specific item keys directly, skip the search step.
- The collection name should be concise and descriptive.
- Always confirm the list with the user before running zotero-collect.
