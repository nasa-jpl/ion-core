#!/bin/bash
grep -rn $1 ../ion-open-source-4.1.2/ --exclude=*.text --exclude=*.js --exclude=*.cpp --exclude=*.supp --exclude=*.pod --exclude=*.css --exclude=*.py --exclude=*.hs
exit

