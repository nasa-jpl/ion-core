#!/bin/bash

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <IP1> <IP2> [udp|stcp]"
  exit 1
fi

IP1=$1  # First command-line argument (full IP)
IP2=$2  # Second command-line argument (full IP)

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

echo "create config files"
if [[ $protocol == "ltp" ]]; then
  ./scripts/host.sh "$IP1" "$IP2"
else
  ./scripts/host.sh "$IP1" "$IP2" "$protocol"
fi 

echo ""
echo "kill previous instances of ION, if any"
killm

echo ""
echo "run ION node on host${IP1##*.}..."
ionstart -I host${IP1##*.}.rc

echo ""
echo "wait 10 seconds for the other side to start ION too"
sleep 10

echo ""
echo "run bping..."
bping -c 10 ipn:${IP1##*.}.2 ipn:${IP2##*.}.2 | tee >(grep "transmitted" > ./bping.tmp)

# Read the output file into a variable
output=$(< ./bping.tmp)

# Optionally, clean up the temp file
rm ./bping.tmp

# Check for the presence of a specific string in the output
if [[ $output == *"10 bundles received"* ]]; then
  echo ""
  #echo "$output"
  echo "bping SUCCESS!"
  exit 0  # Exit with code 0 if string is found
else
  echo ""
  #echo "$output"
  echo "bping FAILED!"
  exit 1  # Exit with code 1 if string is not found
fi
