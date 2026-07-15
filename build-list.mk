SHELL := /usr/bin/env bash
#
# Build list for ION-core 
#
BUILD_LIST_INCLUDED = YES

######################
# ION-DTN Version
######################
# Read ION-DTN version from ION_DTN_VERSION file
ION_DTN_VERSION_FILE := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/ION_DTN_VERSION
ION_DTN_TAG := $(shell grep -v '^\#' $(ION_DTN_VERSION_FILE) | grep -v '^[[:space:]]*$$' | head -n1 | tr -d '[:space:]')
$(info ION-DTN Tag: $(ION_DTN_TAG))

######################
# Set version number
######################
# Derive ION-CORE version from ION-DTN tag
# Extract version number from tag (e.g., "ion-open-source-4.1.3s" -> "4.1.3s")
ION_VERSION := $(shell echo $(ION_DTN_TAG) | sed -E 's/^ion-open-source-//')
VER := -DVNAME=ION-CORE-$(ION_VERSION)

######################
# ION-CORE Build Flag
# (enables conditional compilation in ION-DTN)
######################
ION_CORE_FLAG := -DION_CORE_BUILD

######################
# Architecture
# (set automatically)
######################

# Detect the OS
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
LONGBIT := $(shell getconf LONG_BIT | tr -d ' ')
#LONGBIT := 32
# Default to unset
OS_FLAGS :=

# Set OS_FLAGS based on OS and LONGBIT
ifeq ($(UNAME_S), Linux)
  ifeq ($(LONGBIT), 64)
    OS_FLAGS := -Dlinux -DSPACE_ORDER=3 -fno-strict-aliasing
  else
    OS_FLAGS := -Dlinux -DSPACE_ORDER=2 -fno-strict-aliasing
  endif
endif

# ION 4.2.0 gates the "All UNIX platforms" block in platform.h on __unix__
# (4.1.x used bare `unix`). Apple clang predefines neither, so Darwin must pass
# -D__unix__ explicitly (Linux/FreeBSD compilers predefine it). Matches the
# darwin AM_CFLAGS in ION's configure.ac.
ifeq ($(UNAME_S), Darwin)
  ifeq ($(LONGBIT), 64)
    OS_FLAGS := -D__unix__ -Dunix -Ddarwin -DSPACE_ORDER=3 -m64
  else
    OS_FLAGS := -D__unix__ -Dunix -Ddarwin -DSPACE_ORDER=2 -m32
  endif
endif

ifeq ($(UNAME_S), FreeBSD)
  ifeq ($(LONGBIT), 64)
    OS_FLAGS := -Dfreebsd -DSPACE_ORDER=3 -m64
  else
    OS_FLAGS := -Dfreebsd -DSPACE_ORDER=2 -m32
  endif
endif

# Print the selected OS_FLAGS for debugging
$(info OS: $(LONGBIT)-bits $(UNAME_S); HW ARCH: $(UNAME_M))
$(info OS_FLAGS set to: $(OS_FLAGS))

##################
# Robust Process-Shared Mutex
# (set automatically)
##################
# ION 4.2.0 uses a robust process-shared pthread mutex for the SDR transaction
# lock, the PSM partition lock and the IPC global semaphore table when
# ION_HAVE_ROBUST_MUTEX is defined, enabling EOWNERDEAD recovery when a process
# dies holding one. Stock ION decides this with an autoconf probe; ion-core has
# no configure step, so probe for it here with the same test and the same
# platform gate (configure.ac: linux|bsd|solaris).
#
# The macro changes the layout of structures that live in shared memory, so an
# ion-core build MUST reach the same answer as any stock ION build sharing the
# node. If they disagree, the second build to attach computes a different size
# for the global semaphore table and dies in sm_ipc_init().
#
# Set ENABLE_ROBUST_SDR_LOCK=no to force it off (equivalent to ION's
# ./configure --disable-robust-sdr-lock); both builds must then agree on that.
ENABLE_ROBUST_SDR_LOCK ?= yes

ROBUST_MUTEX_CC := $(shell command -v gcc || echo /usr/bin/gcc)
ROBUST_MUTEX_FLAG :=

ifeq ($(ENABLE_ROBUST_SDR_LOCK), yes)
  ifneq ($(filter $(UNAME_S), Linux FreeBSD SunOS),)
    ROBUST_MUTEX_OK := $(shell printf '%s\n' \
      '#define _GNU_SOURCE' \
      '#include <pthread.h>' \
      'int main(void) {' \
      '  pthread_mutexattr_t attr;' \
      '  pthread_mutex_t mutex;' \
      '  if (pthread_mutexattr_init(&attr) != 0) return 1;' \
      '  if (pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED) != 0) return 1;' \
      '  if (pthread_mutexattr_setrobust(&attr, PTHREAD_MUTEX_ROBUST) != 0) return 1;' \
      '  if (pthread_mutex_init(&mutex, &attr) != 0) return 1;' \
      '  (void) pthread_mutex_consistent(&mutex);' \
      '  return 0;' \
      '}' \
      | $(ROBUST_MUTEX_CC) -x c - -pthread -o /dev/null > /dev/null 2>&1 \
      && echo yes || echo no)
    ifeq ($(ROBUST_MUTEX_OK), yes)
      ROBUST_MUTEX_FLAG := -DION_HAVE_ROBUST_MUTEX
    endif
  endif
endif

$(info ROBUST_MUTEX_FLAG set to: $(ROBUST_MUTEX_FLAG))

##################
# FLAGS for Extension for Locally Sourced Bundles
#
# PBN_EXT : Previous Node Extension Block
# BPQ_EXT : Bundle Protocol QoS Extension Block
# BAE_EXT : Bundle Age Extension Block
# SNW_EXT : Spray and Wait Permit Extension Block
# IMC_EXT : IMC Multicast Extension Block

#EXT_FLAGS = -DPNB_EXT
EXT_FLAGS += -DBPQ_EXT
#EXT_FLAGS += -DBAE_EXT
#EXT_FLAGS += -DSNW_EXT
EXT_FLAGS += -DIMC_EXT
# ENABLE_IMC (new in ION 4.2.0) gates the IMC handler table in bpextensions.c and
# the IMC forwarding path in libbpP.c; it replaced 4.1.x's unconditional IMC.
# Without it the IMC sources compile but the block handlers never register,
# silently disabling multicast. IMC_EXT still gates the auto-attach spec entry.
EXT_FLAGS += -DENABLE_IMC

##################

##################
# PART I: Mandatory Functions (do not edit)
#

## ICI
PROGRAMS := ionadmin ionwarn rfxclock ionrestart 

## BPv7
PROGRAMS += bpadmin bpclm bpclock bptransit ipnadmin ipnadminep ipnfw

## Utility Programs
PROGRAMS += bpsink bpsource bpecho bping bpstats bptrace 

##################

##################
# PART II: Optional Feature List
#
# This list can be modified. At least one CLA must be included.

## ICI utilities
PROGRAMS += psmwatch sdrwatch ionwatch

## BPv7 utilities
# bpversion removed in ION 4.1.4 stable
PROGRAMS += bpinspect bptracker bpwatch
PROGRAMS += cbrcustodytest

## Load-and-Go Command
PROGRAMS += lgagent lgsend

## CLA: must include at least one of STCP, UDP, or LTP
### STCP CLA
PROGRAMS += stcpcli stcpclo 

### UDP CLA
PROGRAMS += udpcli udpclo 

### LTP CLA
PROGRAMS += ltpcli ltpclo udplsi udplso ltpclock ltpdeliv ltpmeter ltpadmin ltpwatch ltpstats

## CFDP Class 1
PROGRAMS += bputa cfdpclock cfdptest cfdpadmin 

# Utility Programs
PROGRAMS += bprecvfile bpsendfile 
PROGRAMS += bpchat 
PROGRAMS += bpcounter bpdriver
PROGRAMS += bplist bpcancel
PROGRAMS += owltsim
PROGRAMS += bpcp bpcpd

#
# PART III: PLATFORM & BP Extension
#
# Work-in-progress

#
# PART IV: Testing Mapping
#
# Specify test list on build-list options
# Left side of ":" is a list of programs, joined by '+'
# Right side of ":" is a list of tests to execute, joined by '+'
# Each test on the right side should appear only once.
# TO DO: add bench-udp once it is improved for 4.1.4.
COMBINATION_TESTS := \
	cfdpadmin+ltpcli+owltsim:bench-cfdp/ \
	stcpcli:bench-stcp/ \
	ltpcli:bench-ltp/ \
  bptrace+bpsink+ltpcli:bptrace_terminal_test/ \
  bping+bpecho+udpcli:bping/ \
  cfdpadmin+ltpcli:issue-352-bpcp-ltp/ \
  cfdpadmin+stcpcli:issue-352-bpcp-stcp/ \
  cbrcustodytest+ltpcli:custody-simple/ \
  cbrcustodytest+ltpcli:crs-simple/
