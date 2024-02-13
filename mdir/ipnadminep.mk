
SRC_ipnadminep := \
	$(SRC)/ipnadminep.c \
	$(SRC)/libbpP.c \
	$(SRC)/platform.c \
	$(SRC)/libipnfw.c \
	$(SRC)/ion.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/platform_sm.c \
	$(SRC)/sdrlist.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrstring.c \
	$(SRC)/smrbt.c \
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
	$(SRC)/lyst.c \
	$(SRC)/cbor.c \
	$(SRC)/crc.c \
	$(SRC)/bcb.c \
	$(SRC)/bib.c \
	$(SRC)/libbp.c \
	$(SRC)/bibe.c \
	$(SRC)/saga.c \
	$(SRC)/memmgr.c \
	$(SRC)/sptrace.c \
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

ipnadminep:
	$(GCC) $(CFLAG) $(SRC_ipnadminep) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ipnadminep
