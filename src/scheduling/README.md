# Scheduling

Manages cron jobs and systemd timers from this repo.

## Directory Structure

```
src/scheduling/
├── cron/
│   ├── apply.sh       # Installs cron jobs
│   ├── explain.sh     # Lists all jobs with descriptions
│   ├── list.sh        # Shows currently installed crontabs
│   └── jobs/          # Gitignored, machine-specific
│       ├── user/
│       └── system/
├── systemd/
│   ├── apply.sh       # Installs timer/service pairs
│   ├── explain.sh     # Lists all timers with descriptions
│   ├── list.sh        # Lists systemd timers
│   └── timers/        # Gitignored, machine-specific
│       ├── user/      # → ~/.config/systemd/user/
│       └── system/    # → /etc/systemd/system/
└── README.md
```

## Cron

### Job File Format

Each `.cron` file expects metadata headers followed by the cron expression:

```
# @name: my-job
# @desc: What this job does
# @schedule: Human-readable schedule
0 * * * * /path/to/command
```

### Adding a Job
1. Create a `.cron` file in `jobs/user/` or `jobs/system/`
2. Add `@name`, `@desc`, and `@schedule` headers
3. Add the cron expression and command
4. Run `cron-explain` to verify it shows up
5. Run `cron-apply user` or `sudo cron-apply system` to install

## Systemd Timers

### Timer File Format
Each `.timer` file expects metadata headers above the INI content

```
# @name: orphaned
# @desc: Checks for orphaned packages
# @schedule: Daily at 3am
[Unit]
Description=Check for orphaned packages
...
```

Timers are organized in `timers/<scope>/<name>/` subdirectories, each containing a `<name>.timer` and `<name>.service` pair.

### Adding a Timer
1. Create a directory in `timers/user/<name>/` or `timers/system/<name>/`
2. Add `<name>.timer` with `@name`, `@desc`, and `@schedule` headers followed by the unit content
3. Add `<name>.service` with the corresponding service unit
4. Run `systemd-explain` to verify it shows up
5. Run `systemd-apply user` or `systemd-apply system` to install
