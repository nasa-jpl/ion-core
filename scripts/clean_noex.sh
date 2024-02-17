#!/bin/bash

head -n 56 ../inc/noextensions.c > temp
cat clean_noex.txt >> temp
cp temp ../inc/noextensions.c
rm temp
exit
