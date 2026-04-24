---
name: empirical-prompt-tuning
description: Improve an agent-facing text instruction (a skill, slash command, task prompt, CLAUDE.md section, or code-gen prompt) by handing it to an unbiased executor, evaluating from both sides (executor self-report + caller-side metrics), and iterating until gains plateau. Use after authoring or substantially revising a skill of your own, or when an agent's behavior is off and you suspect the ambiguity is in the instruction, not the model.
---

# Empirical Prompt Tuning

The author of a prompt cannot judge its quality. What reads as "clear" to you often jams another agent. **Hand it to an unbiased executor, evaluate from both sides, and iterate** — that is the core of this skill. Do not stop until gains plateau.

This skill is written so that you can use it to improve **your own skills** (or any other agent-facing text). The workflow is the same whether the target is a skill in `~/.claude/skills/`, a slash command, a task prompt, a section of CLAUDE.md, or a code-generation prompt.

## When to use

- Just authored or substantially revised a skill / slash command / task prompt of your own.
- An agent is not behaving as expected and you want to check whether the caller-side instruction is ambiguous.
- Hardening a high-stakes instruction (a frequently invoked skill, the core prompt of an automation).

Do not use:
- One-shot, throwaway prompts (evaluation cost is not justified).
- When the goal is not success rate but reflecting the author's subjective taste.

## Workflow

0. **Iteration 0 — description/body consistency check** (static, no dispatch needed)
   - Read what the frontmatter `description` promises (triggers, use cases).
   - Read what the body actually covers.
   - If they diverge, align `description` or body before iter 1.
   - Example: `description` says "navigation / form filling / data extraction" but the body is only a `npx playwright test` CLI reference. That is a divergence.
   - Skipping this lets the subagent "reinterpret" the body to match the description, producing a false positive where the skill appears to meet requirements that it does not.

1. **Baseline setup**: freeze the target prompt and prepare two artifacts.
   - **Evaluation scenarios**, 2–3 of them (one median + 1–2 edge). Each must be a realistic situation in which the target prompt would actually be invoked.
   - **Requirements checklist** (for accuracy calculation). For each scenario, list 3–7 items the deliverable must satisfy. Accuracy % = items satisfied / total items. Freeze this up front; do not move the goalposts.

2. **Bias-free read**: have a blank-slate executor read the instruction. **Dispatch a new subagent via the Task tool.** Do not self-reread (you structurally cannot view text you just wrote as an outsider). When running multiple scenarios in parallel, issue multiple Agent calls in a single message. For environments without dispatch, see the "Environment constraints" section.

3. **Execution**: feed the subagent a prompt that follows the **subagent launch contract** below. The executor runs the scenario, produces the deliverable, and returns a self-report.

4. **Two-sided evaluation**: from the returned result, record the following.
   - **Executor self-report** (extracted from the subagent's report body): unclear points / discretionary gap-fills / places where a template did not fit.
   - **Caller-side metrics** (judgment rules defined here once; other sections reference this):
     - Pass/fail: pass (✓) **only if every `[critical]`-tagged requirement is ✓**. If even one is ✗ or partial, fail (✗). Labels are binary: ✓ / ✗.
     - Accuracy (% of checklist items met; ✓ = full, ✗ = 0, partial = 0.5, summed over total items).
     - Step count (use the `tool_uses` field in the Task tool's returned usage meta, as-is. Include Read/Grep; do not exclude them).
     - Duration (`duration_ms` from the Task tool's usage meta).
     - Retry count (number of times the subagent redid the same decision; extract from the self-report, caller cannot measure this).
     - **On failure, add a one-liner in the "Unclear points" section identifying which `[critical]` item was missed** (for root-cause tracing).
   - The requirements checklist must contain **at least one** `[critical]`-tagged item (zero makes the pass criterion vacuous). Do not add or remove `[critical]` tags after the fact.

5. **Diff application**: make the minimum edit that eliminates the unclear points. One theme per iteration (related micro-edits are fine; unrelated edits go in the next round).
   - **Before editing, state explicitly which checklist / judgment-text item the edit is meant to satisfy.** Edits inferred from axis names often miss (see "How edits propagate" below).

6. **Re-evaluation**: dispatch a **new** subagent and repeat 2 → 5. Do not reuse the prior agent — it has learned from the previous round. Increase parallelism only if single-stream iteration is not converging.

7. **Convergence check**: stop when "two consecutive iterations with zero new unclear points AND metrics improving below threshold (see below)" holds. For high-stakes prompts, require three consecutive.

## Evaluation axes

| Axis | How to measure | Meaning |
|---|---|---|
| Pass/fail | Did the executor produce the intended deliverable? (binary) | Floor |
| Accuracy | % of checklist met | Degree of partial success |
| Step count | Tool calls / decision steps | Waste in the instruction |
| Duration | Executor's `duration_ms` | Proxy for cognitive load |
| Retries | Same decision redone | Signal of ambiguity |
| Unclear points (self-report) | Bullet list from executor | Qualitative fuel for edits |
| Discretionary gap-fills (self-report) | Places where the instruction was silent | Surfaces implicit spec |

**Weighting**: qualitative (unclear points + gap-fills) is primary, quantitative (time + step count) is supportive. Chasing only time reduction starves the prompt.

### Qualitative reading of `tool_uses`

Accuracy alone hides structural problems. Use `tool_uses` as a **cross-scenario relative value** to expose them:

- If one scenario shows **3–5× more** `tool_uses` than others, the skill is **index-heavy and not self-contained**. The executor is being forced into references-descent.
- Typical pattern: all scenarios run at 1–3 tool_uses except one that hits 15+ → no recipe for that scenario exists in the skill, and the executor is cross-searching references/.
- Remedy: in iter 2, add an inline minimum working example or guidance on *when* to read references to the top of SKILL.md. `tool_uses` drops sharply.

Even at 100% accuracy, `tool_uses` imbalance justifies another iteration. "100% accuracy, we are done" misses structural defects.

### How edits propagate (conservative / overshoot / zero-shot)

Edit → effect is not linear. Pre-estimates fall into three patterns:

- **Conservative swing** (estimate > actual): one edit tried to move multiple axes; only one moved. "Multi-axis shots usually miss."
- **Overshoot** (estimate < actual): one structural piece of information (e.g., command + config + expected output bundled) satisfied multiple judgment texts at once. "Bundled info is structurally multi-axis-effective."
- **Zero-shot** (estimate > 0, actual = 0): an edit inferred from an axis name did not land on any judgment text. "Axis names and judgment texts are different things."

To stabilize this, **make the subagent verbalize which judgment text each edit is meant to satisfy, before applying the edit**. Without grounding at the threshold-text level, estimates are noisy. When introducing a new axis, specify the judgment criterion at threshold-text granularity ("all items listed explicitly", "minimum working example in full") — enough for the subagent to decide whether the item scores 2 points.

## Subagent launch contract

The prompt handed to the executor takes the following structure. This is the input contract of two-sided evaluation.

```
You are an executor reading <target prompt name> blank-slate.

## Target prompt
<paste the full target prompt, or give the path and have the executor Read it>

## Scenario
<one-paragraph setup of the scenario>

## Requirements checklist (what the deliverable must satisfy)
1. [critical] <floor-level item>
2. <normal item>
3. <normal item>
...
(Judgment rules are defined in the "Workflow / 4. Two-sided evaluation / Caller-side metrics" section. At least one [critical] is required.)

## Task
1. Execute the scenario by following the target prompt; produce the deliverable.
2. When done, return the report in the structure below.

## Report structure
- Deliverable: <produced artifact or execution summary>
- Requirement outcomes: for each item, ✓ / ✗ / partial (with a reason)
- Unclear points: places in the target prompt that jammed you, phrasing you had to guess at (bullets)
- Discretionary gap-fills: places the instruction was silent and you filled in yourself (bullets)
- Retries: how many times you redid the same decision, and why
```

The caller extracts the self-report sections, pulls `tool_uses` / `duration_ms` from the Task tool's usage meta, and fills the evaluation table.

## Environment constraints

In environments where a fresh subagent cannot be dispatched (you are already running as a subagent, Task tool is disabled, etc.), **do not apply this skill**.
- Alternative 1: ask the parent session's user to open a separate Claude Code session and hand the prompt over there.
- Alternative 2: abandon evaluation and explicitly report "empirical evaluation skipped: dispatch unavailable".
- **NOT OK**: self-rereading as a substitute (bias invalidates the result).

**Structural-review mode**: when you only want to check the **textual consistency and clarity** of a skill / prompt, not run it empirically, switch to structural-review mode explicitly. Put "Structural-review mode this time: text consistency check, no execution" at the top of the subagent prompt. The subagent then returns a static review without triggering the environment-constraint skip. Structural review is an *adjunct* to empirical tuning, not a replacement — it cannot count toward consecutive-clear convergence.

## Stopping rules

- **Converged (stop)**: two consecutive rounds meeting **all** of:
  - New unclear points: 0.
  - Accuracy delta from prior round: ≤ +3 points (e.g. plateau at 5% → 8%).
  - Step count delta: within ±10%.
  - Duration delta: within ±15%.
  - **Overfit check**: at the convergence decision, add one previously unused hold-out scenario and re-evaluate. If accuracy drops ≥ 15 points from the recent mean, you have overfit — go back to baseline scenario design and add more edge cases.
- **Diverging (suspect the design)**: if after 3+ iterations new unclear points are not decreasing, the prompt's design approach is likely wrong. Stop patching and rewrite the structure.
- **Resource cutoff**: when the remaining improvement no longer justifies the cost, stop (ship at 80 points).

## Reporting format

At each iteration, record and present to the user as:

```
## Iteration N

### Changes from prior round
- <one-line description of the edit>

### Results (per scenario)
| Scenario | Pass/fail | Accuracy | steps | duration | retries |
|---|---|---|---|---|---|
| A | ✓ | 90% | 4 | 20s | 0 |
| B | ✗ | 60% | 9 | 41s | 2 |

### New unclear points (this round)
- <Scenario B>: [critical] item N missed — <one-line reason>   # mandatory on failure
- <Scenario B>: <other note>
- <Scenario A>: (none new)

### New discretionary gap-fills (this round)
- <Scenario B>: <what was filled in>

### Proposed next edit
- <one-line minimum edit>

(Convergence: X consecutive clears so far / Y iterations until stop criterion)
```

## Red flags (watch for rationalizations)

| Rationalization that surfaces | What is actually happening |
|---|---|
| "Rereading it myself gives the same effect" | You cannot "view objectively" text you just wrote. Dispatch a new subagent every time. |
| "One scenario is enough" | One scenario overfits. Two minimum, three preferred. |
| "Got zero unclear points once, we are done" | Could be chance. Require two consecutive. |
| "Let me fix all unclear points at once" | You will not know which edit did the work. One theme per iteration. |
| "Even related micro-edits should go in separate iters" | The opposite trap. "One theme" means one semantic unit. 2–3 related micro-edits in one iter is fine; splitting too finely explodes the iter count. |
| "Metrics look good, I will ignore qualitative feedback" | Time reduction can mean the prompt was starved. Qualitative is primary. |
| "Faster to rewrite from scratch" | Only after 3+ rounds without progress. Before that, it is an escape. |
| "Let me reuse the same subagent" | It has already learned. Always dispatch fresh. |

## Common failure modes

- **Scenarios too easy / too hard**: either kills signal. One median of the real usage, one edge.
- **Metrics-only reading**: chasing only time reduction strips out explanations and makes the prompt brittle.
- **Too many changes per iteration**: you lose the ability to attribute "which edit moved the needle". One theme per iter.
- **Tuning scenarios to the edits**: simplifying the scenario so unclear points disappear is inverted — the scenario is ground truth, not a knob.

## Specifics for your own skills

When the target is a skill you authored:

- Place the target at `~/.claude/skills/<name>.md` (or the plugin-namespaced path) so the subagent can Read it directly.
- Iteration 0 is especially load-bearing: a skill's frontmatter `description` is the *only* thing the triggering logic sees. If the body does not deliver on that description, the skill fires in wrong contexts or fails to fire in right ones.
- When composing scenarios, include at least one that matches the `description` triggers exactly and one that is adjacent but should *not* trigger the skill — this exposes over- or under-triggering.
- Requirements checklists for skill-authoring outputs often include: "follows the file-layout the skill prescribes", "uses only tools the skill allows", "produces the artifact named in the skill's output section". At least one of these should be `[critical]`.
- After convergence, re-run iter 0 once more: edits made during iteration can re-introduce description/body drift.

## Related

- `superpowers:writing-skills` — TDD approach for skill authoring. Structurally the same loop as this skill (subagent → baseline → edit → rerun).
- `retrospective-codify` — locking in learnings after a task. Use this skill *during* prompt development; retrospective-codify *after* task completion.
- `superpowers:dispatching-parallel-agents` — etiquette for running multiple scenarios in parallel.
