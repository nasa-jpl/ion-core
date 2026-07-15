#
# Build list for ION-Core - CMake
#

######################
# ION-DTN Version
######################
# Read ION-DTN version from ION_DTN_VERSION file
set(ION_DTN_VERSION_FILE "${CMAKE_SOURCE_DIR}/ION_DTN_VERSION")
if(EXISTS "${ION_DTN_VERSION_FILE}")
  file(STRINGS "${ION_DTN_VERSION_FILE}" ION_DTN_TAG_LINES)
  foreach(line IN LISTS ION_DTN_TAG_LINES)
    # Strip whitespace first
    string(STRIP "${line}" line_stripped)
    # Skip empty lines and comment lines
    if(NOT "${line_stripped}" STREQUAL "" AND NOT "${line_stripped}" MATCHES "^#")
      set(ION_DTN_TAG "${line_stripped}")
      break()
    endif()
  endforeach()
  message(STATUS "ION-DTN Tag: ${ION_DTN_TAG}")
else()
  message(WARNING "ION_DTN_VERSION file not found at ${ION_DTN_VERSION_FILE}")
  set(ION_DTN_TAG "unknown")
endif()

######################
# Set version number
######################
# Derive ION-CORE version from ION-DTN tag
# Extract version number from tag (e.g., "ion-open-source-4.1.3s" -> "4.1.3s")
if(NOT "${ION_DTN_TAG}" STREQUAL "unknown")
  string(REGEX REPLACE "^ion-open-source-" "" ION_VERSION "${ION_DTN_TAG}")
  set(VER "-DVNAME=ION-CORE-${ION_VERSION}")
  message(STATUS "ION-CORE Version: ${ION_VERSION}")
else()
  # Fallback if ION_DTN_VERSION file is missing
  set(VER "-DVNAME=ION-CORE-unknown")
  message(WARNING "Using fallback version name")
endif()

######################
# ION-CORE Build Flag
# (enables conditional compilation in ION-DTN)
######################
set(ION_CORE_FLAG "-DION_CORE_BUILD")

######################
# Architecture and OS_FLAGS
# CMake's built-in variables simplify this.
######################

# Reset OS_FLAGS to ensure it's clean before setting
set(OS_FLAGS "")

# Detect the OS and architecture using CMake's built-in variables
# CMAKE_SYSTEM_NAME: Linux, Darwin, FreeBSD
# CMAKE_SIZEOF_VOID_P: Size of a void pointer (e.g., 4 for 32-bit, 8 for 64-bit)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(OS_FLAGS "-Dlinux -DSPACE_ORDER=3 -fno-strict-aliasing")
  else()
    set(OS_FLAGS "-Dlinux -DSPACE_ORDER=2 -fno-strict-aliasing")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(OS_FLAGS "-D__unix__ -Dunix -Ddarwin -DSPACE_ORDER=3") # -m64 is handled by CMAKE_C_FLAGS
  else()
    set(OS_FLAGS "-D__unix__ -Dunix -Ddarwin -DSPACE_ORDER=2") # -m32 is handled by CMAKE_C_FLAGS
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(OS_FLAGS "-Dfreebsd -DSPACE_ORDER=3") # -m64 is handled by CMAKE_C_FLAGS
  else()
    set(OS_FLAGS "-Dfreebsd -DSPACE_ORDER=2") # -m32 is handled by CMAKE_C_FLAGS
  endif()
endif()

# Output for debugging (similar to Makefile's info messages)
# CMAKE_SIZEOF_VOID_P is in bytes, so multiply by 8 to get bits
math(EXPR BITS "${CMAKE_SIZEOF_VOID_P} * 8")
message(STATUS "OS: ${BITS}-bit ${CMAKE_SYSTEM_NAME}; HW ARCH: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "OS_FLAGS set to: ${OS_FLAGS}")

# Robust process-shared mutex detection; mirrors build-list.mk. See the comment
# there for why an ion-core build must reach the same answer as the stock ION
# build it shares a node with.
option(ENABLE_ROBUST_SDR_LOCK
  "Use a robust process-shared pthread mutex for the SDR transaction lock, the PSM partition lock and the IPC semaphore table where supported"
  ON)

set(ROBUST_MUTEX_FLAG "")

if(ENABLE_ROBUST_SDR_LOCK AND (CMAKE_SYSTEM_NAME STREQUAL "Linux"
                            OR CMAKE_SYSTEM_NAME STREQUAL "FreeBSD"
                            OR CMAKE_SYSTEM_NAME STREQUAL "SunOS"))
  include(CheckCSourceCompiles)
  set(CMAKE_REQUIRED_FLAGS "-pthread")
  check_c_source_compiles("
#define _GNU_SOURCE
#include <pthread.h>
int main(void)
{
  pthread_mutexattr_t attr;
  pthread_mutex_t mutex;

  if (pthread_mutexattr_init(&attr) != 0) return 1;
  if (pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED) != 0) return 1;
  if (pthread_mutexattr_setrobust(&attr, PTHREAD_MUTEX_ROBUST) != 0) return 1;
  if (pthread_mutex_init(&mutex, &attr) != 0) return 1;
  (void) pthread_mutex_consistent(&mutex);
  return 0;
}"
    ION_ROBUST_MUTEX_SUPPORTED)
  unset(CMAKE_REQUIRED_FLAGS)

  if(ION_ROBUST_MUTEX_SUPPORTED)
    set(ROBUST_MUTEX_FLAG "-DION_HAVE_ROBUST_MUTEX")
  endif()
endif()

message(STATUS "ROBUST_MUTEX_FLAG set to: ${ROBUST_MUTEX_FLAG}")


##################
# FLAGS for Extension for Locally Sourced Bundles
##################
# Use CMake options for user-configurable flags, and set default values.
# This makes it easier for users to enable/disable extensions via CMake-GUI or -D
# For flags that are always active by default in Makefile, set them ON here.

# Initializing EXT_FLAGS list
set(EXT_FLAGS "")

# Ensure these options are set in the main CMakeLists.txt or here.
# For now, we'll mimic the Makefile by directly setting the flags.
# In CMake, it's better to use `add_definitions` or `target_compile_definitions`
# directly rather than accumulating a string `EXT_FLAGS`.
# However, to strictly mimic, we'll collect the flags here.

# As per your build-list.mk, BPQ_EXT and IMC_EXT are enabled by default.
# ENABLE_IMC (added in ION 4.2.0): gates the IMC handler table in bpextensions.c
# and the IMC forwarding path in libbpP.c. It replaced the unconditional IMC
# inclusion of 4.1.x; without it the IMC block handlers are compiled but never
# registered, silently disabling multicast. IMC_EXT still gates the auto-attach
# extensionSpecs entry, so both are set.
# If you wish to make them configurable by the user, you'd use `option()` in CMakeLists.txt
# and check if they are ON.
# For direct translation, we'll append to EXT_FLAGS string.
# Note: In CMake, it's often better to use `add_definitions(-DBPQ_EXT)` directly
# in the main CMakeLists.txt where compilation flags are applied.
# This `EXT_FLAGS` variable here would then only serve as documentation or for
# a very specific concatenation logic.
# For the purpose of *this* build-list.cmake, we'll define it as a string
# that *could* be passed to add_definitions later.
set(EXT_FLAGS "-DBPQ_EXT -DIMC_EXT -DENABLE_IMC") # Matches your Makefile: EXT_FLAGS += -DBPQ_EXT -DIMC_EXT -DENABLE_IMC


##################
# PART I: Mandatory Functions
##################
# Use `set()` to define the PROGRAMS list.

set(PROGRAMS
  # ICI
  ionadmin
  ionwarn
  rfxclock
  ionrestart

  # BPv7
  bpadmin
  bpclm
  bpclock
  bptransit
  ipnadmin
  ipnadminep
  ipnfw

  # Utility Programs
  bpsink
  bpsource
  bpecho
  bping
  bpstats
  bptrace
)

##################
# PART II: Optional Feature List
##################
# Append to the PROGRAMS list for optional features.
list(APPEND PROGRAMS
  # ICI utilities
  psmwatch
  sdrwatch
  ionwatch

  # BPv7 utilities
  # bpversion  # Removed in ION 4.1.4 stable
  bpinspect
  cbrcustodytest
  bptracker
  bpwatch

  # Load-and-Go Command
  lgagent
  lgsend

  # CLA: must include at least one of STCP, UDP, or LTP
  # STCP CLA
  stcpcli
  stcpclo

  # UDP CLA
  udpcli
  udpclo

  # LTP CLA
  ltpcli
  ltpclo
  udplsi
  udplso
  ltpclock
  ltpdeliv
  ltpmeter
  ltpadmin
  ltpwatch
  ltpstats

  # CFDP Class 1
  bputa
  cfdpclock
  cfdptest
  cfdpadmin
  bpcp
  bpcpd

  # Utility Programs
  bprecvfile
  bpsendfile
  bpchat
  bpcounter
  bpdriver
  bplist
  bpcancel
  owltsim
)
# If you had conditional compilation for these in Makefile (e.g., ifdefs),
# you would wrap these `list(APPEND PROGRAMS ...)` calls in `if()` statements
# based on CMake options set in CMakeLists.txt.
# Example: if(ENABLE_PSMWATCH) ... endif()


##################
# PART IV: Testing Mapping
##################
# Define COMBINATION_TESTS as a list of strings.
# Each string is "program1+program2:test_suite_1+test_suite_2".
# Escaping semicolons might be necessary if they are part of the value.
# For clean reading, each entry on a new line.
set(COMBINATION_TESTS
  "cfdpadmin+ltpcli+owltsim:../demos/bench-cfdp/"
  "stcpcli:../demos/bench-stcp/"
  "ltpcli:../demos/bench-ltp/"
  "bptrace+bpsink+ltpcli:bptrace_terminal_test/"
  "bping+bpecho+udpcli:bping/"
  "cfdpadmin+ltpcli:issue-352-bpcp-ltp/"
  "cfdpadmin+stcpcli:issue-352-bpcp-stcp/"
  "cbrcustodytest+ltpcli:cbr-ct-orange-book/custody-simple/"
  "cbrcustodytest+ltpcli:cbr-ct-orange-book/crs-simple/"
)
