#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_mod4mix.txt'
mixrw=50

annot="out_mod4mix"
#path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

#annot="MODIFIED2"
path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"

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
for proc in 32 64 128 256
do
  case $proc in
#    8) size_order="512m 1g 2g 4g";;
#    16) size_order="256m 512m 1g 2g";;
    32) size_order="128m 256m 512m 1g";;
    64) size_order="64m 128m 256m 512m";;
    128) size_order="32m 64m 128m 256m";;
    256) size_order="16m 32m 64m 128m";;
    12) size_order="340m 680m 1360m 2720m";;
    24) size_order="170m 340m 680m 1360m";;
    48) size_order="85m 170m 340m 680m";;
    96) size_order="43m 85m 170m 340m";;
  esac
  for b_size in $size_order
  do
    for iter in {1..3}
    do
      sleep 0.1
      echo '' >> $filepath
      insmod $path
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
#      mpirun -np ${proc} ior -w -r -t 1m -b ${b_size} -F -o /mnt/pm963/testfile | grep 'Max Read' >> ${filepath}
      fio --directory=/mnt/pm963 --name=testfile --direct=0 --rw=readwrite --bs=1m --size=${b_size} --numjobs=${proc} --group_reporting --rwmixwrite ${mixrw} | grep '[DE]: io' >> ${filepath}
      rmmod mymodule 
      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 4s
    done
  done
done

echo "DONE"
cat ${filepath} >> $logpath
echo "DONE" >> ${filepath}
exit 0
