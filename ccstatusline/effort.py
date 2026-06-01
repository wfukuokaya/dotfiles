import sys, json, re, os, glob

ANSI_RE = re.compile(r"(?:\x1b|\\u001[bB])\[[0-9;]*m")

data = json.load(sys.stdin)
tp = data.get("transcript_path", "")

# 1) Env var Claude Code actually honors; overrides settings.json effortLevel.
effort = (os.environ.get("CLAUDE_CODE_EFFORT_LEVEL") or os.environ.get("CLAUDE_EFFORT") or "").strip().lower()

# 2) Transcript marker written when effort is changed mid-session.
if not effort and tp:
    try:
        with open(tp) as f:
            for line in reversed(f.readlines()):
                clean = ANSI_RE.sub("", line)
                m = re.search(r"with (low|medium|high|xhigh|max) effort", clean, re.IGNORECASE)
                if m:
                    effort = m.group(1).lower()
                    break
    except Exception:
        pass

# 3) Fallback: effortLevel in Claude settings.
if not effort:
    for p in [os.path.expanduser("~/.claude/settings.json")] + glob.glob(os.path.expanduser("~/.claude/projects/*/settings.local.json")) + [
        os.path.expanduser("~/.claude/settings.local.json"),
    ]:
        try:
            s = json.load(open(p))
            if "effortLevel" in s:
                effort = s["effortLevel"].lower()
                break
        except Exception:
            pass

print((effort or "medium").capitalize())
