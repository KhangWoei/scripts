# cron & crontab

`cron` is a time-based job scheduler on Unix systems. It runs as a daemon (`crond`) and executes commands on a schedule defined by the user or system administrator. 

`crontab` (cron table) is the command used to create, view, and edit those schedules.

## Crontab Expression Format

Each line in a crontab follows this format:

```
┌───────────── minute (0–59)
│ ┌───────────── hour (0–23)
│ │ ┌───────────── day of month (1–31)
│ │ │ ┌───────────── month (1–12)
│ │ │ │ ┌───────────── day of week (0–7, 0 and 7 = Sunday)
│ │ │ │ │
* * * * *  command
```

### Special Characters

| Character | Meaning                           | Example            |
|-----------|-----------------------------------|--------------------|
| `*`       | Every value                       | `* * * * *` = every minute |
| `,`       | List of values                    | `0,30 * * * *` = minute 0 and 30 |
| `-`       | Range of values                   | `0 9-17 * * *` = hours 9 through 17 |
| `/`       | Step values                       | `*/15 * * * *` = every 15 minutes |

### Shorthand Schedules

| Shorthand   | Equivalent        |
|-------------|--------------------|
| `@reboot`   | Run once at startup |
| `@hourly`   | `0 * * * *`        |
| `@daily`    | `0 0 * * *`        |
| `@weekly`   | `0 0 * * 0`        |
| `@monthly`  | `0 0 1 * *`        |
| `@yearly`   | `0 0 1 1 *`        |

## Where Cron Jobs Live

### User crontab

Each user has their own crontab, edited with `crontab -e` and stored by the system (typically under `/var/spool/cron/`). These jobs run as that user.

```
crontab -e        # edit your crontab
crontab -l        # list your crontab
crontab -r        # remove your crontab (deletes everything)
```

The `-e` flag opens the crontab in your `$EDITOR`. When saved, `cron` validates the syntax and installs it. `crontab` accepts only a single file, if you pipe content to `crontab -`, it replaces the entire crontab.

### System crontab (`/etc/crontab`)

A system-wide crontab. Has an extra field for the user to run as:

```
* * * * * root /usr/local/bin/some-script
```

### Drop-in directory (`/etc/cron.d/`)

Individual files with the same format as `/etc/crontab` (including the user field). Packages often install jobs here.

### Periodic directories

Some systems also have:
- `/etc/cron.hourly/`
- `/etc/cron.daily/`
- `/etc/cron.weekly/`
- `/etc/cron.monthly/`

Scripts placed here are executed by `run-parts` at the corresponding interval.

## Environment

Cron jobs run with a minimal environment. Common gotchas:

- `PATH` is usually just `/usr/bin:/bin` — use full paths for commands
- No access to user shell config (`.bashrc`, `.zshrc`, etc.)
- No display server — GUI commands will fail
- Output goes to mail by default; redirect to avoid filling the mailbox:
  ```
  0 * * * * /path/to/script > /dev/null 2>&1
  ```

## Logging

Cron logs usually go to the system journal or `/var/log/crond`:

```
journalctl -u crond
```


