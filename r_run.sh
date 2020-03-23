#!/bin/bash

echo `/bin/syscfg/syscfg /d biossettings "Memory Mode" | grep "Current" | cut -d: -f2`
echo `/bin/syscfg/syscfg /d biossettings "Cluster Mode" | grep "Curent" | cut -d: -f2`

echo "*** READ MODE ***"

sh ./iostat.sh &
echo "iostat.sh running..."
sleep 0.5

sar 1 1000 -o /tmp/data >> out_org_iostat.txt 2>&1 &
echo "sar (iostat) running..."
sleep 0.5

sh ./r_profiling.sh &
echo "profiling.sh running..."
sleep 0.5

exit 0