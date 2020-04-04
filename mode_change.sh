#!/bin/bash

if [ $# -ne 1 ]; then

  echo "parameter needed!"
  echo "[./mode_change.sh c] : current mode check"
  echo "[./mode_change.sh out_**** ] : change mode for all files"
  exit 1
fi

if [[ $1 == "c" ]]; then
  echo $( cat /home/kau/jwbang/200320/run.sh | head -3 | tail -1 | cut -d'#' -f2 )
  exit 0
else
  sed -i -e 's/'$( cat run.sh | head -3 | tail -1 | cut -d'#' -f2 )'/'${1}'/g' *.py *.sh
  exit 0
fi
