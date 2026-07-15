#################################
# Makefile for ION-Core
# Require: gmake
#################################

# bring in the build list
include ./build-list.mk

# test if inclusion is successful
ifndef BUILD_LIST_INCLUDED
$(error build-list.mk is not found or not included, cannot build.)
endif

$(info build-list.mk has been included, proceed to build.)

# Check if source files have been extracted
ifeq ($(wildcard src/ici/*.c),)
$(error Source files not found. Run: ./scripts/extract.sh)
endif

###########################
# Build Rules
###########################
# This is probably the only thing users would want to change:
INSTALL_PATH = /usr/local/

PWD := $(shell pwd)

export SRC = $(PWD)/src
export SRC_ICI = $(PWD)/src/ici
export SRC_BPV7 = $(PWD)/src/bpv7
export SRC_CFDP = $(PWD)/src/cfdp
export SRC_LTP = $(PWD)/src/ltp
export SRC_RESTART = $(PWD)/src/restart
export INC = $(PWD)/inc
export OUT_BIN = $(PWD)/bin
export MAN = $(PWD)/man
export SCR = $(PWD)/scripts
export TESTS = $(PWD)/tests

# Just locally:
MDIR = $(PWD)/mdir
LIB = $(PWD)/lib

###########################
# Compiler Flags
###########################
# OS_FLAGS is for different combination of OS and HW architecture
# BP_EXTENDED is required enables extension blocks required for QoS.
# EXT_FLAGS is a list of individual extension blocks for locally sourced bundles
# ION_CORE_FLAG enables conditional compilation in ION-DTN for ion-core-specific builds
# ROBUST_MUTEX_FLAG is probed in build-list.mk; it must match the stock ION build

export CFLAG = -g -Wall $(OS_FLAGS) $(VER) $(ION_CORE_FLAG) -DBP_EXTENDED ${EXT_FLAGS} $(ROBUST_MUTEX_FLAG)
export PLATFORM = -lm -pthread
export SHARED_FLAG = -fPIC
export GCC = $(shell command -v gcc || echo /usr/bin/gcc)

##########################
# List of Files
##########################
# Ensure the obj directories exist
_STATIC_OBJ_DIR := $(shell mkdir -p $(LIB)/obj/static)
_SHARED_OBJ_DIR := $(shell mkdir -p $(LIB)/obj/shared)

################################
# Define build targets
################################
.PHONY: all $(PROGRAMS) clean distclean install man uninstall static shared

# Default target to build selected programs
all: $(PROGRAMS)

# Construct .mk file paths
MK_FILES := $(addprefix $(MDIR)/,$(addsuffix .mk,$(PROGRAMS)))

# Include all .mk files
include $(MK_FILES)

# Object files for static libraries
STATIC_ICI_OBJ_FILES := $(patsubst $(SRC_ICI)/%.c,$(LIB)/obj/static/%.o,$(SRC_libici))
STATIC_BP_OBJ_FILES := $(patsubst $(SRC_BPV7)/%.c,$(LIB)/obj/static/%.o,$(SRC_libbp))
STATIC_LTP_OBJ_FILES := $(patsubst $(SRC_LTP)/%.c,$(LIB)/obj/static/%.o,$(SRC_libltp))
STATIC_CFDP_OBJ_FILES := $(patsubst $(SRC_CFDP)/%.c,$(LIB)/obj/static/%.o,$(SRC_libcfdp))

# Object files for dynamic libraries
SHARED_ICI_OBJ_FILES := $(patsubst $(SRC_ICI)/%.c,$(LIB)/obj/shared/%.o,$(SRC_libici))
SHARED_BP_OBJ_FILES := $(patsubst $(SRC_BPV7)/%.c,$(LIB)/obj/shared/%.o,$(SRC_libbp))
SHARED_LTP_OBJ_FILES := $(patsubst $(SRC_LTP)/%.c,$(LIB)/obj/shared/%.o,$(SRC_libltp))
SHARED_CFDP_OBJ_FILES := $(patsubst $(SRC_CFDP)/%.c,$(LIB)/obj/shared/%.o,$(SRC_libcfdp))

# static library targets
static: staticlibici staticlibbp staticlibltp staticlibcfdp

staticlibici: $(STATIC_ICI_OBJ_FILES)
	ar rcs $(LIB)/libicicore.a $^

staticlibbp: $(STATIC_BP_OBJ_FILES)
	ar rcs $(LIB)/libbpcore.a $^

staticlibltp: $(STATIC_LTP_OBJ_FILES)
	ar rcs $(LIB)/libltpcore.a $^

staticlibcfdp: $(STATIC_CFDP_OBJ_FILES)
	ar rcs $(LIB)/libcfdpcore.a $^

# Object files compile rule for static library
$(LIB)/obj/static/%.o: $(SRC_ICI)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< -o $@

$(LIB)/obj/static/%.o: $(SRC_BPV7)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< -o $@

$(LIB)/obj/static/%.o: $(SRC_LTP)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< -o $@

$(LIB)/obj/static/%.o: $(SRC_CFDP)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< -o $@

# dynamic/shared library targets
shared: $(LIB)/libicicore.so $(LIB)/libbpcore.so $(LIB)/libltpcore.so $(LIB)/libcfdpcore.so

$(LIB)/libicicore.so: $(SHARED_ICI_OBJ_FILES)
	$(GCC) -shared -o $(LIB)/libicicore.so $(SHARED_ICI_OBJ_FILES)

$(LIB)/libbpcore.so: $(SHARED_BP_OBJ_FILES)
	$(GCC) -shared -o $(LIB)/libbpcore.so $(SHARED_ICI_OBJ_FILES) -L$(LIB) -licicore

$(LIB)/libltpcore.so: $(SHARED_LTP_OBJ_FILES)
	$(GCC) -shared -o $(LIB)/libltpcore.so $(SHARED_ICI_OBJ_FILES) -L$(LIB) -licicore -lbpcore

$(LIB)/libcfdpcore.so: $(SHARED_CFDP_OBJ_FILES)
	$(GCC) -shared -o $(LIB)/libcfdpcore.so $(SHARED_ICI_OBJ_FILES) -L$(LIB) -licicore -lbpcore

# Object files compile rule for shared library
$(LIB)/obj/shared/%.o: $(SRC_ICI)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< $(SHARED_FLAG) -o $@

$(LIB)/obj/shared/%.o: $(SRC_BPV7)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< $(SHARED_FLAG) -o $@

$(LIB)/obj/shared/%.o: $(SRC_LTP)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< $(SHARED_FLAG) -o $@

$(LIB)/obj/shared/%.o: $(SRC_CFDP)/%.c
	$(GCC) $(CFLAG) -I$(INC) -c $< $(SHARED_FLAG) -o $@

install:
	$(info Make "install" target...)
	find $(OUT_BIN) -maxdepth 1 -type f -exec cp -v {} $(INSTALL_PATH)/bin \;
	cp -v $(OUT_BIN)/ionstart $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstart.awk $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstop $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/killm $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionprocesses.txt $(INSTALL_PATH)/bin

install-lib:
	$(info Make "install-lib" target...)
	@find $(LIB) -maxdepth 1 -name "*.a" -exec cp -v {} $(INSTALL_PATH)/lib \; || true
	@find $(LIB) -maxdepth 1 -name "*.so" -exec cp -v {} $(INSTALL_PATH)/lib \; || true

# sym links to original .pod files are in ion-core/src/man
# generated man page is in ion-core/man
man:
	./scripts/make-man-pages.sh $(SRC)/man "$(PROGRAMS)"
	find $(MAN) -maxdepth 1 -type f -name '*.1.gz' -exec cp -v {} $(INSTALL_PATH)/share/man/man1 \; || true
	find $(MAN) -maxdepth 1 -type f -name '*.3.gz' -exec cp -v {} $(INSTALL_PATH)/share/man/man3 \; || true

clean:
	$(info Make "clean" target...)
	@find $(OUT_BIN) -type f ! -name '.gitkeep' ! -name 'ionstart' ! -name 'ionstart.awk' ! -name 'ionstop' ! -name 'killm' -exec rm -f {} + > /dev/null
	@find $(LIB) -type f ! -name '.gitkeep' -exec rm -f {} + > /dev/null

test:
	$(info Make "test" target...)
	@echo "Processing PROGRAMS list from $(BUILD_LIST)..."
	@ALL_TESTS_TO_RUN=""; \
	for combo in $(COMBINATION_TESTS); do \
		COMB=$$(echo $$combo | cut -d':' -f1); \
		TESTS_TO_RUN=$$(echo $$combo | cut -d':' -f2 | tr '+' ' '); \
		COMB_FOUND=1; \
		for prog in $$(echo $$COMB | tr '+' ' '); do \
			if ! echo "$(PROGRAMS)" | grep -q "$$prog"; then \
				COMB_FOUND=0; \
				break; \
			fi; \
		done; \
		if [ $$COMB_FOUND -eq 1 ]; then \
			echo "Combination found: $$COMB. Adding tests: $$TESTS_TO_RUN"; \
			ALL_TESTS_TO_RUN="$$ALL_TESTS_TO_RUN $$TESTS_TO_RUN"; \
		else \
			echo "Combination not found: $$COMB"; \
		fi; \
	done; \
	if [ -n "$$ALL_TESTS_TO_RUN" ]; then \
		echo "Running the following tests: $$ALL_TESTS_TO_RUN"; \
		cd $(TESTS) && ./runtests $$ALL_TESTS_TO_RUN; \
	else \
		echo "No valid combinations found. No tests to run."; \
	fi

uninstall:
	$(info Make "uninstall" target...)
	@for prog in $(PROGRAMS); do \
	    rm -f $(INSTALL_PATH)/bin/$$prog; \
		rm -f $(INSTALL_PATH)/share/man/man1/$$prog*; \
	done
	rm -f $(INSTALL_PATH)/bin/ionstart
	rm -f $(INSTALL_PATH)/bin/ionstart.awk
	rm -f $(INSTALL_PATH)/bin/ionstop
	rm -f $(INSTALL_PATH)/bin/killm
	rm -f $(INSTALL_PATH)/bin/ionprocesses.txt

uninstall-lib:
	$(info Make "uninstall-lib" target...)
	@rm -f $(INSTALL_PATH)/lib/*core.a
	@rm -f $(INSTALL_PATH)/lib/*core.so

## Clean up all build artifacts + all source files extracted from ION open source code
distclean:
	$(info Make "distclean" target...)
	@echo "Removing build artifacts and extracted ION source files..."
	@find $(LIB) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null || true
	@find $(OUT_BIN) -type f ! -name '.gitkeep' ! -name 'ionstart' ! -name 'ionstart.awk' ! -name 'ionstop' ! -name 'killm' -exec rm -rf {} + > /dev/null || true
	@find $(MAN) -mindepth 1 ! -name '.gitkeep' -exec rm -rf {} + > /dev/null || true
	@find $(SRC) -type l -exec rm -f {} + > /dev/null || true
	@find $(INC) -type l -exec rm -f {} + > /dev/null || true
	@find $(TESTS) -type l -exec rm -f {} + > /dev/null || true
	@rm -rf $(SRC)/man > /dev/null || true
	@rm -rf tmp > /dev/null || true
	@rm -f system_up configs scripts/macOS/install_macos_sysctl.sh scripts/macOS/sysctl_script.sh > /dev/null || true
	@echo "Distclean complete."