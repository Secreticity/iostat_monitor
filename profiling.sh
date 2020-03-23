#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_mod1.txt'

#annot="ORIGINAL"
#path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

annot="MODIFIED8"
path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"
#------------------------------

echo "Saved File will be recorded as : "$filepath
echo "Read/Write: WRITE"
echo "mymodule path: "$path
echo "Saved File will be recorded as : "$filepath >> log
echo "Read/Write: WRITE" >> log
echo "mymodule path: "$path >> log

#----- mount and unmount pm963
sh /home/kau/jwbang/mkfs.sh xfs >> log
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh >> log
sleep 3
#-----------------------------

echo ${annot} > ${filepath}
sleep 0.1

# ORIGINAL
for proc in 8 16 32 64
do
  for b_size in 128m 256m 512m 1024m
  do
    for iter in {1..3}
    do
      sleep 0.1
      echo '' >> $filepath
      insmod $path
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
      mpirun -np ${proc} ior -${rw} -t 1m -b ${b_size} -F -o /mnt/pm963/testfile | grep 'Max Write' >> ${filepath}
      rmmod mymodule 
      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 4s
    done
  done
done

echo "DONE"
cat ${filepath} >> log
echo "DONE" >> ${filepath}
exit 0
