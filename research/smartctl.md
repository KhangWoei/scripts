# smartctl

## Overview

`smartctl` is a command-line tool for querying and controlling SMART (Self-Monitoring, Analysis, and Reporting Technology) data on storage drives. Part of the `smartmontools` package.

## Installation

```
yay -S smartmontools
```

## Common Usage

### Check drive health
```
sudo smartctl -H /dev/sda
```
Returns PASSED or FAILED based on the drive's self-assessment.

### View all SMART attributes
```
sudo smartctl -A /dev/sda
```
Shows raw attribute data like temperature, power-on hours, reallocated sectors, etc.

### Full drive info and attributes
```
sudo smartctl -a /dev/sda
```
Combines device info, health status, and all attributes.

### Scan for drives
```
sudo smartctl --scan
```
Lists all detected drives that support SMART.

## Key Attributes to Watch

| Attribute              | What it means                              |
|------------------------|--------------------------------------------|
| Reallocated_Sector_Ct  | Bad sectors remapped, high = drive failing  |
| Power_On_Hours         | Total hours the drive has been powered on   |
| Temperature_Celsius    | Current drive temperature                   |
| Wear_Leveling_Count    | SSD lifespan remaining (SSD only)           |
| Current_Pending_Sector | Unstable sectors waiting to be remapped      |

## NVMe Drives

For NVMe drives the flags differ slightly:
```
sudo smartctl -a /dev/nvme0
```

Key NVMe fields:
- **Percentage Used** — estimated lifespan consumed
- **Available Spare** — remaining spare blocks
- **Temperature** — current operating temp
- **Data Units Read/Written** — total I/O over the drive's lifetime

## Running Self-Tests

### Short test (~2 minutes)
```
sudo smartctl -t short /dev/sda
```

### Long test (can take hours)
```
sudo smartctl -t long /dev/sda
```

### View test results
```
sudo smartctl -l selftest /dev/sda
```

## Notes

- Requires root/sudo for most operations
- Not all drives support every SMART attribute
- A PASSED health check does not guarantee the drive is healthy, check individual attributes
- A non-zero Reallocated_Sector_Ct or Current_Pending_Sector is a warning sign worth investigating
