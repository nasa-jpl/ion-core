SRC_sdrwatch := \
	$(SRC)/sdrwatch.c \
	$(SRC)/sdrxn.c \
	$(SRC)/platform.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/zco.c \
	$(SRC)/platform_sm.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/memmgr.c \
	$(SRC)/lyst.c \
	$(SRC)/sptrace.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrlist.c \
	$(SRC)/ion.c \
	$(SRC)/smrbt.c \
	$(SRC)/rfx.c

sdrwatch:
	$(GCC) $(CFLAG) $(SRC_sdrwatch) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/sdrwatch
