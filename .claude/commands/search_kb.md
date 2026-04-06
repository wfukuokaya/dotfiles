Search the knowledge base for past sessions, nuggets, and topics.

Search query: $ARGUMENTS

If no query is provided, read INDEX.md and present a summary of all sessions and nuggets.

---

## Search locations

Base path: `/Users/fukuokaya/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base/`

Also search project-local `claude_sessions/` if it exists in the current directory.

## Search strategy

Perform ALL of the following searches in parallel, then synthesize results:

### 1. INDEX.md scan
Read `INDEX.md` and find rows matching the search query in the Session or Key Tags columns.

### 2. Session tag search
Use Grep to search for the query terms in YAML frontmatter `tags:` lines across all `sessions/**/*.md` files.

### 3. Full-text session search
Use Grep to search session body text (outside frontmatter) for the query across `sessions/**/*.md`.

### 4. Nugget search
Use Grep to search across `nuggets/**/*.md` for the query.

### 5. Topic search
Use Grep to search across `topics/**/*.md` for the query (if any topic files exist).

### 6. Project-local search
Search `claude_sessions/*.md` in the current project directory if it exists.

## Output format

Present results grouped by relevance:

### Direct matches
For each matching file (up to 10), show:
- **File**: relative path from knowledge-base root
- **Date / Project**: from frontmatter
- **Match context**: the 2-3 lines surrounding the match
- **Summary**: Read the file's `## Goal` or title to provide a one-line summary

### Related nuggets
If nuggets matched, present their full content (nuggets are short).

### Suggestions
If matched sessions contain "Knowledge nuggets", "Next steps", or "Gaps and open questions" entries relevant to the query, highlight those.

Limit to 10 most relevant results. If more than 10 match, list the remaining as file paths only.
