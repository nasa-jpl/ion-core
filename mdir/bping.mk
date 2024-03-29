SRC_bping := \
	$(SRC)/bping.c \
	$(SRC)/libbp.c \
	$(SRC)/platform.c \
	$(SRC)/zco.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/ion.c \
	$(SRC)/libbpP.c \
	$(SRC)/platform_sm.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/bulk.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/memmgr.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/smrbt.c \
	$(SRC)/rfx.c \
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
	$(SRC)/bibe.c \
	$(SRC)/saga.c \
	$(SRC)/sdrtable.c \
	$(SRC)/radix.c \
	$(SRC)/bpsec_policy_eventset.c \
	$(SRC)/bpsec_policy_rule.c \
	$(SRC)/bpsec_util.c \
	$(SRC)/bpsec_asb.c \
	$(SRC)/pnb.c \
	$(SRC)/bpq.c \
	$(SRC)/meb.c \
	$(SRC)/bae.c \
	$(SRC)/hcb.c \
	$(SRC)/snw.c \
	$(SRC)/imc.c \
	$(SRC)/sci.c \
	$(SRC)/bpsec_policy_event.c \
	$(SRC)/sc_value.c \
	$(SRC)/csi.c \
	$(SRC)/sci_valmap.c \
	$(SRC)/sc_util.c \
	$(SRC)/ion_test_sc.c \
	$(SRC)/bib_hmac_sha2_sc.c \
	$(SRC)/bcb_aes_gcm_sc.c \
	$(SRC)/rfc9173_utils.c

bping:
	$(GCC) $(CFLAG) $(SRC_bping) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bping

