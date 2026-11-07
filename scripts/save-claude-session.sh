#!/bin/zsh
# save-claude-session.sh  —  file a Claude Code session into the Ark under a nickname.
#
#   save-claude-session.sh <nickname>                     # most recently active session
#   save-claude-session.sh <nickname> <session-id>        # a specific session (full id or first 8 chars)
#   save-claude-session.sh <nickname> <path/to/file.jsonl>
#   add --export <file.md> to file a Markdown written by /export alongside it
#   add --trim to cut tool results to 40 lines each (default keeps everything)
#
# Writes  ~/Ark/Archive/claude-sessions/<nickname>/
#           <id>.jsonl      raw transcript, byte for byte (resumable with `claude --resume <id>`)
#           transcript.md   full readable rendering: your messages, Claude's replies, every tool call and result
#           export.md       the /export file, if given
#           meta.json       title, dates, cwd, counts
#           subagents/      task and subagent outputs that belong to the session, if any
# Re-running with the same nickname refreshes the files in place (the session keeps growing until it ends).
# Appends one line to ~/Ark/Archive/claude-sessions/INDEX.md and mirrors to the drive if it is mounted.
set -euo pipefail

ARK="${ARK:-$HOME/Ark}"
DEST_ROOT="$ARK/Archive/claude-sessions"
PROJECTS="$HOME/.claude/projects"
DRIVE="/Volumes/My Passport/Ark/Archive/claude-sessions"

nick="" src="" export_md="" full=1
while [ $# -gt 0 ]; do
  case "$1" in
    --export) export_md="$2"; shift 2;;
    --trim) full=0; shift;;
    --full) full=1; shift;;
    -h|--help) sed -n '2,18p' "$0"; exit 0;;
    *) if [ -z "$nick" ]; then nick="$1"; else src="$1"; fi; shift;;
  esac
done
[ -n "$nick" ] || { echo "usage: save-claude-session.sh <nickname> [session-id|file.jsonl] [--export file.md] [--trim]" >&2; exit 1; }
case "$nick" in */*|.*) echo "nickname must be a plain folder name, e.g. ark-organizer" >&2; exit 1;; esac

# resolve the source jsonl
if [ -z "$src" ]; then
  src="$(ls -t "$PROJECTS"/*/*.jsonl 2>/dev/null | head -1)"
  [ -n "$src" ] || { echo "no sessions found under $PROJECTS" >&2; exit 1; }
elif [ ! -f "$src" ]; then
  match="$(ls "$PROJECTS"/*/"$src"*.jsonl 2>/dev/null | head -1)"
  [ -n "$match" ] || { echo "no session matching '$src' under $PROJECTS" >&2; exit 1; }
  src="$match"
fi
src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
id="$(basename "$src" .jsonl)"

mkdir -p "$DEST_ROOT"
# render transcript.md + meta.json with python; it prints the folder name it chose
folder="$(python3 -I - "$src" "$DEST_ROOT" "$full" "$nick" <<'PY'
import json, sys, re, os, datetime, pathlib
src, root, full, nick = sys.argv[1], sys.argv[2], sys.argv[3] == "1", sys.argv[4]
MAXL = None if full else 40
title = None; cwd = None; first_ts = last_ts = None; cost = None
turns = []          # (role, text) in order
users = assistants = tools = compactions = 0
def ts(o):
    t = o.get("timestamp");  return t
def trim(s, n=MAXL):
    if s is None: return ""
    lines = s.rstrip("\n").split("\n")
    if n and len(lines) > n:
        return "\n".join(lines[:n]) + f"\n… [{len(lines)-n} more lines]"
    return "\n".join(lines)
tool_names = {}
for line in open(src, encoding="utf-8", errors="replace"):
    try: o = json.loads(line)
    except Exception: continue
    t = o.get("type")
    if t == "ai-title": title = o.get("aiTitle") or title; continue
    if t == "cost-state": cost = o; continue
    if t not in ("user", "assistant"): continue
    if o.get("isSidechain"): continue
    cwd = cwd or o.get("cwd")
    if ts(o): first_ts = first_ts or ts(o); last_ts = ts(o)
    m = o.get("message") or {}
    c = m.get("content")
    if t == "user":
        if o.get("isCompactSummary"):
            compactions += 1
            text = c if isinstance(c, str) else "\n".join(b.get("text","") for b in c if b.get("type")=="text")
            turns.append(("compaction", text)); continue
        if isinstance(c, str):
            if o.get("isMeta"): continue
            users += 1; turns.append(("user", c)); continue
        for b in c or []:
            bt = b.get("type")
            if bt == "text":
                txt = b.get("text","")
                if txt.startswith("<system-reminder>") or o.get("isMeta"): continue
                users += 1; turns.append(("user", txt))
            elif bt == "tool_result":
                rc = b.get("content")
                if isinstance(rc, list): rc = "\n".join(x.get("text","") for x in rc if x.get("type")=="text")
                turns.append(("result", trim(rc or ""), tool_names.get(b.get("tool_use_id"), "tool")))
            elif bt == "image":
                turns.append(("user", "[image pasted]"))
    else:
        for b in c or []:
            bt = b.get("type")
            if bt == "text" and b.get("text","").strip():
                assistants += 1; turns.append(("assistant", b["text"]))
            elif bt == "tool_use":
                tools += 1
                name = b.get("name",""); inp = b.get("input") or {}
                tool_names[b.get("id")] = name
                desc = inp.get("description") or ""
                if name == "Bash": body = inp.get("command","")
                elif name in ("Read",): body = inp.get("file_path","")
                elif name in ("Edit","Write"): body = inp.get("file_path","")
                else: body = json.dumps(inp, ensure_ascii=False)[:800]
                turns.append(("tool", name, desc, trim(body, None if full else 30)))
title = title or "untitled session"
def day(t): return (t or "")[:10]
folder = nick
out = pathlib.Path(root) / folder; out.mkdir(parents=True, exist_ok=True)
with open(out / "transcript.md", "w", encoding="utf-8") as f:
    f.write(f"# {title}\n\n")
    f.write(f"- session: `{os.path.basename(src)[:-6]}`\n- started: {first_ts}\n- last message: {last_ts}\n- cwd: `{cwd}`\n")
    f.write(f"- turns: {users} from the user, {assistants} replies, {tools} tool calls, {compactions} context compactions\n")
    if cost: f.write(f"- cost: ${cost.get('totalCostUSD',0):.2f}\n")
    f.write(f"\nResume with: `claude --resume {os.path.basename(src)[:-6]}` (run from `{cwd}` on a machine where the jsonl is back under ~/.claude/projects/).\n\n---\n\n")
    for tr in turns:
        k = tr[0]
        if k == "user": f.write(f"## User\n\n{tr[1].strip()}\n\n")
        elif k == "assistant": f.write(f"## Claude\n\n{tr[1].strip()}\n\n")
        elif k == "compaction": f.write(f"## Context compaction (summary of everything above)\n\n{tr[1].strip()}\n\n")
        elif k == "tool":
            _, name, desc, body = tr
            f.write(f"**{name}**" + (f": {desc}" if desc else "") + "\n\n")
            if body.strip(): f.write(f"```\n{body}\n```\n\n")
        elif k == "result":
            if tr[1].strip(): f.write(f"<details><summary>{tr[2]} result</summary>\n\n```\n{tr[1]}\n```\n\n</details>\n\n")
meta = {"nickname": nick, "session_id": os.path.basename(src)[:-6], "title": title, "started": first_ts, "last_message": last_ts,
        "cwd": cwd, "user_turns": users, "assistant_turns": assistants, "tool_calls": tools, "compactions": compactions,
        "cost_usd": (cost or {}).get("totalCostUSD"), "source": src, "saved_at": datetime.datetime.now().isoformat(timespec="seconds")}
(out / "meta.json").write_text(json.dumps(meta, indent=2))
print(folder)
PY
)"
dest="$DEST_ROOT/$folder"
cp -p "$src" "$dest/$id.jsonl"
# subagent / task outputs that belong to this session, if any
[ -d "${src%.jsonl}" ] && rsync -a "${src%.jsonl}/" "$dest/subagents/" 2>/dev/null || true
if [ -n "$export_md" ]; then
  [ -f "$export_md" ] || { echo "export file not found: $export_md" >&2; exit 1; }
  cp -p "$export_md" "$dest/export.md"
fi

title="$(python3 -I -c 'import json,sys;print(json.load(open(sys.argv[1]))["title"])' "$dest/meta.json")"
started="$(python3 -I -c 'import json,sys;print((json.load(open(sys.argv[1]))["started"] or "")[:10])' "$dest/meta.json")"
line="- **$nick** — $title (started $started, session \`$id\`) → [transcript]($nick/transcript.md)"
touch "$DEST_ROOT/INDEX.md"
if grep -qF "**$nick**" "$DEST_ROOT/INDEX.md"; then
  tmp="$(mktemp)"; grep -vF "**$nick**" "$DEST_ROOT/INDEX.md" > "$tmp"; echo "$line" >> "$tmp"; mv "$tmp" "$DEST_ROOT/INDEX.md"
else
  echo "$line" >> "$DEST_ROOT/INDEX.md"
fi

echo "saved -> $dest"
ls -la "$dest" | sed 1d
if [ -d "$(dirname "$DRIVE")" ]; then
  mkdir -p "$DRIVE" && rsync -rlt --modify-window=2 "$DEST_ROOT/" "$DRIVE/" && echo "mirrored -> $DRIVE"
else
  echo "drive not mounted; run again (or rsync ~/Ark) later to mirror"
fi
echo "resume later with:  claude --resume $id"
