
SRC_ipnfw := \
	$(SRC)/ipnfw.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/ion.c \
	$(SRC)/sdrxn.c \
	$(SRC)/libipnfw.c \
	$(SRC)/libbpP.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/smlist.c \
	$(SRC)/libcgr.c \
	$(SRC)/psm.c \
	$(SRC)/lyst.c \
	$(SRC)/sdrstring.c \
	$(SRC)/rfx.c \
	$(SRC)/memmgr.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/zco.c \
	$(SRC)/sptrace.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ionsec.c \
	$(SRC)/bpsec_policy.c \
	$(SRC)/bpsec_instr.c \
	$(SRC)/bei.c \
	$(SRC)/libimcfw.c \
	$(SRC)/eureka.c \
	$(SRC)/cbor.c \
	$(SRC)/crc.c \
	$(SRC)/bcb.c \
	$(SRC)/bib.c \
	$(SRC)/libbp.c \
	$(SRC)/bibe.c \
	$(SRC)/saga.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrtable.c \
	$(SRC)/radix.c \
	$(SRC)/bpsec_policy_eventset.c \
	$(SRC)/bpsec_policy_rule.c \
	$(SRC)/bpsec_util.c \
	$(SRC)/bpsec.c \
	$(SRC)/csi.c \
	$(SRC)/profiles.c \
	$(SRC)/bpsec_policy_event.c \
	$(SRC)/pnb.c \
	$(SRC)/bpq.c \
	$(SRC)/meb.c \
	$(SRC)/bae.c \
	$(SRC)/hcb.c \
	$(SRC)/snw.c \
	$(SRC)/imc.c \
	$(SRC)/bpsec_asb.c \
	$(SRC)/sci.c \
	$(SRC)/sc_value.c \
	$(SRC)/sci_valmap.c \
	$(SRC)/sc_util.c \
	$(SRC)/ion_test_sc.c \
	$(SRC)/bib_hmac_sha2_sc.c \
	$(SRC)/bcb_aes_gcm_sc.c \
	$(SRC)/rfc9173_utils.c

ipnfw:
	$(GCC) $(CFLAG) $(SRC_ipnfw) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ipnfw
