SRC_psmwatch := \
	$(SRC)/psmwatch.c \
	$(SRC)/platform.c \
	$(SRC)/platform_sm.c \
	$(SRC)/memmgr.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/sptrace.c

psmwatch:
	$(GCC) $(CFLAG) $(SRC_psmwatch) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/psmwatch
