
SRC_ltpadmin := \
	$(SRC)/libltp.c \
	$(SRC)/ltpei.c \
	$(SRC)/sdrtable.c \
	$(SRC)/sdrhash.c \
	$(SRC)/sdrstring.c \
	$(SRC)/libltpP.c \
	$(SRC)/rfx.c \
	$(SRC)/bulk.c \
	$(SRC)/zco.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/sptrace.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrxn.c \
	$(SRC)/ion.c \
	$(SRC)/platform_sm.c \
	$(SRC)/platform.c \
	$(SRC)/ltpadmin.c

ltpadmin:
	$(GCC) $(CFLAG) $(SRC_ltpadmin) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ltpadmin
