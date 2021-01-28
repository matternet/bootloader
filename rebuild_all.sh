#!/bin/bash
#
# Rebuild bootleader firmware for all boards that we care about.
# Any existing (stale) binaries are deleted before building anything.

declare -a ALL_BOARDS=("com.matternet.carriage_2.0"
                       "com.matternet.payload_bay_1.0"
                       "com.matternet.battery_bay_v1_1.0"
                       "com.matternet.battery_bay_2.0"
                       "com.matternet.handover_1.0"
                       "com.matternet.hangar_v2_1.0"
                       "com.matternet.rfid_access_1.0"
                       "com.matternet.ucann_1.0"
                       "com.matternet.bmu-B_1.0"
                       "com.matternet.external_led_1.0"
                       )


# Delete any pre-existing copies of build targets
for i in ${!ALL_BOARDS[@]}; do
    board=${ALL_BOARDS[$i]}
    builddir="build/${board}_bl/bin"
    echo "rm -f $builddir/main.*"
    rm -f ${builddir}/main.*
done


# Build each board target
for i in ${!ALL_BOARDS[@]}; do
    board=${ALL_BOARDS[$i]}
    make BOARD=${board}
done


# Verify Build Success
num_errors=0
for i in ${!ALL_BOARDS[@]}; do
    board=${ALL_BOARDS[$i]}
    builddir="build/${board}_bl/bin"

    outfile="${builddir}/main.elf"
    if [ ! -f $outfile ]; then
        echo "ERROR: Expected output file doesn't exist: $outfile"
        ((num_errors=num_errors+1))
    fi

    outfile="${builddir}/main.bin"
    if [ ! -f $outfile ]; then
        echo "ERROR: Expected output file doesn't exist: $outfile"
        ((num_errors=num_errors+1))
    fi
done


# Cleanup and report errors
if (( $num_errors > 0 )); then
    echo "TOTAL ERRORS: $num_errors"
    exit 1   # TODO: Better error codes?
fi
