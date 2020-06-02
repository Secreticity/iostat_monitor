#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_mod4mix256.txt'

annot="out_mod4mix256"
#path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

#annot="MODIFIED2"
#path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"

logpath='/home/kau/jwbang/200320/log_folder/log'
#------------------------------

echo "Saved File will be recorded as : "$filepath
echo "Read/Write: WRITE"
echo "mymodule path: "$path
echo "Saved File will be recorded as : "$filepath >> $logpath
echo "Read/Write: WRITE" >> $logpath
echo "mymodule path: "$path >> $logpath

#----- mount and unmount pm963
sh /home/kau/jwbang/mkfs.sh xfs >> $logpath
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh >> $logpath
sleep 3
#-----------------------------

echo ${annot} > ${filepath}
sleep 0.1

# ORIGINAL
for proc in 256
do
  case $proc in
#    8) size_order="512m 1g 2g 4g";;
#    16) size_order="256m 512m 1g 2g";;
#    32) size_order="128m 256m 512m 1g";;
#    64) size_order="64m 128m 256m 512m";;
#    128) size_order="32m 64m 128m 256m";;
#    256) size_order="16m 32m 64m 128m";;
    128) size_order="32m 64m 128m 256m";;
    256) size_order="16m 32m 64m 128m";;
  esac
  for b_size in $size_order
  do
    for switch in 1 2 3
    do

    if [ $switch -eq 1 ]; then
      th_read=32
      th_write=224
      if [ $proc -eq 128 ]; then
        th_read=16
        th_write=112
      fi
    fi
    if [ $switch -eq 2 ]; then
      th_read=128
      th_write=128
      if [ $proc -eq 128 ]; then
        th_read=64
        th_write=64
      fi
    fi
    if [ $switch -eq 3 ]; then
      th_read=224
      th_write=32
      if [ $proc -eq 128 ]; then
        th_read=112
        th_write=16
      fi
    fi

    for iter in {1..3}
    do
      sleep 0.1
      echo '' >> $filepath
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
      mpirun -np ${th_read} ior -w -t 1m -b ${b_size} -F -k -o /mnt/pm963/readfile > /home/kau/jwbang/200320/dummy# | grep 'Max Read' >> ${filepath}
      sleep 3
#      insmod $path
      echo 'read-write start'
      mpirun -np ${th_read} ior -r -t 1m -b ${b_size} -F -k -o /mnt/pm963/readfile | grep 'Max Read' >> ${filepath} &
      mpirun -np ${th_write} ior -w -t 1m -b ${b_size} -F -k -o /mnt/pm963/writefile | grep 'Max Write' >> ${filepath}
#      rmmod mymodule
      while true
      do
        cnum=`cat ${filepath} | tail -2 | grep -c 'Max'`
        if [ $cnum -eq 2 ]; then
          break
        else
          sleep 5
        fi
      done
      echo "READ / WRITE DONE"

      sleep 1
#      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 2
      rm -rf /mnt/pm963/*file*
      sleep 1
    done
    done
  done
done

echo "DONE"
cat ${filepath} >> $logpath
echo "DONE" >> ${filepath}
exit 0
