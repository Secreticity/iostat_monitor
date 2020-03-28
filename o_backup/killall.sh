#!/bin/bash

sudo kill -9 `pidof sh ./iostat.sh`
sudo kill -9 `pidof sh ./profiling.sh`
sudo kill -9 `pidof sh ./r_profiling.sh`
sudo kill -9 `pidof sh ./n_profiling.sh`
sudo kill -9 `pidof sadc`

exit 0
