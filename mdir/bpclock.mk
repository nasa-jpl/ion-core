
SRC_bpclock := $(SRC)/bpclock.c \
	$(SRC)/platform_sm.c \
	$(SRC)/sdrxn.c \
	$(SRC)/platform.c \
	$(SRC)/sdrlist.c \
	$(SRC)/libbpP.c \
	$(SRC)/ion.c \
	$(SRC)/smrbt.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/sptrace.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ionsec.c \
	$(SRC)/bpsec_policy.c \
	$(SRC)/bpsec_instr.c \
	$(SRC)/zco.c \
	$(SRC)/rfx.c \
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
	$(SRC)/sdrtable.c \
	$(SRC)/radix.c \
	$(SRC)/bpsec_policy_eventset.c \
	$(SRC)/bpsec_policy_rule.c \
	$(SRC)/bpsec_util.c \
	$(SRC)/bpsec.c \
	$(SRC)/bulk.c \
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

bpclock:
	$(GCC) $(CFLAG) $(SRC_bpclock) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bpclock
