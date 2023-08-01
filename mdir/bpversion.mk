all:
	$(GCC) $(CFLAG) \
	$(SRC)/bpversion.c \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/bpversion
