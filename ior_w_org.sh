#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_org_onlyior.txt'

annot="out_org_onlyior"
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
for proc in 8 16 32 64 128 256
do
#  case $proc in
#    8) size_order="512m 1g 2g 4g";;
#    16) size_order="256m 512m 1g 2g";;
#    32) size_order="128m 256m 512m 1g";;
#    64) size_order="64m 128m 256m 512m";;
#    128) size_order="32m 64m 128m 256m";;
#    256) size_order="16m 32m 64m 128m";;
#  esac
  for b_size in 64m 128m 256m 512m 1024m
  do
    for iter in {1..3}
    do
      sleep 0.1
      echo '' >> $filepath
#      insmod $path
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
      mpirun -np ${proc} ior -w -t 1m -b ${b_size} -F -o /mnt/pm963/testfile | grep 'Max Write' >> ${filepath}
#      rmmod mymodule 
#      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 4s
    done
  done
done

echo "DONE"
cat ${filepath} >> $logpath
echo "DONE" >> ${filepath}
exit 0
