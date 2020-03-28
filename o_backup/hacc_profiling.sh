#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_mod8p.txt'

annot="out_mod8p"
#path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"

logpath="/home/kau/jwbang/200320/log_folder/log"
#------------------------------

echo "Saved File will be recorded as : "$filepath
echo "Read/Write: READ"
echo "mymodule path: "$path
echo "Saved File will be recorded as : "$filepath >> $logpath
echo "Read/Write: READ" >> $logpath
echo "mymodule path: "$path >>$logpath

#----- mount and unmount pm963
sh /home/kau/jwbang/mkfs.sh xfs >> $logpath
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh >> $logpath
sleep 3
#-----------------------------

echo ${annot} > ${filepath}
sleep 0.1

for proc in 16 32 64
do
  for b_size in 100 1000 10000 100000 1000000
  do
    for iter in {0..10}
    do
      sleep 0.1

      if [ $iter -eq 0 ]; then
        sleep 0.1
        mpirun -np ${proc} /home/kau/jwbang/HACC_IO_KERNEL/HACC_IO ${b_size} /mnt/pm963/testfile
        sleep 1
        sh /home/kau/jwbang/drop-cache.sh
        sleep 5s
        continue
      fi

      echo '' >> $filepath
      insmod $path
      echo 'Processors:'${proc}',[hacc-io]-Size:'${b_size}',iter:'${iter}
      echo 'Processors:'${proc}',[hacc-io]-Size:'${b_size}',iter:'${iter} >> ${filepath}
      sleep 0.1
      mpirun -np ${proc} /home/kau/jwbang/HACC_IO_KERNEL/HACC_IO ${b_size} /mnt/pm963/testfile | grep 'WRITE' | cut -d' ' -f5 >> ${filepath}
      rmmod mymodule 
      dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> $filepath
      sh /home/kau/jwbang/drop-cache.sh
      sleep 5s
    done
  done
done
cat ${filepath} >> $logpath
echo "DONE"
echo "DONE" >> ${filepath}
exit 0
