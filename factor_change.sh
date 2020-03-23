#!/bin/bash

sed -i -e 's/define JW_FACTOR \([0-9]\+\)/define JW_FACTOR '${1}'/g' /home/kau/jwbang/linux-5.2.8_final/include/linux/mmzone.h
cat /home/kau/jwbang/linux-5.2.8_final/include/linux/mmzone.h | grep -E 'define JW_FACTOR'

exit 0
