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

Start a detached tmux session in a target project and run Codex resume:

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
start             Start detached tmux session and run Codex command
send              Send text (default: continue) to an existing tmux session
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

## Notes

- `systemd --user` is recommended because `Persistent=true` can catch up missed runs.
- If `systemd --user` is unavailable, use `--scheduler cron`.
- Script writes runtime files under `~/.local/state/codex-autocontinue`.
