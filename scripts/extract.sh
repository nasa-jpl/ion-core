#!/bin/bash

SOURCE_PATH=$1

if [[ -z "$1" ]]; then
  echo "You must supply a path to the sources."
  echo "eg. ../ion-open-source-4.1.2"
  exit
fi

SRC=src
INC=inc
SCR=scripts
OUT_BIN=bin

POD2MAN=pod2man
MAN=man

SOURCES=(
	$SOURCE_PATH/bpv7/library/ext/bpsec/bcb.c
	$SOURCE_PATH/bpv7/library/bei.c
	$SOURCE_PATH/bpv7/library/ext/bpsec/bib.c
	$SOURCE_PATH/bpv7/bibe/bibe.c
	$SOURCE_PATH/bpv7/utils/bpadmin.c
	$SOURCE_PATH/bpv7/daemon/bpclm.c
	$SOURCE_PATH/bpv7/daemon/bpclock.c
	$SOURCE_PATH/bpv7/utils/bprecvfile.c

##	$SOURCE_PATH/bpv7/library/bpsec.c
	$SOURCE_PATH/bpv6/library/bpsec.c
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_instr.c
	$SOURCE_PATH/bpv7/bpsec/instr/bpsec_instr.c

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy.c
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy.c
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_event.c
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_event.c

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_eventset.c
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_eventset.c
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_rule.c
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_rule.c
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_util.c
	$SOURCE_PATH/bpv7/bpsec/utils/bpsec_util.c

	$SOURCE_PATH/bpv7/utils/bpsendfile.c
	$SOURCE_PATH/bpv7/test/bpsink.c
	$SOURCE_PATH/bpv7/test/bpsource.c
	$SOURCE_PATH/bpv7/daemon/bptransit.c
	$SOURCE_PATH/ici/bulk/STUB_BULK/bulk.c
	$SOURCE_PATH/ici/library/cbor.c
	$SOURCE_PATH/ici/library/crc.c
	$SOURCE_PATH/ici/crypto/NULL_SUITES/csi.c
	$SOURCE_PATH/bpv7/library/eureka.c
	$SOURCE_PATH/ici/utils/ionadmin.c
	$SOURCE_PATH/ici/library/ion.c
	$SOURCE_PATH/restart/utils/ionrestart.c
	$SOURCE_PATH/ici/library/ionsec.c
	$SOURCE_PATH/ici/utils/ionwarn.c
	$SOURCE_PATH/bpv7/ipn/ipnadmin.c
	$SOURCE_PATH/bpv7/ipn/ipnadminep.c
	$SOURCE_PATH/bpv7/ipn/ipnfw.c
	$SOURCE_PATH/bpv7/library/libbp.c
	$SOURCE_PATH/bpv7/library/libbpP.c
	$SOURCE_PATH/cfdp/library/libcfdp.c
	$SOURCE_PATH/cfdp/library/libcfdpops.c
	$SOURCE_PATH/cfdp/library/libcfdpP.c
	$SOURCE_PATH/bpv7/cgr/libcgr.c
	$SOURCE_PATH/bpv7/imc/libimcfw.c
	$SOURCE_PATH/ltp/library/libltp.c
	$SOURCE_PATH/ltp/library/libltpP.c
	$SOURCE_PATH/ltp/udp/libudplsa.c
	$SOURCE_PATH/ltp/utils/ltpadmin.c
	$SOURCE_PATH/bpv7/ltp/ltpcli.c
	$SOURCE_PATH/bpv7/ltp/ltpclo.c
	$SOURCE_PATH/ltp/daemon/ltpclock.c
	$SOURCE_PATH/ltp/daemon/ltpdeliv.c
	$SOURCE_PATH/ltp/library/ltpei.c
	$SOURCE_PATH/ltp/library/ext/ltpextensions.c
	$SOURCE_PATH/ltp/daemon/ltpmeter.c
	$SOURCE_PATH/ici/library/lyst.c
	$SOURCE_PATH/ici/library/memmgr.c
	$SOURCE_PATH/ici/library/platform.c
	$SOURCE_PATH/ici/library/platform_sm.c
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/profiles.c
	$SOURCE_PATH/bpv6/library/ext/sbsp/profiles.c
	
	$SOURCE_PATH/ici/library/psm.c
	$SOURCE_PATH/ici/library/radix.c
	$SOURCE_PATH/ici/library/rfx.c
	$SOURCE_PATH/ici/daemon/rfxclock.c
	$SOURCE_PATH/bpv7/saga/saga.c
	$SOURCE_PATH/ici/sdr/sdrcatlg.c
	$SOURCE_PATH/ici/sdr/sdrhash.c
	$SOURCE_PATH/ici/sdr/sdrlist.c
	$SOURCE_PATH/ici/sdr/sdrmgt.c
	$SOURCE_PATH/ici/sdr/sdrstring.c
	$SOURCE_PATH/ici/sdr/sdrtable.c
	$SOURCE_PATH/ici/sdr/sdrxn.c
	$SOURCE_PATH/ici/library/smlist.c
	$SOURCE_PATH/ici/library/smrbt.c
	$SOURCE_PATH/ici/library/sptrace.c
	$SOURCE_PATH/ltp/udp/udplsi.c
	$SOURCE_PATH/ltp/udp/udplso.c
	$SOURCE_PATH/ici/library/zco.c
	$SOURCE_PATH/bpv7/ipn/libipnfw.c
	$SOURCE_PATH/bpv7/library/ext/pnb/pnb.c
	$SOURCE_PATH/bpv7/library/ext/bpq/bpq.c
	$SOURCE_PATH/bpv7/library/ext/meb/meb.c
	$SOURCE_PATH/bpv7/library/ext/bae/bae.c
	$SOURCE_PATH/bpv7/library/ext/hcb/hcb.c
	$SOURCE_PATH/bpv7/library/ext/snw/snw.c
	$SOURCE_PATH/bpv7/library/ext/imc/imc.c
	$SOURCE_PATH/bpv7/udp/udpcli.c
	$SOURCE_PATH/bpv7/udp/udpclo.c
	$SOURCE_PATH/bpv7/test/bpcounter.c
	$SOURCE_PATH/bpv7/test/bpdriver.c
	$SOURCE_PATH/ici/utils/psmwatch.c
	$SOURCE_PATH/ici/utils/sdrwatch.c
	$SOURCE_PATH/bpv7/utils/bplist.c
	$SOURCE_PATH/bpv7/utils/bpstats.c
	$SOURCE_PATH/bpv7/utils/bptrace.c
	$SOURCE_PATH/bpv7/utils/bpversion.c
	$SOURCE_PATH/bpv7/utils/lgagent.c
	$SOURCE_PATH/bpv7/utils/lgsend.c
	$SOURCE_PATH/bpv7/test/bpecho.c
	$SOURCE_PATH/bpv7/test/bping.c
	$SOURCE_PATH/bpv7/udp/libudpcla.c
	$SOURCE_PATH/bpv7/test/bpchat.c

# New for 4.1.2 (WSL)
	$SOURCE_PATH/bpv7/bpsec/utils/bpsec_asb.c
	$SOURCE_PATH/bpv7/bpsec/sci/sci.c
	$SOURCE_PATH/bpv7/bpsec/sci/sc_value.c
	$SOURCE_PATH/bpv7/bpsec/sci/sci_valmap.c
	$SOURCE_PATH/bpv7/bpsec/sci/sc_util.c
	$SOURCE_PATH/bpv7/bpsec/sci/ion_test_sc.c
	$SOURCE_PATH/bpv7/bpsec/sci/bib_hmac_sha2_sc.c
	$SOURCE_PATH/bpv7/bpsec/sci/bcb_aes_gcm_sc.c
	$SOURCE_PATH/bpv7/bpsec/sci/rfc9173_utils.c
	$SOURCE_PATH/bpv7/bpsec/utils/bpsec_asb.c

)
HEADERS=(
	$SOURCE_PATH/bpv7/library/ext/bpsec/bcb.h
	$SOURCE_PATH/bpv7/library/bei.h
	$SOURCE_PATH/bpv7/bibe/bibe.h
	$SOURCE_PATH/bpv7/bibe/bibeP.h
	$SOURCE_PATH/bpv7/library/ext/bpsec/bib.h
	$SOURCE_PATH/bpv7/include/bp.h
	$SOURCE_PATH/bpv7/library/bpP.h
	
##	$SOURCE_PATH/bpv7/include/bpsec.h
	$SOURCE_PATH/bpv6/include/bpsec.h

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_instr.h
	$SOURCE_PATH/bpv7/bpsec/instr/bpsec_instr.h
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_event.h
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_event.h

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_eventset.h
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_eventset.h

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy.h
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy.h

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_policy_rule.h
	$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_rule.h

##	$SOURCE_PATH/bpv7/library/ext/bpsec/bpsec_util.h
	$SOURCE_PATH/bpv7/bpsec/utils/bpsec_util.h 

	$SOURCE_PATH/ici/include/bulk.h
	$SOURCE_PATH/ici/include/cbor.h
	$SOURCE_PATH/cfdp/include/cfdp.h
	$SOURCE_PATH/cfdp/include/cfdpops.h
	$SOURCE_PATH/cfdp/library/cfdpP.h
	$SOURCE_PATH/bpv7/library/cgr.h
	$SOURCE_PATH/ici/include/crc.h
	$SOURCE_PATH/ici/include/crypto.h
	$SOURCE_PATH/ici/crypto/csi_debug.h
	$SOURCE_PATH/ici/include/csi.h
	$SOURCE_PATH/bpv7/dtn2/dtn2fw.h
	$SOURCE_PATH/bpv7/include/eureka.h
	$SOURCE_PATH/bpv7/imc/imcfw.h
	$SOURCE_PATH/ici/include/ion.h
	$SOURCE_PATH/ici/include/ionsec.h
	$SOURCE_PATH/bpv7/ipn/ipnfw.h
	$SOURCE_PATH/bpv7/ltp/ltpcla.h
	$SOURCE_PATH/ltp/library/ltpei.h
	$SOURCE_PATH/ltp/include/ltp.h
	$SOURCE_PATH/ltp/library/ltpP.h
	$SOURCE_PATH/ici/include/lyst.h
#	$SOURCE_PATH/ici/library/lystP.h
	$SOURCE_PATH/ici/include/memmgr.h
#	$SOURCE_PATH/bpv7/library/ext/noextensions.c
	$SOURCE_PATH/ici/include/platform.h
	$SOURCE_PATH/ici/include/platform_sm.h
	
##	$SOURCE_PATH/bpv7/library/ext/bpsec/profiles.h
	$SOURCE_PATH/bpv6/library/ext/sbsp/profiles.h
	
	$SOURCE_PATH/ici/include/psm.h
	$SOURCE_PATH/ici/include/radix.h
	$SOURCE_PATH/ici/library/radixP.h
	$SOURCE_PATH/ici/include/rfx.h
	$SOURCE_PATH/bpv7/saga/saga.h
	$SOURCE_PATH/ici/include/sdr.h
	$SOURCE_PATH/ici/include/sdrhash.h
	$SOURCE_PATH/ici/include/sdrlist.h
	$SOURCE_PATH/ici/include/sdrmgt.h
	$SOURCE_PATH/ici/sdr/sdrP.h
	$SOURCE_PATH/ici/include/sdrstring.h
#	$SOURCE_PATH/ici/include/sdrtable.h
	$SOURCE_PATH/ici/include/sdrxn.h
	$SOURCE_PATH/ici/include/smlist.h
	$SOURCE_PATH/ici/include/smrbt.h
	$SOURCE_PATH/ici/include/sptrace.h
	$SOURCE_PATH/ltp/udp/udplsa.h
	$SOURCE_PATH/ici/include/zco.h
#	$SOURCE_PATH/bpv7/library/ext/bpextensions.c
	$SOURCE_PATH/bpv7/library/ext/pnb/pnb.h
	$SOURCE_PATH/bpv7/library/ext/bpq/bpq.h
	$SOURCE_PATH/bpv7/library/ext/meb/meb.h
	$SOURCE_PATH/bpv7/library/ext/bae/bae.h
	$SOURCE_PATH/bpv7/library/ext/hcb/hcb.h
	$SOURCE_PATH/bpv7/library/ext/snw/snw.h
	$SOURCE_PATH/bpv7/library/ext/imc/imc.h
	$SOURCE_PATH/bpv7/udp/udpcla.h

# New for 4.1.2 (WSL)
	$SOURCE_PATH/bpv7/bpsec/sci/sci.h
	$SOURCE_PATH/bpv7/bpsec/sci/sci_structs.h
	$SOURCE_PATH/bpv7/bpsec/utils/bpsec_asb.h
	$SOURCE_PATH/bpv7/bpsec/sci/sci_valmap.h
	$SOURCE_PATH/ici/library/lystP.h
	$SOURCE_PATH/ici/include/sdrtable.h
	$SOURCE_PATH/bpv7/library/ext/bpextensions.c
	$SOURCE_PATH/bpv7/utils/bpsecadmin_config.h
	$SOURCE_PATH/bpv7/utils/jsmn.h
	$SOURCE_PATH/bpv7/bpsec/sci/sc_value.h
	$SOURCE_PATH/bpv7/bpsec/sci/ion_test_sc.h
	$SOURCE_PATH/bpv7/bpsec/sci/sc_util.h
	$SOURCE_PATH/bpv7/bpsec/sci/bib_hmac_sha2_sc.h
	$SOURCE_PATH/bpv7/bpsec/sci/bcb_aes_gcm_sc.h
	$SOURCE_PATH/bpv7/bpsec/sci/rfc9173_utils.h
	$SOURCE_PATH/bpv6/library/ext/sbsp/sbsp_util.h
	)

SCRIPTS=(
	$SOURCE_PATH/ionstart
	$SOURCE_PATH/ionstop
	$SOURCE_PATH/ionstart.awk
	$SOURCE_PATH/killm
		)

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
while [ "x${SOURCES[count]}" != "x" ]
	do
		if cp ${SOURCES[count]} $SRC
		then echo found ${SOURCES[count]}
			else echo ERROR: ${SOURCES[count]} is missing or has moved. Aborting.
			break
		fi
	count=$(( $count + 1 ))
done

count=0
while [ "x${HEADERS[count]}" != "x" ]
	do
		if cp ${HEADERS[count]} $INC
		then echo found ${HEADERS[count]}
			else echo ERROR: ${HEADERS[count]} is missing or has moved. Aborting.
			break
		fi
	count=$(( $count + 1 ))

done

count=0
while [ "x${SCRIPTS[count]}" != "x" ]
	do
		if cp ${SCRIPTS[count]} $OUT_BIN
		then echo found ${SCRIPTS[count]}
			else echo ERROR: ${SCRIPTS[count]} is missing or has moved. Aborting.
			break
		fi
	count=$(( $count + 1 ))

done

##count=0
##while [ "x${NAMES[count]}" != "x" ]
##	do
##		if $POD2MAN $SOURCE_PATH/${NAMES[count]}.pod | gzip -c > $MAN/${BASE[count]}.1.gz
##		then echo found ${NAMES[count]}
##			else echo ERROR: ${NAMES[count]} is missing or has moved. Aborting.
##			break
##		fi
##	count=$(( $count + 1 ))
##done

# Clean up the inc/noextensions.c file here.
# The compiler produces "warning: excess elements in scalar initializer"
# This is because of the static type for the arrays:
# extensionDefs[]
# extensionSpecs[]

# This uses clean_noex.txt which contains some corrected code.
# Since I can't touch the upstream code on Sourceforge; I gotta do it this way for now.
##cd scripts
##./clean_noex.sh
##cd ..

# Relative path in #include:
sed -i 's!#include "../../utils/bpsecadmin_config.h"!#include "bpsecadmin_config.h"!g' src/bpsec_policy_rule.c
exit

###################################



