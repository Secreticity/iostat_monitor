#!/bin/bash

#------------ SETTING VARIABLES
filepath='/home/kau/jwbang/200320/out_org.txt'

annot="ORIGINAL"
path="/home/kau/jwbang/linux-5.2.8_org/mymodule/mymodule.ko"

#annot="MODIFIED-1"  #1,2,4,8,16
#path="/home/kau/jwbang/linux-5.2.8_final/mymodule/mymodule.ko"
#------------------------------

echo "Saved File will be recorded as : "$filepath
echo "mymodule path: "$path

#----- mount and unmount pm963
#sh /home/kau/jwbang/mkfs.sh xfs
source ~/.bash_profile
sh /home/kau/jwbang/drop-cache.sh
sleep 3
#-----------------------------

echo ${annot} > ${filepath}
sleep 0.1

# ORIGINAL
for proc in 9 16 36 64
do
  for iter in {1..2}
  do
    sleep 0.1
    echo '' >> $filepath
    insmod $path
    echo 'Processors:'${proc}',iter:'${iter}
    echo 'Processors:'${proc}',iter:'${iter} >> ${filepath}
    sleep 0.1
    /opt/intel/compilers_and_libraries_2017.4.196/linux/mpi/intel64/bin/mpiexec -np ${proc} /mnt/pm963/NPB3.4-MPI/bin/bt.C.x.ep_io > /home/kau/jwbang/200320/result/bt.Cout.${proc}.${annot}.${iter}
    rmmod mymodule
    cat /home/kau/jwbang/200320/result/bt.Cout.${proc}.${annot}.${iter} | grep "data rate" >> ${filepath}
    dmesg | grep 'add_pagevec' | tail -1 | cut -d_ -f2 >> ${filepath}
    sh /home/kau/jwbang/drop-cache.sh
    sleep 4s
  done
done

echo "DONE"
echo "DONE" >> ${filepath}
exit 0
