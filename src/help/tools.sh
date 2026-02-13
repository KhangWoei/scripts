#!/bin/bash
# @name: help-tools
# @desc: Lists useful system monitoring tools and their descriptions

declare -A tools 

tools["atop"]="Comprehensive system performance monitor showing CPU, memory, disk, and network metrics"
tools["iftop"]="Real-time network bandwidth usage monitor for specific network interfaces"
tools["nvtop"]="Interactive GPU monitoring tool displaying usage, memory, and temperature metrics"
tools["iotop"]="Real-time disk I/O bandwidth monitor showing per-process disk activity"
tools["csysdig"]="Advanced system call tracer for deep process and container inspection"
tools["htop"]="Interactive process viewer with CPU, memory, and system load monitoring"
tools["btop"]="Modern resource monitor with CPU, memory, disk, network, and process info"
tools["perf"]="Linux performance analysis toolkit for CPU profiling and system tracing"
tools["wavemon"]="Wireless network monitor displaying signal strength and connection quality"

echo "SYSTEM MONITORING TOOLS REFERENCE"
echo "=================================="
{
    echo "TOOL|DESCRIPTION"
    for tool in ${!tools[@]}; do
        echo "$tool|${tools[$tool]}"
    done
} | column -t -s '|'
