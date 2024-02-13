
SRC_ltpclock := \
	$(SRC)/ltpclock.c \
	$(SRC)/platform_sm.c \
	$(SRC)/sdrxn.c \
	$(SRC)/platform.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/libltpP.c \
	$(SRC)/ion.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/rfx.c \
	$(SRC)/memmgr.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ltpei.c \
	$(SRC)/zco.c \
	$(SRC)/sdrtable.c \
	$(SRC)/bulk.c 

ltpclock:
	$(GCC) $(CFLAG) $(SRC_ltpclock) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ltpclock
















