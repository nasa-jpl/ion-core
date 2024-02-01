#!/bin/bash

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <IP1> <IP2> [udp|stcp]"
  exit 1
fi

# Extract the fourth segment of the IP addresses
a=$(echo $1 | cut --delimiter='.' -f 4)
b=$(echo $2 | cut --delimiter='.' -f 4)

# Set a default protocol to ltp
protocol="ltp"

# Check if the third argument is provided and is either udp or stcp
if [ $# -eq 3 ]; then
    if [ "$3" == "udp" ] || [ "$3" == "stcp" ]; then
        protocol=$3
    else
        echo "Invalid protocol. Please use udp or stcp."
        exit 1
    fi
fi

echo ""
echo "ION is configured with BP/$protocol"
echo ""

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
if [[ $protocol == "ltp" ]]; then
  echo "## begin ltpadmin" >> host$a.rc
  echo "1 32" >> host$a.rc
  echo "a span $a 32 32 1368 10000 1 'udplso $1:1113' 300" >> host$a.rc
  echo "a span $b 32 32 1368 10000 1 'udplso $2:1113' 300" >> host$a.rc
  echo "s 'udplsi $1:1113'" >> host$a.rc
  echo "## end ltpadmin" >> host$a.rc
fi

echo >> host$a.rc
echo "## begin bpadmin" >> host$a.rc

echo "1" >> host$a.rc
echo "a scheme ipn 'ipnfw' 'ipnadminep'" >> host$a.rc
echo "a endpoint ipn:$a.0 q" >> host$a.rc
echo "a endpoint ipn:$a.1 q" >> host$a.rc
echo "a endpoint ipn:$a.2 q" >> host$a.rc
if [[ $protocol == "ltp" ]]; then
  echo "a protocol ltp 1400 100" >> host$a.rc
  echo "a induct ltp $a ltpcli" >> host$a.rc
  echo "a outduct ltp $a ltpclo" >> host$a.rc
  echo "a outduct ltp $b ltpclo" >> host$a.rc
  echo "a plan $b" >> host$a.rc
  echo "a plan $a" >> host$a.rc
  echo "a planduct $b ltp/$b" >> host$a.rc
  echo "a planduct $a ltp/$a" >> host$a.rc
elif [[ $protocol == "stcp" ]]; then
  echo "a protocol stcp 1400 100 -1" >> host$a.rc
  echo "a induct stcp $1 stcpcli" >> host$a.rc
  echo "a outduct stcp $2 stcpclo" >> host$a.rc
  echo "a plan ipn:$b.0" >> host$a.rc
  echo "a planduct ipn:$b.0 stcp $2" >> host$a.rc
elif [[ $protocol == "udp" ]]; then
  echo "a protocol udp 1400 100" >> host$a.rc
  echo "a induct udp $1 udpcli" >> host$a.rc
  echo "a outduct udp $2 udpclo" >> host$a.rc
  echo "a plan ipn:$b.0" >> host$a.rc
  echo "a planduct ipn:$b.0 udp $2" >> host$a.rc
else
  echo "Invalid protocol. Please use udp or stcp."
  exit 1
fi
echo "s" >> host$a.rc
echo "## end bpadmin" >> host$a.rc

exit
