# codex-autocontinue

Manage Codex `tmux` sessions and auto-send `continue` on a schedule.

- Command name: `codex-autocontinue`
- Alias: `codex-continue`
- Default scheduler: `systemd --user` timer (`OnCalendar=*:0/30`)
- Optional fallback: `cron`

## Install

```bash
git clone https://github.com/TobeMagic/codex-autocontinue.git
cd codex-autocontinue
./install.sh
```

## Quick start

One command bootstrap (start + schedule-install):

```bash
codex-autocontinue bootstrap --session codex --dir /path/to/project --resume-id xxxx
```

If session already exists, `bootstrap` skips start and only installs/updates the schedule.

Start only (no schedule change):

```bash
codex-autocontinue start --session codex --dir /path/to/project --resume-id xxxx
```

Install periodic auto-continue (default: every 30 minutes, systemd timer):

```bash
codex-autocontinue schedule-install --session codex --dir /path/to/project
```

Send once manually:

```bash
codex-autocontinue send --session codex --dir /path/to/project
```

Tail-like real-time output (no attach needed):

```bash
codex-autocontinue tail --session codex --lines 200
```

If your terminal rendering requires original control sequences:

```bash
codex-autocontinue tail --session codex --raw
```

Check status:

```bash
codex-autocontinue status --session codex
```

Attach to session:

```bash
codex-autocontinue attach --session codex
```

Remove schedule:

```bash
codex-autocontinue schedule-remove --session codex
```

## Commands

```text
bootstrap         Start if needed, then install schedule
start             Start detached tmux session and run Codex command
send              Send text (default: continue) to an existing tmux session
tail              Stream pane output in real time (tail-like)
attach            Attach to tmux session
status            Show tmux + scheduler status
schedule-install  Install systemd/cron schedule
schedule-remove   Remove systemd/cron schedule
version           Print script version
help              Show help
```

## Key options

- `--session <name>`: tmux session name, default `codex`
- `--dir <path>`: working directory to cd before sending/starting
- `--text <text>`: send content, default `continue`
- `--pane <target>`: tmux pane target (for `tail`), default `<session>:0.0`
- `--lines <n>`: backlog line count for `tail`, default `120`
- `--raw`: keep raw ANSI control sequences for `tail`
- `--resume-id <id>`: for default start command
- `--cmd <command>`: override start command
- `--scheduler systemd|cron|all`: scheduler backend (default `systemd`)
- `--on-calendar <expr>`: systemd timer expression (default `*:0/30`)
- `--cron-expr <expr>`: cron expression (default `0,30 * * * *`)
- `--log-file <path>`: cron log file path

## Examples

Custom start command:

```bash
codex-autocontinue start --session codex --dir /path/to/project --cmd "codex resume abc123"
```

Bootstrap with custom scheduler:

```bash
codex-autocontinue bootstrap \
  --session codex \
  --dir /path/to/project \
  --resume-id xxxx \
  --scheduler cron \
  --cron-expr "*/15 * * * *"
```

Cron every 15 minutes:

```bash
codex-autocontinue schedule-install \
  --scheduler cron \
  --cron-expr "*/15 * * * *" \
  --session codex \
  --dir /path/to/project
```

Install both systemd + cron:

```bash
codex-autocontinue schedule-install --scheduler all --session codex --dir /path/to/project
```

Help:

```bash
codex-autocontinue --help
codex-autocontinue start --help
codex-autocontinue help schedule-install
```

## Notes

- `systemd --user` is recommended because `Persistent=true` can catch up missed runs.
- If `systemd --user` is unavailable, use `--scheduler cron`.
- Script writes runtime files under `~/.local/state/codex-autocontinue`.
