#################################
# Makefile for ION-Core
#################################

# Build List

# MANDATORY LIST: should not be modified.
## ICI
PROGRAMS := ionadmin ionwarn rfxclock ionrestart 

## BPv7
PROGRAMS += bpadmin bpclm bpclock bptransit ipnadmin ipnadminep ipnfw

## Utility Programs
PROGRAMS += bpsink bpsource bpecho bping bpstats bptrace 


# OPTIONAL LIST: can be modified to add or remove programs. 
#                Commented out entries are available but not built.
#				 by default. Uncomment to enable.
## ICI
PROGRAMS += psmwatch sdrwatch 

## BPv7
PROGRAMS += bpversion lgagent lgsend

## CLA: must include one of STCP, UDP, or LTP 
PROGRAMS += stcpcli stcpclo 
PROGRAMS += udpcli udpclo 
PROGRAMS += ltpcli ltpclo udplsi udplso ltpclock ltpdeliv ltpmeter ltpadmin

## Utility Programs
PROGRAMS += bprecvfile bpsendfile bpchat bpcounter bpdriver bplist

###########################
# Build Rules
###########################
# This is probably the only thing users would want to change:
INSTALL_PATH = /usr/local/

PWD := $(shell pwd)

export SRC = $(PWD)/src
export INC = $(PWD)/inc
export OUT_BIN = $(PWD)/bin
export MAN = $(PWD)/man
export SCR = $(PWD)/scripts

# Just locally:
MDIR = $(PWD)/mdir
LIB = $(PWD)/lib

export CFLAG = -g -Wall -DSPACE_ORDER=3 -Wall -DBP_EXTENDED -lm -pthread
export PLATFORM = -lm -pthread
export GCC = /usr/bin/gcc

# Just locally:
MAKE = /usr/bin/make -f

# Collect all source files from SRC_{PROGRAM} variables defined in .mk files
ALL_SRC_FILES := $(sort $(foreach prog,$(PROGRAMS),$(SRC_$(prog))))

# Convert source file paths to object file paths
OBJ_FILES := $(patsubst $(SRC)/%.c,$(LIB)/obj/%.o,$(ALL_SRC_FILES))

# Ensure the obj directory exists
_OBJ_DIR := $(shell mkdir -p $(LIB)/obj)

################################
# Define build targets
################################
.PHONY: all $(PROGRAMS) clean distclean install man uninstall

# Default target to build selected programs
all: $(PROGRAMS)

# Construct .mk file paths
MK_FILES := $(addprefix $(MDIR)/,$(addsuffix .mk,$(PROGRAMS)))

# Include.mk files
include $(MK_FILES)

# After inclusion of all .mk files, the SRC_{PROGRAM} variables are now 
# visible to the rest of the Makefile.

# Collect all source files from SRC_{PROGRAM} variables defined in .mk files
ALL_SRC_FILES := $(sort $(foreach prog,$(PROGRAMS),$(SRC_$(prog))))

# Convert source file paths to object file paths
OBJ_FILES := $(patsubst $(SRC)/%.c,$(LIB)/obj/%.o,$(ALL_SRC_FILES))

# Ensure the obj directory exists
_OBJ_DIR := $(shell mkdir -p $(LIB)/obj)

# Static library target
lib: $(OBJ_FILES)
	ar rcs $(LIB)/libioncore.a $^

# Object files compile rule for static library #
# *** Remember to check if there are different flags for different programs. ***
# *** This rule here assumes they are all the same, which is true for 4.1.2. ***
$(LIB)/obj/%.o: $(SRC)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< $(PLATFORM) -o $@
				
install:
	cp -v $(OUT_BIN)/* $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstart $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstart.awk $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstop $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/killm $(INSTALL_PATH)/bin

man:
	./scripts/make-man-pages.sh $(SRC) "$(PROGRAMS)"
	cp -v $(MAN)/* $(INSTALL_PATH)/man || true

clean:
	@find $(OUT_BIN) -type f ! -name 'ionstart' ! -name 'ionstart.awk' ! -name 'ionstop' ! -name 'killm' -exec rm -f {} + > /dev/null
	@find $(LIB) -type f -exec rm -f {} + > /dev/null

uninstall:
	@rm -f $(INSTALL_PATH)/bin/*
	@rm -f $(INSTALL_PATH)/man/*

distclean:
	@find $(INC) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null
	@find $(SRC) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null
	@find $(LIB) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null
	@find $(OUT_BIN) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null
	@find $(MAN) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null







