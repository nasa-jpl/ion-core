cmake_minimum_required(VERSION 3.10)

# Read version from ION_DTN_VERSION file
set(ION_DTN_VERSION_FILE "${CMAKE_SOURCE_DIR}/ION_DTN_VERSION")
if(EXISTS "${ION_DTN_VERSION_FILE}")
  file(STRINGS "${ION_DTN_VERSION_FILE}" ION_DTN_TAG_LINES)
  foreach(line IN LISTS ION_DTN_TAG_LINES)
    string(STRIP "${line}" line_stripped)
    if(NOT "${line_stripped}" STREQUAL "" AND NOT "${line_stripped}" MATCHES "^#")
      set(ION_DTN_TAG "${line_stripped}")
      break()
    endif()
  endforeach()
  # Extract version number (e.g., "ion-open-source-4.1.4-b.2" -> "4.1.4")
  string(REGEX REPLACE "^ion-open-source-([0-9]+\\.[0-9]+\\.[0-9]+).*" "\\1" PROJECT_VERSION "${ION_DTN_TAG}")
else()
  set(PROJECT_VERSION "4.2.0")
  message(WARNING "ION_DTN_VERSION file not found, using default version ${PROJECT_VERSION}")
endif()

project(ION-Core-ICI VERSION ${PROJECT_VERSION} LANGUAGES C)

# Debug: Print CMAKE_SOURCE_DIR
message("CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")

# Default installation path
set(CMAKE_INSTALL_PREFIX /usr/local CACHE PATH "Installation prefix")

# Include custom configuration file for feature selection
include(ion-core-config.cmake OPTIONAL)

# Include the new build-list.cmake file to define global build variables
include(${CMAKE_SOURCE_DIR}/build-list.cmake) # Assuming build-list.cmake is in the root

# Platform detection and flags (now handled by build-list.cmake which sets OS_FLAGS)
# The logic below can be simplified as OS_FLAGS is already set.
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  # Already handled by build-list.cmake setting OS_FLAGS
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  # -m64/-m32 flags are commonly handled by adding to CMAKE_C_FLAGS if necessary,
  # but often CMake's default compilers handle this based on CMAKE_SIZEOF_VOID_P
  # For direct mimicry:
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
  else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
  else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
  endif()
endif()

# Apply the OS-specific definitions from build-list.cmake
add_definitions(${OS_FLAGS})

# Compiler flags (from Makefile)
# VER is now set in build-list.cmake, so we can use it directly
add_definitions(${VER}) # -DVNAME=ION-CORE-4.1.3s

add_compile_options(-g -Wall -DBP_EXTENDED)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC") # For shared libraries

# Apply ION-CORE build flag from build-list.cmake
add_definitions(${ION_CORE_FLAG})

# Apply extension flags from build-list.cmake
add_definitions(${EXT_FLAGS})

# Extension flags - if these were originally options, keep them as options
# The `EXT_FLAGS` string from build-list.cmake can define the default flags.
# If you want them to be user-configurable, you would still use `option()`
# and then conditionally add definitions. For now, mimicking direct application.
# option(ENABLE_BPQ_EXT "Enable Bundle Protocol QoS Extension Block" ON)
# option(ENABLE_IMC_EXT "Enable IMC Multicast Extension Block" ON)
# if(ENABLE_BPQ_EXT)
#   add_definitions(-DBPQ_EXT)
# endif()
# if(ENABLE_IMC_EXT)
#   add_definitions(-DIMC_EXT)
# endif()

# Allow users to specify custom ION source directory
# Default to the submodule location
set(ION_SOURCE_DIR "${CMAKE_SOURCE_DIR}/external/ION-DTN" CACHE PATH "Path to ION-DTN source directory")

# Check if the specified ION source directory exists
if(NOT EXISTS "${ION_SOURCE_DIR}")
  message(FATAL_ERROR "ION source directory not found: ${ION_SOURCE_DIR}\n"
    "Either initialize the submodule: git submodule update --init --recursive\n"
    "Or specify a custom path: cmake -DION_SOURCE_DIR=/path/to/ion/source ..")
endif()

# Define directories
set(ION_DTN_DIR ${ION_SOURCE_DIR})
set(SRC_DIR ${ION_DTN_DIR})
set(INC_DIR ${ION_DTN_DIR})
set(LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)
set(MAN_DIR ${CMAKE_SOURCE_DIR}/man)
set(TESTS_DIR ${ION_DTN_DIR}/tests) # Point to submodule tests directory

# Helper function to find source files in ION-DTN's distributed directory structure
# Searches in common subdirectories: utils/, daemon/, test/, library/, ltp/, udp/, stcp/, bp/, etc.
function(find_ion_source_file output_var module_dir filename)
  set(search_paths
    "${module_dir}/${filename}"
    "${module_dir}/utils/${filename}"
    "${module_dir}/daemon/${filename}"
    "${module_dir}/test/${filename}"
    "${module_dir}/library/${filename}"
    "${module_dir}/sdr/${filename}"
    "${module_dir}/crypto/${filename}"
    "${module_dir}/bulk/STUB_BULK/${filename}"
    "${module_dir}/ltp/${filename}"
    "${module_dir}/udp/${filename}"
    "${module_dir}/stcp/${filename}"
    "${module_dir}/bp/${filename}"
    "${module_dir}/ipn/${filename}"
  )

  foreach(path IN LISTS search_paths)
    if(EXISTS "${path}")
      set(${output_var} "${path}" PARENT_SCOPE)
      return()
    endif()
  endforeach()

  # If not found, return empty and let caller handle the error
  set(${output_var} "" PARENT_SCOPE)
endfunction()

#
# ICI source files
# Note: Files are in subdirectories within ici/ (library/, sdr/, crypto/, bulk/)
#
set(ICI_SOURCES
  ${SRC_DIR}/ici/bulk/STUB_BULK/bulk.c
  ${SRC_DIR}/ici/crypto/NULL_SUITES/csi.c
  ${SRC_DIR}/ici/library/ionsec.c
  ${SRC_DIR}/ici/library/memmgr.c
  ${SRC_DIR}/ici/library/platform_sm.c
  ${SRC_DIR}/ici/library/radix.c
  ${SRC_DIR}/ici/sdr/sdrcatlg.c
  ${SRC_DIR}/ici/sdr/sdrmgt.c
  ${SRC_DIR}/ici/library/smrbt.c
  ${SRC_DIR}/ici/library/cbor.c
  ${SRC_DIR}/ici/library/psm.c
  ${SRC_DIR}/ici/library/rfx.c
  ${SRC_DIR}/ici/sdr/sdrhash.c
  ${SRC_DIR}/ici/sdr/sdrstring.c
  ${SRC_DIR}/ici/sdr/sdrxn.c
  ${SRC_DIR}/ici/library/sptrace.c
  ${SRC_DIR}/ici/library/crc.c
  ${SRC_DIR}/ici/library/ion.c
  ${SRC_DIR}/ici/library/ion_atomic.c
  ${SRC_DIR}/ici/library/lyst.c
  ${SRC_DIR}/ici/library/platform.c
  ${SRC_DIR}/ici/sdr/sdrlist.c
  ${SRC_DIR}/ici/sdr/sdrtable.c
  ${SRC_DIR}/ici/library/smlist.c
  ${SRC_DIR}/ici/library/zco.c
  ${SRC_DIR}/ici/library/ion_admin.c
  ${SRC_DIR}/ici/library/ion_network.c
)

if(NOT ICI_SOURCES)
  message(FATAL_ERROR "No ICI source files defined. Ensure ION-DTN submodule is initialized: git submodule update --init --recursive")
endif()

# List of known ICI executables (not to include in library)
# PROGRAMS are now defined in build-list.cmake, use its values
set(ICI_PROGRAMS
  ionadmin
  ionwarn
  rfxclock
  psmwatch
  sdrwatch
  owltsim
  # ionwatch is handled separately due to multi-library dependencies
)

#
# LTP source files
# Note: Files are in subdirectories within ltp/ (library/, sda/, udp/)
#
set(LTP_SOURCES
  ${SRC_DIR}/ltp/library/libltp.c
  ${SRC_DIR}/ltp/library/libltpP.c
  ${SRC_DIR}/ltp/sda/libsda.c
  ${SRC_DIR}/ltp/udp/libudplsa.c
  ${SRC_DIR}/ltp/library/ltpei.c
)

if(NOT LTP_SOURCES)
  message(FATAL_ERROR "No LTP source files defined. Ensure ION-DTN submodule is initialized: git submodule update --init --recursive")
endif()

# Known LTP executables (exclude these from library)
set(LTP_PROGRAMS
  ltpadmin
  ltpclock
  ltpmeter
  ltpwatch
  ltpstats
  udplsi
  udplso
  ltpdeliv
  ltpcli
  ltpclo
)

#
# BP source files (based on libbp.mk and ION-DTN submodule)
#
#
# BP source files
# Note: Files are in subdirectories within bpv7/ (library/, bpsec/, cgr/, ipn/, etc.)
# Generated using: python3 scripts/generate_cmake_sources.py external/ION-DTN
#
set(BP_SOURCES
  ${SRC_DIR}/bpv7/library/ext/bae/bae.c
  ${SRC_DIR}/bpv7/library/ext/cteb/cteb.c
  ${SRC_DIR}/bpv7/library/ext/creb/creb.c
  ${SRC_DIR}/bpv7/bpsec/instr/bpsec_instr.c
  ${SRC_DIR}/bpv7/bpsec/sci/bcb_aes_gcm_sc.c
  ${SRC_DIR}/bpv7/bpsec/policy/bpsec_policy.c
  ${SRC_DIR}/bpv7/library/ext/meb/meb.c
  ${SRC_DIR}/bpv7/library/ext/bpsec/bcb.c
  ${SRC_DIR}/bpv7/bpsec/policy/bpsec_policy_event.c
  ${SRC_DIR}/bpv7/library/libbp.c
  ${SRC_DIR}/bpv7/library/ext/pnb/pnb.c
  ${SRC_DIR}/bpv7/library/bei.c
  ${SRC_DIR}/bpv7/bpsec/policy/bpsec_policy_eventset.c
  ${SRC_DIR}/bpv7/library/eureka.c
  ${SRC_DIR}/bpv7/library/cbr.c
  ${SRC_DIR}/bpv7/library/libbpP.c
  ${SRC_DIR}/bpv7/bpsec/sci/rfc9173_utils.c
  ${SRC_DIR}/bpv7/library/ext/bpsec/bib.c
  ${SRC_DIR}/bpv7/bpsec/policy/bpsec_policy_rule.c
  ${SRC_DIR}/bpv7/library/ext/hcb/hcb.c
  ${SRC_DIR}/bpv7/cgr/libcgr.c
  ${SRC_DIR}/bpv7/saga/saga.c
  ${SRC_DIR}/bpv7/bibe/bibe.c
  ${SRC_DIR}/bpv7/bpsec/utils/bpsec_util.c
  ${SRC_DIR}/bpv7/library/ext/imc/imc.c
  ${SRC_DIR}/bpv7/imc/libimcfw.c
  ${SRC_DIR}/bpv7/bpsec/sci/sci.c
  ${SRC_DIR}/bpv7/bpsec/sci/bib_hmac_sha2_sc.c
  ${SRC_DIR}/bpv7/bpsec/sci/ion_test_sc.c
  ${SRC_DIR}/bpv7/ipn/libipnfw.c
  ${SRC_DIR}/bpv7/ipn/cbdedup.c
  ${SRC_DIR}/bpv7/bpsec/sci/sci_valmap.c
  ${SRC_DIR}/bpv7/library/ext/bpq/bpq.c
  ${SRC_DIR}/bpv7/stcp/libstcpcla.c
  ${SRC_DIR}/bpv7/bpsec/sci/sc_util.c
  ${SRC_DIR}/bpv7/udp/libudpcla.c
  ${SRC_DIR}/bpv7/bpsec/sci/sc_value.c
  ${SRC_DIR}/bpv7/bpsec/utils/bpsec_asb.c
  ${SRC_DIR}/bpv7/library/ext/snw/snw.c
)

if(NOT BP_SOURCES)
  message(FATAL_ERROR "No BP source files defined. Ensure ION-DTN submodule is initialized: git submodule update --init --recursive")
endif()

# Filter out test programs for separate executable targets
set(BP_EXECUTABLES
  bpadmin
  bpclm
  bpclock
  # bpversion removed in ION 4.1.4 stable
  cbrcustodytest
  stcpcli
  stcpclo 
  udpcli 
  udpclo 
  bpchat 
  bpcounter 
  bpdriver
  bpecho
  # bpinspect is handled separately due to multiple source files
  bping
  bplist
  bpcancel
  bprecvfile 
  bpsendfile 
  bpsink 
  bpsource 
  bpstats
  bptrace
  bptracker
  bpwatch
  bptransit
  ipnadmin 
  ipnadminep 
  ipnfw 
  lgagent 
  lgsend
)

#
# CFDP source files
#
#
# CFDP source files
# Note: Files are in subdirectories within cfdp/ (library/, bp/)
# Generated using: python3 scripts/generate_cmake_sources.py external/ION-DTN
#
set(CFDP_SOURCES
  ${SRC_DIR}/cfdp/bp/bputa.c
  ${SRC_DIR}/cfdp/library/libcfdp.c
  ${SRC_DIR}/cfdp/library/libcfdpP.c
  ${SRC_DIR}/cfdp/library/libcfdpops.c
)

if(NOT CFDP_SOURCES)
  message(FATAL_ERROR "No CFDP source files defined. Ensure ION-DTN submodule is initialized: git submodule update --init --recursive")
endif()

# Known CFDP programs
set(CFDP_PROGRAMS
  bputa
  bpcp
  bpcpd
  cfdpadmin
  cfdpclock
  cfdptest
)

# ionrestart source (single-file module)
set(RESTART_SOURCES
  ${SRC_DIR}/restart/ionrestart.c
)

# Collect all program executables (now primarily driven by PROGRAMS from build-list.cmake)
# Ensure ALL_PROGRAMS contains all listed executables for linking
# You might still need these sub-lists (ICI_PROGRAMS, BP_EXECUTABLES, etc.)
# for iterating over specific module sources, but the master list comes from build-list.cmake
set(ALL_PROGRAMS ${PROGRAMS}) # Use PROGRAMS variable populated from build-list.cmake


# Static ICI library
add_library(icicore_static STATIC ${ICI_SOURCES})
target_include_directories(icicore_static PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/ici/library
  ${INC_DIR}/ici/crypto
  ${INC_DIR}/ici/crypto/NULL_SUITES
  ${INC_DIR}/ici/sdr
  ${INC_DIR}/ici/bulk
)
set_target_properties(icicore_static PROPERTIES
  OUTPUT_NAME icicore
  ARCHIVE_OUTPUT_DIRECTORY ${LIB_DIR}
)

# Shared ICI library
add_library(icicore_shared SHARED ${ICI_SOURCES})
target_include_directories(icicore_shared PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/ici/library
  ${INC_DIR}/ici/crypto
  ${INC_DIR}/ici/crypto/NULL_SUITES
  ${INC_DIR}/ici/sdr
  ${INC_DIR}/ici/bulk
)
set_target_properties(icicore_shared PROPERTIES
  OUTPUT_NAME icicore
  LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR}
)
target_link_libraries(icicore_shared PRIVATE m pthread)

# Static BP library
add_library(bpcore_static STATIC ${BP_SOURCES})
target_include_directories(bpcore_static PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/bpv7/library
  ${INC_DIR}/bpv7/library/ext
  ${INC_DIR}/bpv7/library/ext/bpsec
  ${INC_DIR}/bpv7/library/ext/pnb
  ${INC_DIR}/bpv7/library/ext/bae
  ${INC_DIR}/bpv7/library/ext/meb
  ${INC_DIR}/bpv7/library/ext/hcb
  ${INC_DIR}/bpv7/library/ext/bpq
  ${INC_DIR}/bpv7/library/ext/imc
  ${INC_DIR}/bpv7/library/ext/snw
  ${INC_DIR}/bpv7/library/ext/cteb
  ${INC_DIR}/bpv7/library/ext/creb
  ${INC_DIR}/bpv7/cgr
  ${INC_DIR}/bpv7/bpsec
  ${INC_DIR}/bpv7/bpsec/instr
  ${INC_DIR}/bpv7/bpsec/policy
  ${INC_DIR}/bpv7/bpsec/sci
  ${INC_DIR}/bpv7/bpsec/utils
  ${INC_DIR}/bpv7/ipn
  ${INC_DIR}/bpv7/imc
  ${INC_DIR}/bpv7/saga
  ${INC_DIR}/bpv7/bibe
  ${INC_DIR}/bpv7/dtn2
)
target_link_libraries(bpcore_static PRIVATE icicore_static)
set_target_properties(bpcore_static PROPERTIES
  OUTPUT_NAME bpcore
  ARCHIVE_OUTPUT_DIRECTORY ${LIB_DIR}
)

# Shared BP library
add_library(bpcore_shared SHARED ${BP_SOURCES})
target_include_directories(bpcore_shared PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/bpv7/library
  ${INC_DIR}/bpv7/library/ext
  ${INC_DIR}/bpv7/library/ext/bpsec
  ${INC_DIR}/bpv7/library/ext/pnb
  ${INC_DIR}/bpv7/library/ext/bae
  ${INC_DIR}/bpv7/library/ext/meb
  ${INC_DIR}/bpv7/library/ext/hcb
  ${INC_DIR}/bpv7/library/ext/bpq
  ${INC_DIR}/bpv7/library/ext/imc
  ${INC_DIR}/bpv7/library/ext/snw
  ${INC_DIR}/bpv7/library/ext/cteb
  ${INC_DIR}/bpv7/library/ext/creb
  ${INC_DIR}/bpv7/cgr
  ${INC_DIR}/bpv7/bpsec
  ${INC_DIR}/bpv7/bpsec/instr
  ${INC_DIR}/bpv7/bpsec/policy
  ${INC_DIR}/bpv7/bpsec/sci
  ${INC_DIR}/bpv7/bpsec/utils
  ${INC_DIR}/bpv7/ipn
  ${INC_DIR}/bpv7/imc
  ${INC_DIR}/bpv7/saga
  ${INC_DIR}/bpv7/bibe
  ${INC_DIR}/bpv7/dtn2
)
target_link_libraries(bpcore_shared PRIVATE icicore_shared m pthread)
set_target_properties(bpcore_shared PROPERTIES
  OUTPUT_NAME bpcore
  LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR}
)

# Static LTP library
add_library(ltpcore_static STATIC ${LTP_SOURCES})
target_include_directories(ltpcore_static PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/ltp/include
  ${INC_DIR}/ltp/library
  ${INC_DIR}/ltp/library/ext
  ${INC_DIR}/ltp/library/ext/auth
  ${INC_DIR}/ltp/sda
  ${INC_DIR}/ltp/udp
)
target_link_libraries(ltpcore_static PRIVATE bpcore_static icicore_static)
set_target_properties(ltpcore_static PROPERTIES
  OUTPUT_NAME ltpcore
  ARCHIVE_OUTPUT_DIRECTORY ${LIB_DIR}
)

# Shared LTP library
add_library(ltpcore_shared SHARED ${LTP_SOURCES})
target_include_directories(ltpcore_shared PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/ltp/include
  ${INC_DIR}/ltp/library
  ${INC_DIR}/ltp/library/ext
  ${INC_DIR}/ltp/library/ext/auth
  ${INC_DIR}/ltp/sda
  ${INC_DIR}/ltp/udp
)
target_link_libraries(ltpcore_shared PRIVATE bpcore_shared icicore_shared m pthread)
set_target_properties(ltpcore_shared PROPERTIES
  OUTPUT_NAME ltpcore
  LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR}
)

# CFDP static library
add_library(cfdpcore_static STATIC ${CFDP_SOURCES})
target_include_directories(cfdpcore_static PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/ltp/include
  ${INC_DIR}/cfdp/include
  ${INC_DIR}/cfdp/library
)
target_link_libraries(cfdpcore_static PRIVATE icicore_static bpcore_static)
set_target_properties(cfdpcore_static PROPERTIES
  OUTPUT_NAME cfdpcore
  ARCHIVE_OUTPUT_DIRECTORY ${LIB_DIR}
)

# CFDP shared library
add_library(cfdpcore_shared SHARED ${CFDP_SOURCES})
target_include_directories(cfdpcore_shared PUBLIC
  ${INC_DIR}
  ${INC_DIR}/ici/include
  ${INC_DIR}/bpv7/include
  ${INC_DIR}/ltp/include
  ${INC_DIR}/cfdp/include
  ${INC_DIR}/cfdp/library
)
target_link_libraries(cfdpcore_shared PRIVATE icicore_shared bpcore_shared m pthread)
set_target_properties(cfdpcore_shared PROPERTIES
  OUTPUT_NAME cfdpcore
  LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR}
)

# ICI Executables
foreach(PROG IN LISTS ICI_PROGRAMS)
  if(${PROG} IN_LIST ALL_PROGRAMS) # Only build if it's in the master PROGRAMS list
    find_ion_source_file(PROG_SRC "${SRC_DIR}/ici" "${PROG}.c")
    if(NOT PROG_SRC)
      message(FATAL_ERROR "Source file for ${PROG} not found in ION-DTN ici/ subdirectories")
    endif()
    add_executable(${PROG} ${PROG_SRC})
    target_include_directories(${PROG} PRIVATE ${INC_DIR})
    target_link_libraries(${PROG} PRIVATE icicore_static m pthread)
    set_target_properties(${PROG} PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
    )
  endif()
endforeach()

# BP Executables
foreach(PROG IN LISTS BP_EXECUTABLES)
  if(${PROG} IN_LIST ALL_PROGRAMS) # Only build if it's in the master PROGRAMS list
    find_ion_source_file(PROG_SRC "${SRC_DIR}/bpv7" "${PROG}.c")
    if(NOT PROG_SRC)
      message(FATAL_ERROR "Source file for ${PROG} not found in ION-DTN bpv7/ subdirectories")
    endif()
    add_executable(${PROG} ${PROG_SRC})
    target_include_directories(${PROG} PRIVATE ${INC_DIR})
    target_link_libraries(${PROG} PRIVATE bpcore_static icicore_static m pthread)
    set_target_properties(${PROG} PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
    )
  endif()
endforeach()

# LTP Executables
foreach(PROG IN LISTS LTP_PROGRAMS)
  if(${PROG} IN_LIST ALL_PROGRAMS) # Only build if it's in the master PROGRAMS list
    # ltpcli and ltpclo are in bpv7/ltp/, others are in ltp/
    if(PROG STREQUAL "ltpcli" OR PROG STREQUAL "ltpclo")
      find_ion_source_file(PROG_SRC "${SRC_DIR}/bpv7" "${PROG}.c")
    else()
      find_ion_source_file(PROG_SRC "${SRC_DIR}/ltp" "${PROG}.c")
    endif()
    if(NOT PROG_SRC)
      message(FATAL_ERROR "Source file for ${PROG} not found in ION-DTN subdirectories")
    endif()
    add_executable(${PROG} ${PROG_SRC})
    target_include_directories(${PROG} PRIVATE ${INC_DIR})
    target_link_libraries(${PROG} PRIVATE ltpcore_static bpcore_static icicore_static m pthread)
    set_target_properties(${PROG} PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
    )
  endif()
endforeach()

# CFDP executables
foreach(PROG IN LISTS CFDP_PROGRAMS)
  if(${PROG} IN_LIST ALL_PROGRAMS) # Only build if it's in the master PROGRAMS list
    # bputa is in cfdp/bp/, others are in cfdp/utils/, cfdp/daemon/, or cfdp/test/
    find_ion_source_file(PROG_SRC "${SRC_DIR}/cfdp" "${PROG}.c")
    if(NOT PROG_SRC)
      message(FATAL_ERROR "Source file for ${PROG} not found in ION-DTN cfdp/ subdirectories")
    endif()
    add_executable(${PROG} ${PROG_SRC})
    target_include_directories(${PROG} PRIVATE ${INC_DIR})
    target_link_libraries(${PROG} PRIVATE cfdpcore_static bpcore_static icicore_static m pthread)
    set_target_properties(${PROG} PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
    )
  endif()
endforeach()

# ionrestart executable (only build if it's in the master PROGRAMS list)
if("ionrestart" IN_LIST ALL_PROGRAMS)
  find_ion_source_file(IONRESTART_SRC "${SRC_DIR}/restart" "ionrestart.c")
  if(NOT IONRESTART_SRC)
    message(FATAL_ERROR "Source file for ionrestart not found in ION-DTN restart/ subdirectories")
  endif()
  add_executable(ionrestart ${IONRESTART_SRC})
  target_include_directories(ionrestart PRIVATE ${INC_DIR})
  target_link_libraries(ionrestart PRIVATE cfdpcore_static ltpcore_static bpcore_static icicore_static m pthread)
  set_target_properties(ionrestart PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
  )
endif()

# ionwatch executable (requires ICI, LTP, and BP libraries)
if("ionwatch" IN_LIST ALL_PROGRAMS)
  find_ion_source_file(IONWATCH_SRC "${SRC_DIR}/ici" "ionwatch.c")
  if(NOT IONWATCH_SRC)
    message(FATAL_ERROR "Source file for ionwatch not found in ION-DTN ici/ subdirectories")
  endif()
  add_executable(ionwatch ${IONWATCH_SRC})
  target_include_directories(ionwatch PRIVATE ${INC_DIR})
  target_link_libraries(ionwatch PRIVATE ltpcore_static bpcore_static icicore_static m pthread)
  set_target_properties(ionwatch PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
  )
endif()

# bpinspect executable (multiple source files)
if("bpinspect" IN_LIST ALL_PROGRAMS)
  set(BPINSPECT_SOURCES)
  find_ion_source_file(BPINSPECT_MAIN "${SRC_DIR}/bpv7" "bpinspect.c")
  find_ion_source_file(BPINSPECT_DATA "${SRC_DIR}/bpv7" "bpinspect_data.c")
  find_ion_source_file(BPINSPECT_FILTER "${SRC_DIR}/bpv7" "bpinspect_filter.c")
  find_ion_source_file(BPINSPECT_OPS "${SRC_DIR}/bpv7" "bpinspect_ops.c")

  if(NOT BPINSPECT_MAIN OR NOT BPINSPECT_DATA OR NOT BPINSPECT_FILTER OR NOT BPINSPECT_OPS)
    message(FATAL_ERROR "One or more source files for bpinspect not found in ION-DTN bpv7/ subdirectories")
  endif()

  list(APPEND BPINSPECT_SOURCES ${BPINSPECT_MAIN} ${BPINSPECT_DATA} ${BPINSPECT_FILTER} ${BPINSPECT_OPS})
  add_executable(bpinspect ${BPINSPECT_SOURCES})
  target_include_directories(bpinspect PRIVATE ${INC_DIR})
  target_link_libraries(bpinspect PRIVATE bpcore_static icicore_static m pthread)
  set_target_properties(bpinspect PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
  )
endif()

# Copy utility scripts from ION-DTN to bin directory
set(ION_SCRIPTS ionstart ionstart.awk ionstop killm ionprocesses.txt)
foreach(SCRIPT IN LISTS ION_SCRIPTS)
  configure_file(
    ${SRC_DIR}/${SCRIPT}
    ${BIN_DIR}/${SCRIPT}
    COPYONLY
  )
endforeach()

install(TARGETS ${ALL_PROGRAMS}
  RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
)

# Man Pages (only programs with .pod files)
set(MAN_PROGRAMS
  ${ICI_PROGRAMS}
  ${BP_EXECUTABLES}
  ${LTP_PROGRAMS}
  ${CFDP_PROGRAMS}
  ionrestart
)
# Exclude ionwarn, ltpdeliv from MAN Pages
list(REMOVE_ITEM MAN_PROGRAMS ionwarn ltpdeliv)


# Man pages generation using pod2man
set(MAN_PAGES)
foreach(PROG IN LISTS MAN_PROGRAMS)
  # Search for pod file in multiple locations (ION-DTN structure has pod files in doc/pod1 subdirectories)
  set(POD_FILE "POD_FILE-NOTFOUND")
  set(POD_SEARCH_PATHS
    ${SRC_DIR}/man
    ${SRC_DIR}/ici/doc/pod1
    ${SRC_DIR}/bpv7/doc/pod1
    ${SRC_DIR}/ltp/doc/pod1
    ${SRC_DIR}/cfdp/doc/pod1
    ${SRC_DIR}/restart/doc/pod1
  )

  foreach(POD_PATH IN LISTS POD_SEARCH_PATHS)
    if(EXISTS "${POD_PATH}/${PROG}.pod")
      set(POD_FILE "${POD_PATH}/${PROG}.pod")
      break()
    endif()
  endforeach()

  # Skip if pod file not found
  if(POD_FILE STREQUAL "POD_FILE-NOTFOUND")
    message(WARNING "Pod file not found for program: ${PROG}")
    continue()
  endif()

  set(MAN_FILE ${MAN_DIR}/${PROG}.1)
  set(MAN_GZ_FILE ${MAN_DIR}/${PROG}.1.gz)
  list(APPEND MAN_PAGES ${MAN_GZ_FILE})

  # Generate .1 file from .pod using pod2man
  add_custom_command(
    OUTPUT ${MAN_FILE}
    COMMAND pod2man --section=1 --center="ION-Core Manual" --release="ION-Core ${PROJECT_VERSION}" ${POD_FILE} ${MAN_FILE}
    DEPENDS ${POD_FILE}
    COMMENT "Generating man page ${MAN_FILE}"
    VERBATIM
  )

  # Compress .1 file to .gz
  add_custom_command(
    OUTPUT ${MAN_GZ_FILE}
    COMMAND gzip -f -c ${MAN_FILE} > ${MAN_GZ_FILE}
    DEPENDS ${MAN_FILE}
    COMMENT "Compressing man page to ${MAN_GZ_FILE}"
    VERBATIM
  )
endforeach()

# Concept man pages (section 3) — non-program library/feature documentation.
set(CONCEPT_MAN_PAGES_3)
set(CONCEPT_MAN_NAMES cbr)  # custody transfer + compressed bundle reporting
set(POD3_SEARCH_PATHS
  ${SRC_DIR}/man
  ${SRC_DIR}/bpv7/doc/pod3
  ${SRC_DIR}/ici/doc/pod3
  ${SRC_DIR}/cfdp/doc/pod3
  ${SRC_DIR}/ltp/doc/pod3
)
foreach(NAME IN LISTS CONCEPT_MAN_NAMES)
  set(POD_FILE "")
  foreach(POD_PATH IN LISTS POD3_SEARCH_PATHS)
    if(EXISTS "${POD_PATH}/${NAME}.pod")
      set(POD_FILE "${POD_PATH}/${NAME}.pod")
      break()
    endif()
  endforeach()
  if(NOT POD_FILE)
    message(STATUS "Concept pod for ${NAME} (section 3) not found; skipping.")
    continue()
  endif()
  set(MAN_FILE ${MAN_DIR}/${NAME}.3)
  set(MAN_GZ_FILE ${MAN_DIR}/${NAME}.3.gz)
  list(APPEND CONCEPT_MAN_PAGES_3 ${MAN_GZ_FILE})
  add_custom_command(
    OUTPUT ${MAN_FILE}
    COMMAND pod2man --section=3 --center="ION-Core Manual" --release="ION-Core ${PROJECT_VERSION}" ${POD_FILE} ${MAN_FILE}
    DEPENDS ${POD_FILE}
    COMMENT "Generating section-3 man page ${MAN_FILE}"
    VERBATIM
  )
  add_custom_command(
    OUTPUT ${MAN_GZ_FILE}
    COMMAND gzip -f -c ${MAN_FILE} > ${MAN_GZ_FILE}
    DEPENDS ${MAN_FILE}
    COMMENT "Compressing man page to ${MAN_GZ_FILE}"
    VERBATIM
  )
endforeach()

# Custom target to build all man pages as part of the default build
add_custom_target(man ALL DEPENDS ${MAN_PAGES} ${CONCEPT_MAN_PAGES_3})

# Install ICI libraries
install(TARGETS icicore_static
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)
install(TARGETS icicore_shared
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

# Add BP libraries 
install(TARGETS bpcore_static
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)
install(TARGETS bpcore_shared
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

# Install CFDP libraries
install(TARGETS cfdpcore_static
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)
install(TARGETS cfdpcore_shared
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

# Install LTP libraries
install(TARGETS ltpcore_static
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)
install(TARGETS ltpcore_shared
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

# Install header files
install(DIRECTORY ${ION_DTN_DIR}/ici/include/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include/ion-core
  FILES_MATCHING PATTERN "*.h"
)
install(DIRECTORY ${ION_DTN_DIR}/bpv7/include/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include/ion-core
  FILES_MATCHING PATTERN "*.h"
)
install(DIRECTORY ${ION_DTN_DIR}/ltp/include/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include/ion-core
  FILES_MATCHING PATTERN "*.h"
)
install(DIRECTORY ${ION_DTN_DIR}/cfdp/include/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include/ion-core
  FILES_MATCHING PATTERN "*.h"
)

# Configure and install pkg-config file
configure_file(
  ${CMAKE_SOURCE_DIR}/ion-core.pc.in
  ${CMAKE_BINARY_DIR}/ion-core.pc
  @ONLY
)
install(FILES ${CMAKE_BINARY_DIR}/ion-core.pc
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig
)

install(PROGRAMS
  ${BIN_DIR}/ionstart
  ${BIN_DIR}/ionstart.awk
  ${BIN_DIR}/ionstop
  ${BIN_DIR}/killm
  DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
)
install(FILES
  ${BIN_DIR}/ionprocesses.txt
  DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
)
# Install man pages
install(FILES ${MAN_PAGES}
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/man/man1
  PERMISSIONS OWNER_READ GROUP_READ WORLD_READ
)
if(CONCEPT_MAN_PAGES_3)
  install(FILES ${CONCEPT_MAN_PAGES_3}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/man/man3
    PERMISSIONS OWNER_READ GROUP_READ WORLD_READ
  )
endif()

# Clean_all target: remove all build artifacts (but keep .gitkeep files)
add_custom_target(clean_all
  COMMAND ${CMAKE_COMMAND} -E remove -f ${LIB_DIR}/* !${LIB_DIR}/.gitkeep
  COMMAND ${CMAKE_COMMAND} -E remove -f ${BIN_DIR}/* !${BIN_DIR}/.gitkeep !${BIN_DIR}/ionstart !${BIN_DIR}/ionstart.awk !${BIN_DIR}/ionstop !${BIN_DIR}/killm !${BIN_DIR}/ionprocesslist.sh
  COMMAND ${CMAKE_COMMAND} -E remove -f ${MAN_DIR}/* !${MAN_DIR}/.gitkeep
  COMMENT "Cleaning all build artifacts while preserving essential files"
)


# Distclean target
# Note: Only cleans build artifacts and the legacy src/inc directories (used by extract.sh method)
# Does NOT clean the external/ION-DTN submodule directory
add_custom_target(distclean
  COMMAND find ${CMAKE_SOURCE_DIR}/inc -mindepth 1 ! -name '.gitkeep' -delete 2>/dev/null || true
  COMMAND find ${CMAKE_SOURCE_DIR}/src -mindepth 1 ! -name '.gitkeep' -delete 2>/dev/null || true
  COMMAND find ${LIB_DIR} -mindepth 1 ! -name '.gitkeep' -delete
  COMMAND find ${BIN_DIR} -mindepth 1 ! -name '.gitkeep' -delete
  COMMAND find ${MAN_DIR} -mindepth 1 ! -name '.gitkeep' -delete
  COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/system_up
  COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/configs
  COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/scripts/macOS/install_macos_sysctl.sh
  COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/scripts/macOS/sysctl_script.sh
  COMMENT "Removing all build artifacts and legacy extracted source files while preserving .gitkeep files"
)

# Generate list of executable paths for uninstall
set(ALL_PROGRAMS_FILES)
foreach(PROG IN LISTS ALL_PROGRAMS)
  list(APPEND ALL_PROGRAMS_FILES ${CMAKE_INSTALL_PREFIX}/bin/${PROG})
endforeach()

# Generate list of man page paths for uninstall
set(MAN_PAGES_FILES)
foreach(PROG IN LISTS MAN_PROGRAMS)
  list(APPEND MAN_PAGES_FILES ${CMAKE_INSTALL_PREFIX}/share/man/man1/${PROG}.1.gz)
endforeach()

add_custom_target(uninstall
  COMMAND ${CMAKE_COMMAND} -E remove -f
    ${CMAKE_INSTALL_PREFIX}/lib/libicicore.a
    ${CMAKE_INSTALL_PREFIX}/lib/libicicore.so
    ${CMAKE_INSTALL_PREFIX}/lib/libbpcore.a
    ${CMAKE_INSTALL_PREFIX}/lib/libbpcore.so
    ${CMAKE_INSTALL_PREFIX}/lib/libltpcore.a
    ${CMAKE_INSTALL_PREFIX}/lib/libltpcore.so
    ${CMAKE_INSTALL_PREFIX}/lib/libcfdpcore.a
    ${CMAKE_INSTALL_PREFIX}/lib/libcfdpcore.so
  COMMAND ${CMAKE_COMMAND} -E remove -f
    ${ALL_PROGRAMS_FILES}
    ${CMAKE_INSTALL_PREFIX}/bin/ionstart
    ${CMAKE_INSTALL_PREFIX}/bin/ionstart.awk
    ${CMAKE_INSTALL_PREFIX}/bin/ionstop
    ${CMAKE_INSTALL_PREFIX}/bin/killm
    ${CMAKE_INSTALL_PREFIX}/bin/ionprocesslist.sh
  COMMAND ${CMAKE_COMMAND} -E remove -f
    ${MAN_PAGES_FILES}
  COMMAND ${CMAKE_COMMAND} -E remove -f
    ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/ion-core.pc
  COMMAND ${CMAKE_COMMAND} -E remove_directory
    ${CMAKE_INSTALL_PREFIX}/include/ion-core
  COMMENT "Uninstalling ION-Core: libraries, binaries, scripts, man pages, headers, pkg-config"
)

# --- Test Target ---
# This section mimics the 'test' target from your Makefile.
# It uses the 'COMBINATION_TESTS' variable defined in build-list.cmake.

set(ALL_TESTS_TO_RUN "")

foreach(COMBO_ENTRY IN LISTS COMBINATION_TESTS)
  # Split the combination entry into program part and test part
  string(REPLACE ":" ";" COMBO_PARTS "${COMBO_ENTRY}")
  list(GET COMBO_PARTS 0 COMB_PROGS_STR)
  list(GET COMBO_PARTS 1 TESTS_TO_RUN_STR)

  # Convert the program combination string to a CMake list
  string(REPLACE "+" ";" CURRENT_COMBO_PROGS "${COMB_PROGS_STR}")
  # Convert the tests to run string to a CMake list. No regex replace to preserve slashes.
  string(REPLACE "+" ";" CLEANED_TESTS_TO_RUN "${TESTS_TO_RUN_STR}")
  
  set(COMB_FOUND TRUE)
  foreach(PROG IN LISTS CURRENT_COMBO_PROGS)
    # Check if the program exists in the ALL_PROGRAMS list
    list(FIND ALL_PROGRAMS "${PROG}" PROG_INDEX)
    if(PROG_INDEX EQUAL -1)
      set(COMB_FOUND FALSE)
      break()
    endif()
  endforeach()

  if(COMB_FOUND)
    message(STATUS "Combination found: ${COMB_PROGS_STR}. Adding tests: ${CLEANED_TESTS_TO_RUN}")
    list(APPEND ALL_TESTS_TO_RUN ${CLEANED_TESTS_TO_RUN})
  else()
    message(STATUS "Combination not found (one or more programs not built): ${COMB_PROGS_STR}")
  endif()
endforeach()

# Pass the CMake list directly to the COMMAND, so each element is a separate argument.
add_custom_target(test
  COMMAND ${CMAKE_COMMAND} -E echo "TESTS_DIR: ${TESTS_DIR}"
  COMMAND ${CMAKE_COMMAND} -E echo "Checking if TESTS_DIR exists..."
  COMMAND test -d ${TESTS_DIR} || (echo "ERROR: TESTS_DIR does not exist: ${TESTS_DIR}" && exit 1)
  COMMAND ${CMAKE_COMMAND} -E echo "Changing to TESTS_DIR and running tests..."
  COMMAND ${CMAKE_COMMAND} -E chdir ${TESTS_DIR} ./runtests ${ALL_TESTS_TO_RUN}
  COMMENT "Running selected tests based on enabled programs (mimics Makefile 'test' target)."
)