#!/bin/bash

sh ./iostat.sh &
echo "iostat.sh running..."
sleep 0.5

sar 1 1000 -o /tmp/data >> out_org_iostat.txt 2>&1 &
echo "sar (iostat) running..."
sleep 0.5

sh ./profiling.sh &
echo "profiling.sh running..."
sleep 0.5

exit 0
