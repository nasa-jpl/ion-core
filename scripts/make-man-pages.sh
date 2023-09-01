#!/bin/bash
SOURCE_PATH=$1

if [[ -z "$1" ]]; then
  echo "You must supply a path to the sources."
  echo "eg. ../ion-open-source-4.1.2"
  exit
fi

POD2MAN=pod2man
MAN=man

# No man page for:
# bpversion
# iowarn
# ltpdeliv

NAMES=(
bpv7/doc/pod1/bping
bpv7/doc/pod1/bpecho
bpv7/doc/pod1/lgsend
bpv7/doc/pod1/lgagent
bpv7/doc/pod1/bptrace
bpv7/doc/pod1/bpstats
bpv7/doc/pod1/bplist
ici/doc/pod1/sdrwatch
ici/doc/pod1/psmwatch
bpv7/doc/pod1/bpdriver
bpv7/doc/pod1/bpcounter
bpv7/doc/pod1/udpclo
bpv7/doc/pod1/udpcli
bpv7/doc/pod1/bpadmin
ici/doc/pod1/ionadmin
ltp/doc/pod1/ltpadmin
bpv7/doc/pod1/ipnadmin
bpv7/doc/pod1/bprecvfile
bpv7/doc/pod1/bpsendfile
bpv7/doc/pod1/bpsink
bpv7/doc/pod1/bpsource
ici/doc/pod1/rfxclock
ltp/doc/pod1/ltpclock
ltp/doc/pod1/udplso
ltp/doc/pod1/udplsi
ltp/doc/pod1/ltpmeter
bpv7/doc/pod1/bptransit
bpv7/doc/pod1/ipnadminep
bpv7/doc/pod1/ltpclo
bpv7/doc/pod1/bpclock
bpv7/doc/pod1/ltpcli
bpv7/doc/pod1/ipnfw
bpv7/doc/pod1/bpclm
restart/doc/pod1/ionrestart
bpv7/doc/pod1/bpchat
	)

BASE=(
bping
bpecho
lgsend
lgagent
bptrace
bpstats
bplist
sdrwatch
psmwatch
bpdriver
bpcounter
udpclo
udpcli
bpadmin
ionadmin
ltpadmin
ipnadmin
bprecvfile
bpsendfile
bpsink
bpsource
rfxclock
ltpclock
udplso
udplsi
ltpmeter
bptransit
ipnadminep
ltpclo
bpclock
ltpcli
ipnfw
bpclm
ionrestart
bpchat
	)
	
count=0
while [ "x${NAMES[count]}" != "x" ]
	do
		if $POD2MAN $SOURCE_PATH/${NAMES[count]}.pod | gzip -c > $MAN/${BASE[count]}.1.gz
		then echo found ${NAMES[count]}
			else echo ERROR: ${NAMES[count]} is missing or has moved. Aborting.
			break
		fi
	count=$(( $count + 1 ))
done

