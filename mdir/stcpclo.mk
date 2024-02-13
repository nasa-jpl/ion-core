SRC_stcpclo := \
	$(SRC)/libbp.c \
	$(SRC)/platform.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/ion.c \
	$(SRC)/zco.c \
	$(SRC)/libbpP.c \
	$(SRC)/platform_sm.c \
	$(SRC)/sdrlist.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/memmgr.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/rfx.c \
	$(SRC)/bulk.c \
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
	$(SRC)/bpsec.c \
	$(SRC)/pnb.c \
	$(SRC)/bpq.c \
	$(SRC)/meb.c \
	$(SRC)/bae.c \
	$(SRC)/hcb.c \
	$(SRC)/snw.c \
	$(SRC)/imc.c \
	$(SRC)/csi.c \
	$(SRC)/profiles.c \
	$(SRC)/bpsec_policy_event.c \
	$(SRC)/libstcpcla.c \
	$(SRC)/stcpclo.c \
	$(SRC)/bpsec_asb.c \
	$(SRC)/sci.c \
	$(SRC)/sc_value.c \
	$(SRC)/libipnfw.c \
	$(SRC)/sci_valmap.c \
	$(SRC)/sc_util.c \
	$(SRC)/ion_test_sc.c \
	$(SRC)/bib_hmac_sha2_sc.c \
	$(SRC)/bcb_aes_gcm_sc.c \
	$(SRC)/rfc9173_utils.c

stcpclo:
	$(GCC) $(CFLAG) $(SRC_stcpclo) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/stcpclo
	