#
# Source File List for BP
#
LIBBP_INCLUDED = YES

SRC_libbp := $(SRC_BPV7)/libbp.c \
	$(SRC_BPV7)/libbpP.c \
	$(SRC_BPV7)/libipnfw.c \
	$(SRC_BPV7)/cbdedup.c \
	$(SRC_BPV7)/bei.c \
	$(SRC_BPV7)/bcb.c \
	$(SRC_BPV7)/bib.c \
	$(SRC_BPV7)/pnb.c \
	$(SRC_BPV7)/bpq.c \
	$(SRC_BPV7)/meb.c \
	$(SRC_BPV7)/bae.c \
	$(SRC_BPV7)/hcb.c \
	$(SRC_BPV7)/snw.c \
	$(SRC_BPV7)/imc.c \
	$(SRC_BPV7)/cbr.c \
	$(SRC_BPV7)/cteb.c \
	$(SRC_BPV7)/creb.c \
	$(SRC_BPV7)/libimcfw.c \
	$(SRC_BPV7)/bibe.c \
	$(SRC_BPV7)/eureka.c \
	$(SRC_BPV7)/saga.c \
	$(SRC_BPV7)/bpsec_policy.c \
	$(SRC_BPV7)/bpsec_instr.c \
	$(SRC_BPV7)/bpsec_policy_eventset.c \
	$(SRC_BPV7)/bpsec_policy_rule.c \
	$(SRC_BPV7)/bpsec_util.c \
	$(SRC_BPV7)/bpsec_policy_event.c \
	$(SRC_BPV7)/bpsec_asb.c \
	$(SRC_BPV7)/sci.c \
	$(SRC_BPV7)/sc_value.c \
	$(SRC_BPV7)/sci_valmap.c \
	$(SRC_BPV7)/sc_util.c \
	$(SRC_BPV7)/ion_test_sc.c \
	$(SRC_BPV7)/bib_hmac_sha2_sc.c \
	$(SRC_BPV7)/bcb_aes_gcm_sc.c \
	$(SRC_BPV7)/rfc9173_utils.c 

# 9/13/2024
# Removed following from BPv6
# $(SRC)/profiles.c
# $(SRC)/bpsec.c