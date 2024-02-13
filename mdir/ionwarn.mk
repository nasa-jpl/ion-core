
SRC_ionwarn := \
	$(SRC)/ionwarn.c \
	$(SRC)/lyst.c \
	$(SRC)/ion.c \
	$(SRC)/platform.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/zco.c \
	$(SRC)/bulk.c \
	$(SRC)/smrbt.c \
	$(SRC)/psm.c \
	$(SRC)/sdrstring.c \
	$(SRC)/platform_sm.c \
	$(SRC)/memmgr.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/rfx.c \
	$(SRC)/sptrace.c

ionwarn:
	$(GCC) $(CFLAG) $(SRC_ionwarn) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ionwarn







