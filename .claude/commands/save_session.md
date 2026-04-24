Save a search-optimized summary of this session to TWO locations:
1. **Project-local**: `claude_sessions/` in the current project directory
2. **Google Drive**: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/project/claude_session/{YYYY-MM-DD}/`

---

## Step 1: Detect context

- **Project name**: Run `git remote get-url origin 2>/dev/null | sed 's|.*/||;s|\.git$||'`. If no git remote, use the current directory basename. If the working directory is `$HOME`, use `_no-project`.
- **Date**: Today's date (YYYY-MM-DD).
- **Session number**: Let `n_drive` = highest existing `session_<k>_*` in the Drive date folder (0 if none); let `n_local` = highest existing `{date}_s<k>_*` in project-local `claude_sessions/` (0 if none). Set `N = max(n_drive, n_local) + 1`. This keeps both copies in sync even if one location was out of sync.
- **Slug**: Generate a 3-5 word kebab-case slug summarizing the session's main topic.
- **Latest commit**: Run `git log -1 --format='%H' 2>/dev/null`. Use `none` if the working directory is not a git repo or `git log` returns no commits.

## Step 2: Create directories if needed

- `mkdir -p claude_sessions/` in the project directory (skip if working_dir is $HOME).
- `mkdir -p "/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/project/claude_session/{YYYY-MM-DD}/"`.

## Step 3: Write the session file

Filenames:
- **Google Drive**: `session_{N}_{slug}.md` (the date is already in the parent folder).
- **Project-local**: `{YYYY-MM-DD}_s{N}_{slug}.md` (flat folder, so the date goes in the filename).

**YAML quoting**: In the frontmatter, any string containing spaces, colons, commas, brackets, or other YAML-special characters MUST be double-quoted. In particular, `files_touched` and `working_dir` frequently contain spaces (e.g. `"My Drive"` paths). Example: `files_touched: ["260422_foo.R", "path with space/bar.qmd"]`. Plain alphanumeric tokens (tags like `HTE`, `mice`) need no quoting.

Use this structure exactly:

```
---
date: YYYY-MM-DD
session: N
slug: {slug}
type: {one of: coding, analysis, literature-review, manuscript, debugging, design}
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
**Action**: What was done? (Include key code changes in fenced code blocks with a language tag, e.g. ```r)
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
- **Category**: {one of: r-patterns, methods, statistics, tooling, data-management}
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

Tags MUST cover ALL six categories below. Target 30–80 terms total; the category-coverage constraint is authoritative — if covering all six pushes the count above 80, keep all six and accept the count.

Categories:
- Topic keywords (disease, drug names, clinical context)
- Statistical methods (model names, test names, estimation approaches)
- R packages and key functions used
- Reference citekeys or author-year identifiers
- File names edited
- Concepts discussed or decided upon

Include both abbreviations and full terms (e.g., both `HTE` and `treatment-effect-heterogeneity`). Optimize for grep/ripgrep search.

## Step 5: Save to both locations

1. Write the file to `claude_sessions/{YYYY-MM-DD}_s{N}_{slug}.md` in the project directory. **Skip this step if `working_dir` is `$HOME`** — in that case only the Drive copy is written, which is intentional.
2. Write an identical-body copy (only the filename differs) to: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/project/claude_session/{YYYY-MM-DD}/session_{N}_{slug}.md`
