
all:
	$(GCC) $(CFLAG) \
	$(SRC)/sdrstring.c \
	$(SRC)/rfx.c \
	$(SRC)/bulk.c \
	$(SRC)/zco.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/ion.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/sptrace.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrxn.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/ionadmin.c \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ionadmin
