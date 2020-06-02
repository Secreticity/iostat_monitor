#!/bin/bash

#out_mod4mix

echo `/bin/syscfg/syscfg /d biossettings "Memory Mode" | grep "Current" | cut -d: -f2`
echo `/bin/syscfg/syscfg /d biossettings "Cluster Mode" | grep "Current" | cut -d: -f2`

#sh ./iostat.sh &
#echo "iostat.sh running..."
#sleep 0.5

#sar 1 -o /tmp/data >> /home/kau/jwbang/200320/out_mod4mix_iostat.txt 2>&1 &
#echo "sar (iostat) running..."
#sleep 0.5

sh ./profiling_iormix.sh &
echo "profiling_iormix.sh running..."
sleep 0.5

exit 0
