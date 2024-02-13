
SRC_ltpdeliv := \
	$(SRC)/ltpdeliv.c \
	$(SRC)/libltpP.c \
	$(SRC)/platform_sm.c \
	$(SRC)/ion.c \
	$(SRC)/platform.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/zco.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ltpei.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/rfx.c \
	$(SRC)/sptrace.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrtable.c

ltpdeliv:
	$(GCC) $(CFLAG) $(SRC_ltpdeliv) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ltpdeliv
