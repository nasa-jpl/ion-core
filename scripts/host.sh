#!/bin/bash

a=$(echo $1 | cut --delimiter='.' -f 4);
b=$(echo $2 | cut --delimiter='.' -f 4);
time=86400

echo "## begin ionadmin" > host$a.rc
echo "1 $a 'host.ionconfig'" >> host$a.rc
echo "s" >> host$a.rc
echo  >> host$a.rc

echo "a contact +1 +$time $a $a 100000" >> host$a.rc
echo "a contact +1 +$time $a $b 100000" >> host$a.rc
echo "a contact +1 +$time $b $a 100000" >> host$a.rc
echo "a contact +1 +$time $b $b 100000" >> host$a.rc

echo  >> host$a.rc
echo "a range +1 +$time $a $a 1" >> host$a.rc
echo "a range +1 +$time $a $b 1" >> host$a.rc
echo "a range +1 +$time $b $a 1" >> host$a.rc
echo "a range +1 +$time $b $b 1" >> host$a.rc

echo  >> host$a.rc
echo "m production 1000000" >> host$a.rc
echo "m consumption 1000000" >> host$a.rc
echo "## end ionadmin" >> host$a.rc

echo >> host$a.rc
echo "## begin ltpadmin" >> host$a.rc
echo "1 32" >> host$a.rc
echo "a span $a 32 32 1368 10000 1 'udplso $1:1113' 300" >> host$a.rc
echo "a span $b 32 32 1368 10000 1 'udplso $2:1113' 300" >> host$a.rc
echo "s 'udplsi $1:1113'" >> host$a.rc
echo "## end ltpadmin" >> host$a.rc

echo >> host$a.rc
echo "## begin bpadmin" >> host$a.rc

echo "1" >> host$a.rc
echo "a scheme ipn 'ipnfw' 'ipnadminep'" >> host$a.rc
echo "a endpoint ipn:$a.0 q" >> host$a.rc
echo "a endpoint ipn:$a.1 q" >> host$a.rc
echo "a endpoint ipn:$a.2 q" >> host$a.rc
echo "a protocol ltp 1400 100" >> host$a.rc
echo "a induct ltp $a ltpcli" >> host$a.rc
echo "a outduct ltp $a ltpclo" >> host$a.rc
echo "a outduct ltp $b ltpclo" >> host$a.rc

echo "s" >> host$a.rc
echo "## end bpadmin" >> host$a.rc

echo >> host$a.rc
echo "## begin ipnadmin" >> host$a.rc
echo "a plan $a ltp/$a" >> host$a.rc
echo "a plan $b ltp/$b" >> host$a.rc
echo "## end ipnadmin" >> host$a.rc

exit
