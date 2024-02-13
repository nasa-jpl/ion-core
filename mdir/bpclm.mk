
SRC_bpclm := $(SRC)/bpclm.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/rfx.c \
	$(SRC)/ion.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrxn.c \
	$(SRC)/libbpP.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/psm.c \
	$(SRC)/smrbt.c \
	$(SRC)/smlist.c \
	$(SRC)/zco.c \
	$(SRC)/memmgr.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/sdrstring.c \
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

bpclm:
	$(GCC) $(CFLAG) $(SRC_bpclm) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bpclm
