#!/bin/bash

filepath='/home/kau/jwbang/200320/out_mod8p_iostat.txt'
logpath='/home/kau/jwbang/200320/log_folder/log.iostat'

write=0

echo '' > /home/kau/jwbang/200320/out_mod8p.txt
echo '' > $filepath
echo ${filepath} >> $logpath

while true
do
  str=`echo $(cat /home/kau/jwbang/200320/out_mod8p.txt | tail -1)`
  if [[ $str =~ ^P ]]; then
    if [ $write -eq 0 ]; then
      write=1
      echo 'start----' >> $filepath
    fi
    sleep 0.1
  elif [[ $str =~ ^p ]]; then
    if [ $write -eq 1 ]; then
      write=0
      sleep 1
      echo 'end------' >> $filepath
    fi
  elif [[ $str =~ ^D ]]; then
    echo "profiling DONE  --- Shutting DOWN"
    cat ${filepath} >> $logpath
    sudo kill -9 `pidof sadc`
    exit 0
  else
    sleep 0.1
  fi

  #if [ $write -eq 1 ]; then
  #  iostat -c 1 1| tail -2 | cut -d' ' -f 12,16,20,24,28,31 >> $filepath
  #fi
done

exit 0

