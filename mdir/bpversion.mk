SRC_bpversion := \
	$(SRC)/bpversion.c

bpversion:
	$(GCC) $(CFLAG) $(SRC_bpversion) \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bpversion
