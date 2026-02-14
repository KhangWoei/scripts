# systemd Timers

On systemd-based systems, **systemd timers** are the preferred way to schedule recurring tasks. They replace cron with tighter system integration.

A timer requires two unit files:

## Service unit (`~/.config/systemd/user/backup.service`)

Defines what to run:

```ini
[Unit]
Description=Run backup script

[Service]
ExecStart=/home/user/.bin/backup-script
```

## Timer unit (`~/.config/systemd/user/backup.timer`)

Defines when to run it:

```ini
[Unit]
Description=Run backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

## Managing timers

```
systemctl --user enable --now backup.timer   # enable and start
systemctl --user list-timers --all           # list all timers
systemctl --user status backup.timer         # check timer status
journalctl --user -u backup.service          # view logs
```

## Advantages over cron

| Feature                  | cron                     | systemd timers             |
|--------------------------|--------------------------|----------------------------|
| Dependency management    | None                     | Full systemd dependency graph |
| Missed run handling      | Skipped silently         | `Persistent=true` catches up |
| Logging                  | Mail or manual redirect  | Built-in journald integration |
| Resource control         | None                     | cgroups, CPU/memory limits |
| Calendar expressions     | 5-field format           | Flexible `OnCalendar` syntax |
| Randomized delay         | Not supported            | `RandomizedDelaySec`       |
| Per-user jobs            | `crontab -e`             | `systemctl --user`         |

## OnCalendar syntax

systemd uses a more readable format:

```
OnCalendar=daily                    # midnight every day
OnCalendar=weekly                   # midnight every Monday
OnCalendar=Mon,Fri *-*-* 09:00:00  # 9am on Mondays and Fridays
OnCalendar=*-*-* *:00/15:00        # every 15 minutes
```

Test expressions with:

```
systemd-analyze calendar "Mon,Fri *-*-* 09:00:00"
```

