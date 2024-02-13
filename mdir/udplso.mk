
SRC_udplso := \
	$(SRC)/udplso.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/ion.c \
	$(SRC)/rfx.c \
	$(SRC)/libltpP.c \
	$(SRC)/sdrxn.c \
	$(SRC)/libudplsa.c \
	$(SRC)/memmgr.c \
	$(SRC)/psm.c \
	$(SRC)/smrbt.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/zco.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ltpei.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrtable.c

udplso:
	$(GCC) $(CFLAG) $(SRC_udplso) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/udplso
