# Cron

Manages cronjobs from this repo instead of editing `/etc/crontab` or `crontab -e` directly.

## Directory Structure

```
src/cron/
├── apply.sh       # Installs cron jobs
├── explain.sh     # Lists all jobs with descriptions
├── list.sh        # Shows currently installed crontabs
├── jobs/
│   ├── user/      # Jobs installed to user crontab
│   └── system/    # Jobs installed to root crontab (requires sudo)
└── README.md
```

The `jobs/` directory is gitignored since job definitions are machine-specific.

## Job File Format

Each `.cron` file needs metadata headers followed by the cron expression:

```
# @name: my-job
# @desc: What this job does
# @schedule: Human-readable schedule
0 * * * * /path/to/command
```

## Usage

```bash
# List all job definitions and their descriptions
cron-explain

# Preview and install user jobs
cron-apply user

# Preview and install system jobs (requires sudo)
sudo cron-apply system

# Preview and install all jobs
sudo cron-apply all

# View currently installed crontabs
cron-list user
cron-list system
cron-list all
```

## Adding a Job

1. Create a `.cron` file in `jobs/user/` or `jobs/system/`
2. Add `@name`, `@desc`, and `@schedule` headers
3. Add the cron expression and command
4. Run `cron-explain` to verify it shows up
5. Run `cron-apply user` or `sudo cron-apply system` to install
