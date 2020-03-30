#!/bin/bash

nfiles=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$nfiles' | cut -d= -f2 | head -n 1`
meandirwidth=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$meandirwidth' | cut -d= -f2 | head -n 1`
filesize=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$filesize' | cut -d= -f2 | head -n 1 | cut -d' ' -f1`
nthreads=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$nthreads' | cut -d= -f2 | head -n 1`
iosize=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$iosize' | cut -d= -f2 | head -n 1 | cut -d' ' -f1`
meanappendsize=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$meanappendsize' | cut -d= -f2 | head -n 1 | cut -d' ' -f1`
runtime=`cat /home/kau/jwbang/benchmark/filebench/work_cyk/fileserver.f | grep '$runtime' | cut -d= -f2 | head -n 1`

#echo 8,${nfiles},${meandirwidth},${filesize},${nthreads},${iosize},${runtime},cr.w.c.o.r.c.d.s
echo 8,${nfiles},${meandirwidth},${filesize},${nthreads},${iosize},${runtime},cr.w.c.d.s
