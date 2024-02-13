
SRC_ltpmeter := \
	$(SRC)/ltpmeter.c \
	$(SRC)/ion.c \
	$(SRC)/platform.c \
	$(SRC)/libltpP.c \
	$(SRC)/sdrxn.c \
	$(SRC)/platform_sm.c \
	$(SRC)/libudplsa.c \
	$(SRC)/memmgr.c \
	$(SRC)/psm.c \
	$(SRC)/smrbt.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/zco.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/rfx.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ltpei.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrtable.c

ltpmeter:
	$(GCC) $(CFLAG) $(SRC_ltpmeter) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ltpmeter










