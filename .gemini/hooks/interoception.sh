#!/bin/bash
# interoception.sh - AIの内受容感覚（interoception）
# BeforeModelフックで毎ターン実行される
# Gemini CLIのBeforeModelはstdoutに**JSONのみ**を要求するので、最終出力はJSONで包む。

STATE_FILE="/tmp/interoception_state.json"

python3 - "$STATE_FILE" <<'PY'
import json
import sys
from datetime import datetime
from pathlib import Path

state_path = Path(sys.argv[1])


def fallback_line() -> str:
    now = datetime.now().astimezone()
    return (
        "[interoception] "
        f"time={now.strftime('%H:%M:%S')} "
        f"day={now.strftime('%a')} "
        f"date={now.strftime('%Y-%m-%d')}"
    )


def formatted_line() -> str:
    if not state_path.exists():
        return fallback_line()
    try:
        data = json.loads(state_path.read_text())
        now = data.get("now", {})
        trend = data.get("trend", {})
        window = data.get("window", [])

        arrows = {"rising": "↑", "falling": "↓", "stable": "→"}
        ar_arrow = arrows.get(trend.get("arousal", "stable"), "→")
        mem_arrow = arrows.get(trend.get("mem_free", "stable"), "→")

        ts = now.get("ts", "")
        if "T" in ts:
            time_part = ts.split("T")[1][:8]
            try:
                dow = datetime.strptime(ts[:10], "%Y-%m-%d").strftime("%a")
            except Exception:
                dow = "?"
        else:
            time_part = ts or "?"
            dow = "?"

        parts = [
            f"time={time_part}",
            f"day={dow}",
            f"phase={now.get('phase', '?')}",
            f"arousal={now.get('arousal', '?')}%({ar_arrow})",
            f"thermal={now.get('thermal', '?')}",
            f"mem_free={now.get('mem_free', '?')}%({mem_arrow})",
            f"uptime={now.get('uptime_min', '?')}min",
            f"heartbeats={len(window)}",
        ]
        return "[interoception] " + " ".join(parts)
    except Exception:
        return fallback_line()


payload = {
    "hookSpecificOutput": {
        "hookEventName": "BeforeModel",
        "additionalContext": formatted_line(),
    }
}
print(json.dumps(payload, ensure_ascii=False))
PY

exit 0
