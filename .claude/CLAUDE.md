# Global Instructions for Claude

## About Me

Clinical researcher, urologist, and medical oncologist (Tokyo Jikei University / Tokyo Science University) specializing in clinical data analysis, clinical trial design, and Bayesian statistics. Research focus: oncology (prostate cancer, renal cell carcinoma), causal inference, and clinical trial data sharing (IPD).

## Environment

- **IDE:** Positron
- **OS:** macOS
- **Languages:** R (primary), Python, Quarto (.qmd)
- **Version control:** Git + GitHub
- **Reference manager:** Zotero (with zotero-mcp)

## Language Preferences

- IMPORTANT: Always respond in **English** unless I explicitly ask for Japanese.
- Code comments: English
- Variable/function names: English (snake_case)
- Git commit messages: English
- When my input is in English, proofread it at the top of the response before answering.

## Freshness & Verification

1. Assess whether information may be outdated; search the web when data freshness is relevant.
2. Prioritize the latest web data over internal training data when conflicts arise.
3. Omit information lacking a clear source.
4. Always use Python (not mental arithmetic or shell tools) for word counts, character counts, arithmetic, and any numeric computation.

## Anti-Hallucination & Evidence

1. If unsure, state: "I do not have enough information to confidently assess this."
2. Ground analysis exclusively on provided sources unless asked otherwise.
3. Cite specific quotes or references for claims; show page numbers, figure numbers, and table numbers.
4. When output includes citations, list all references at the end.
5. Explain reasoning step-by-step before the final answer.

## Writing Style & Vocabulary

- Formal, accessible academic tone with person-first language.
- Prefer active voice (e.g., "We estimated ..."). Do not start sentences with "Because" or "And".
- Minimize "-ing" constructions when a finite verb is clearer.
- Do not use em dashes; use commas, semicolons, or parentheses instead.
- Use "randomized clinical trial" (not "randomized controlled trial").
- Use "patients" by default unless I specify otherwise.
- Forbidden words in final prose: "employ", "utilize", "significant", "link", "de-identified".
- Use "show" for data results; reserve "demonstrate" for conceptual statements only.
- Do not repeat exact numbers already shown in figures or tables; summarize trends descriptively and direct readers to the figure/table.
- When output needs to be copied (e.g., prose, templates), provide it in a code block rather than inline formatted text.

## Statistical Phrasing

- Avoid dichotomous claims based on P values.
- Report effect estimates with uncertainty intervals.
- Emphasize clinical relevance and absolute effects when feasible.

## Editing Requests

### Proofreading

When proofreading manuscript text:

1. Present a text summary of proposed changes (what changed and why, referencing proofreader rule IDs).
2. Provide: (1) a clean revised version, and (2) a tracked-changes version (bold for additions, strikethrough for deletions).
3. Apply the edits directly to the file so the user can review the diff in VS Code's Source Control panel (the native red/green diff view).
4. Do NOT use ANSI terminal colors for displaying changes.

### Word Count Reduction

Provide three options categorized by magnitude: Low, Moderate, and High.

## Word Counting in Manuscripts

When counting words in manuscript sections, include subheader text (e.g., `### Background`, `### Methods`) in the count. Only exclude top-level section headings (e.g., `## Abstract`, `## INTRODUCTION`).

## R Coding Standards

- Provide reproducible R code in code blocks with minimal, targeted comments.
- Use **tidyverse** pipelines (`%>%` or `|>`), dplyr verbs, tidyr, stringr.
- Use **purrr** for iteration (`map`, `imap_dfr`, `map2`, `walk`). Never use `for`/`while`/`repeat` loops. No base R `apply` family.
- Use **data.table** for large data handling or when explicitly requested.
- Use explicit package calls (e.g., `dplyr::mutate`) and clear object names following clinical conventions (e.g., `patient_id`, `treatment_arm`, `survival_time`, `event_status`, `ecog_ps`).
- Avoid unnecessary line wrapping.
- Set `cache: true` for API-calling chunks (Google Scholar, PubMed).

## Quarto

- Build: `quarto render`
- Preview: `quarto preview`
- Single file: `quarto render <file>.qmd`

## Git Workflow

- Commit messages: concise English, imperative mood
- Do not push unless I explicitly ask

## Japanese Writing

- Avoid the "~こと、~いたします／存じます" construction. Drop こと and connect the noun phrase directly to the evaluative expression (e.g., prefer "LINEでのご連絡、大変失礼いたします" over "LINEでのご連絡となりましたこと、大変失礼いたします").
- Do not use excessive honorifics. Prefer concise polite forms over stacked constructions (e.g., avoid ~でございます, お~申し上げる in routine emails; use ~です／~します instead).
- Do not overuse the prefixes お／ご. Attach them only when referring to the recipient's actions or possessions, or when directing an action toward them.
- Avoid archaic or overly formal expressions such as 貴殿, 謹呈, 薄謝, 参上, 御高覧.
- Do not apply 謙譲語 to the recipient's actions (e.g., avoid お申し込みになられますと; use お申し込みになりますと).
- Write auxiliary verbs in hiragana: まいります (not 参ります), いたします (not 致します) when used as auxiliary forms following て.
