
SRC_rfxclock := \
	$(SRC)/rfxclock.c \
	$(SRC)/platform_sm.c \
	$(SRC)/ion.c \
	$(SRC)/rfx.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/platform.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrxn.c \
	$(SRC)/memmgr.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/zco.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/sptrace.c \
	$(SRC)/lyst.c \
	$(SRC)/bulk.c

rfxclock:
	$(GCC) $(CFLAG) $(SRC_rfxclock) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/rfxclock
