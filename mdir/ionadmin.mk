
SRC_ionadmin := \
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
	$(SRC)/ionadmin.c

ionadmin:
	$(GCC) $(CFLAG) $(SRC_ionadmin) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ionadmin
