#!/bin/bash

totalsize=12
thread=128
blocksize=1024

output=$( sysbench --test=memory --memory-total-size=$(( totalsize*8589934592 )) --threads=${thread} --memory-block-size=${blocksize} run )
#echo $output

echo 'Throughput:'$( echo $output | cut -d'(' -f4 | cut -d' ' -f1 )  #56
echo 'Latency:'$( echo $output | awk '{print $80}' )
