#!/bin/bash

sudo kill -9 `pidof sh ./iostat.sh`
sudo kill -9 `pidof sh ./profiling.sh`
sudo kill -9 `pidof sadc`

exit 0
