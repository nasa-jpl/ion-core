

SRC_bpadmin := $(SRC)/bibe.c \
	$(SRC)/bib.c \
	$(SRC)/csi.c \
	$(SRC)/bcb.c \
	$(SRC)/crc.c \
	$(SRC)/saga.c \
	$(SRC)/eureka.c \
	$(SRC)/libimcfw.c \
	$(SRC)/bpsec_instr.c \
	$(SRC)/libbp.c \
	$(SRC)/bpsec_util.c \
	$(SRC)/profiles.c \
	$(SRC)/bpsec.c \
	$(SRC)/bpsec_policy_rule.c \
	$(SRC)/bpsec_policy_event.c \
	$(SRC)/bpsec_policy_eventset.c \
	$(SRC)/radix.c \
	$(SRC)/bpsec_policy.c \
	$(SRC)/ionsec.c \
	$(SRC)/sdrtable.c \
	$(SRC)/sdrhash.c \
	$(SRC)/sdrstring.c \
	$(SRC)/cbor.c \
	$(SRC)/bei.c \
	$(SRC)/libbpP.c \
	$(SRC)/rfx.c \
	$(SRC)/bulk.c \
	$(SRC)/zco.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/sptrace.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrxn.c \
	$(SRC)/ion.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/bpadmin.c \
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

bpadmin:
	$(GCC) $(CFLAG) $(SRC_bpadmin) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bpadmin

