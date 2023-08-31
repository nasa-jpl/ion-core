#!/bin/bash

SOURCES=(
	bae
	bcb_aes_gcm_sc
	bcb
	bei
	bib
	bibe
	bib_hmac_sha2_sc
	bpq
	bpsec_asb
	bpsec
	bpsec_instr
	bpsec_policy
	bpsec_policy_event
	bpsec_policy_eventset
	bpsec_policy_rule
	bpsec_util
	bulk
	cbor
	crc
	csi
	eureka
	hcb
	imc
	ion
	ionsec
	ion_test_sc
	libbp
	libbpP
	libcfdp
	libcfdpops
	libcfdpP
	libcgr
	libimcfw
	libltp
	libltpP
	libudpcla
	ltpei
	lyst
	meb
	memmgr
	platform
	platform_sm
	pnb
	profiles
	psm
	radix
	rfc9173_utils
	rfx
	saga
	sci
	sci_valmap
	sc_util
	sc_value
	sdrcatlg
	sdrhash
	sdrlist
	sdrmgt
	sdrstring
	sdrtable
	sdrxn
	smlist
	smrbt
	snw
	sptrace
	zco
	)


count=0
while [ "x${SOURCES[count]}" != "x" ]
	do
	# Tell 'em what we are doing
	echo "/usr/bin/gcc -c -g -Wall -DSPACE_ORDER=3 -Wall -DBP_EXTENDED -Iinc -lm -pthread src/${SOURCES[count]}.c -o lib/${SOURCES[count]}.o"
	# Actually do it.
	/usr/bin/gcc -c -g -Wall -DSPACE_ORDER=3 -Wall -DBP_EXTENDED -Iinc -lm -pthread src/${SOURCES[count]}.c -o lib/${SOURCES[count]}.o
	count=$(( $count + 1 ))
	done

	/usr/bin/ld -r lib/*.o -o lib/libioncore.a
