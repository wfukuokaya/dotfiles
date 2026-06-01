import sys, json, os
from datetime import datetime

cache = os.path.expanduser("~/.cache/ccstatusline/usage.json")
try:
    with open(cache) as f:
        data = json.load(f)
    reset_at = data.get("sessionResetAt", "")
    if not reset_at:
        sys.exit(0)
    dt = datetime.fromisoformat(reset_at)
    local = dt.astimezone()
    h = local.hour % 12 or 12
    ampm = "am" if local.hour < 12 else "pm"
    if local.minute == 0:
        print(f"{h}{ampm}")
    else:
        print(f"{h}:{local.minute:02d}{ampm}")
except Exception:
    sys.exit(0)
