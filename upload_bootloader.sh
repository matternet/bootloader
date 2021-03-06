#!/bin/bash
#
# Upload bootloader firmware to a board.
# The bootloader binary (.../main.elf) must already exist.
#
# Usage examples:
#   $ ./upload_bootloader.sh openocd_v2-1.cfg com.matternet.rfid_access_1.0
#   $ ./upload_bootloader.sh openocd_v2-1.cfg com.matternet.battery_bay_2.0


usage="$(basename "$0") [-h] <cfg-file> <board-name> -- upload bootloader firmware to a board"


# Parse and verify command-line args
if [ "$1" == "-h" ]; then
  echo "Usage: $usage"
  exit 0
fi

cfgfile=$1
board=$2

if [ ! -f $cfgfile ]; then
    echo "ERROR: Config file doesn't exist: $cfgfile"
    exit 1
fi

builddir="build/${board}_bl/bin"
fwfile=${builddir}/main.elf
if [ ! -f $fwfile ]; then
    echo "ERROR: Firmware file doesn't exist: $fwfile"
    exit 1
fi


# Run the upload command
openocd -f ${cfgfile} -d2 -c "program ${fwfile} verify reset exit"
