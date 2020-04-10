#!/bin/bash

nowdate=`date +'%y%m%d-%H%M'`

git add . -A
git commit -m $nowdate
git push

exit 0
