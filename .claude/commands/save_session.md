Save a search-optimized summary of this session to TWO locations:
1. **Project-local**: `claude_sessions/` in the current project directory
2. **Google Drive KB**: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base/sessions/{project}/`

---

## Step 1: Detect context

- **Project name**: Run `git remote get-url origin 2>/dev/null | sed 's|.*/||;s|\.git$||'`. If no git remote, use the current directory basename. If the working directory is `$HOME`, use `_no-project`.
- **Date**: Today's date (YYYY-MM-DD).
- **Session number**: Check BOTH output directories for existing files matching `{date}_s*` and use the next available number N.
- **Slug**: Generate a 3-5 word kebab-case slug summarizing the session's main topic.
- **Latest commit**: Run `git log -1 --format='%H' 2>/dev/null` (use `none` if not a git repo or no commits this session).

## Step 2: Create directories if needed

- `mkdir -p claude_sessions/` in the project directory (skip if working_dir is $HOME).
- `mkdir -p` the Google Drive `sessions/{project}/` path.

## Step 3: Write the session file

Use filename format: `{YYYY-MM-DD}_s{N}_{slug}.md`

Use this structure exactly:

```
---
date: YYYY-MM-DD
session: N
slug: {slug}
type: coding | analysis | literature-review | manuscript | debugging | design
project: {project-name}
working_dir: {absolute path}
commit: {hash or "none"}
tags: [keyword1, keyword2, ...]
files_touched: [file1.R, file2.qmd, ...]
tools_used: [R, git, shell, zotero, python, quarto, ...]
---

# {Descriptive title}

## Goal
One sentence: what was the objective of this session?

## What was done
### 1. {Brief title}
**Context**: Why was this needed?
**Action**: What was done? (Include key code changes in blockquotes)
**Result**: What was the outcome?
**References**: @citekeys or filenames (if applicable)

### 2. ...

## Key data points
- Bullet list of important numbers, thresholds, parameter values discovered or confirmed

## Decisions and rationale
| Decision | Rationale |
|----------|-----------|
| ... | ... |

## Knowledge nuggets
Reusable learnings from this session. Each nugget is a self-contained insight useful in other projects or contexts. Include at least one nugget per session. If nothing was novel, write a brief nugget about the approach or pattern used.

### Nugget: {concise title}
- **Category**: r-patterns | methods | statistics | tooling | data-management
- **Tags**: [specific searchable terms]
- **Insight**: 2-4 sentences explaining the reusable knowledge
- **Example**: (optional code snippet or reference)

### Nugget: ...

## Gaps and open questions
- Bullet list of unresolved issues or things to investigate (omit section if none)

## Next steps
- Bullet list of planned follow-up actions (omit section if none)
```

## Step 4: Tags

Tags MUST include ALL of the following categories (aim for 30-60 terms):
- Topic keywords (disease, drug names, clinical context)
- Statistical methods (model names, test names, estimation approaches)
- R packages and key functions used
- Reference citekeys or author-year identifiers
- File names edited
- Concepts discussed or decided upon

Include both abbreviations and full terms (e.g., both `HTE` and `treatment-effect-heterogeneity`). Optimize for grep/ripgrep search.

## Step 5: Save to both locations

1. Write the file to `claude_sessions/{date}_s{N}_{slug}.md` in the project directory (skip if working_dir is $HOME).
2. Write an IDENTICAL copy to: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base/sessions/{project}/{date}_s{N}_{slug}.md`

## Step 6: Update INDEX.md

Open `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base/INDEX.md`.

If the file does not exist, create it with this header:

```markdown
# Knowledge Base Index

Last updated: YYYY-MM-DD

## Sessions

| Date | S# | Project | Type | Session | Key Tags |
|------|-----|---------|------|---------|----------|
```

Append one row to the Sessions table:

```
| {date} | {N} | {project} | {type} | [{slug}](sessions/{project}/{date}_s{N}_{slug}.md) | {top 5 tags, comma-separated} |
```

Update the "Last updated" date at the top. Do NOT rewrite existing rows.

## Step 7: Extract nuggets

For EACH nugget in the "Knowledge nuggets" section, save a standalone file:

- Path: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base/nuggets/{category}/{nugget-slug}.md`
- Format:

```markdown
---
title: {nugget title}
category: {category}
tags: [...]
source_session: sessions/{project}/{date}_s{N}_{slug}.md
date_discovered: YYYY-MM-DD
---

# {nugget title}

{insight text}

## Example

{code or reference, if any}

## Context

Discovered in [{session slug}](../../sessions/{project}/{date}_s{N}_{slug}.md).
```

If a nugget file with the same slug already exists, append a `## See also` link to the existing file rather than overwriting.

After saving nuggets, append rows to the INDEX.md Nuggets table. If the Nuggets table does not exist yet, create it:

```markdown
## Nuggets

| Category | Nugget | Source Session | Tags |
|----------|--------|----------------|------|
```

Then append:

```
| {category} | [{nugget-title}](nuggets/{category}/{nugget-slug}.md) | {project}/{date}_s{N} | {nugget tags, comma-separated} |
```
