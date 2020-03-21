#!/bin/bash

#----- mount and unmount pm963
sh /home/kau/jwbang/mkfs.sh xfs
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh
sleep 3
#-----------------------------

filepath='/home/kau/jwbang/200320/out_org.txt'

echo "ORIGINAL" > ${filepath}
sleep 0.1

# ORIGINAL
for proc in 8 16 32 64
do
  for b_size in 16m 64m 256m 1024m
  do
    for iter in {1..3}
    do
      sleep 0.1
      echo '' >> $filepath
      insmod /home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',Block Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
      mpirun -np ${proc} ior -w -t 1m -b ${b_size} -F -o /mnt/pm963/testfile | grep 'Max Write' >> ${filepath}
      rmmod mymodule 
      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 20s
    done
  done
done


echo "DONE"
echo "DONE" >> ${filepath}
exit 0
