#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_mod8p.txt'

annot="out_mod8p" #1,2,4,8,16
#path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"

logpath="/home/kau/jwbang/200320/log_folder/log"
#------------------------------

echo "Saved File will be recorded as : "$filepath
echo "NPB - bt-io"
echo "mymodule path: "$path
echo "Saved File will be recorded as : "$filepath >> $logpath
echo "NPB - bt-io" >> $logpath
echo "mymodule path: "$path >> $logpath

#----- mount and unmount pm963
#sh /home/kau/jwbang/mkfs.sh xfs
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh >> $logpath
sleep 3
#-----------------------------

echo ${annot} > ${filepath}
sleep 0.1

for proc in 64 #9 16 25 36 49 64
do
  for iter in {1..2}
  do
    sleep 0.1
    echo '' >> $filepath
    insmod $path
    echo 'Processors:'${proc}',iter:'${iter}
    echo 'Processors:'${proc}',iter:'${iter} >> ${filepath}
    sleep 0.1
#    /opt/intel/compilers_and_libraries_2017.4.196/linux/mpi/intel64/bin/mpiexec -np ${proc} /mnt/pm963/NPB3.4-MPI/bin/bt.A.x.ep_io > /home/kau/jwbang/200320/result/bt.Cout.${proc}.${annot}.${iter}
    mpiexec -np ${proc} /mnt/pm963/NPB3.4-MPI/bin/bt.A.x.ep_io > /home/kau/jwbang/200320/result/bt.Cout.${proc}.${annot}.${iter}
    rmmod mymodule
    cat /home/kau/jwbang/200320/result/bt.Cout.${proc}.${annot}.${iter} | grep "data rate" >> ${filepath}
    dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> ${filepath}
    sh /home/kau/jwbang/drop-cache.sh
    sleep 4s
  done
done

cat ${filepath} >> $logpath
echo "DONE"
echo "DONE" >> ${filepath}
exit 0
