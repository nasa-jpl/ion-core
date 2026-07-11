#!/usr/bin/env bash

# Exit on any error
set -e

# Trap any errors and display a message before exiting
trap 'echo "Error: $0 failed at line $LINENO. Exiting..."; exit 1' ERR

# Log environment details for debugging
echo "Running $0 at $(date)"
echo "Current directory: $(pwd)"
echo "User: $(whoami)"
echo "Environment variables:"
env
echo "Checking required tools..."
command -v wget >/dev/null 2>&1 || { echo "Error: wget is required but not installed."; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "Error: tar is required but not installed."; exit 1; }
command -v realpath >/dev/null 2>&1 || { echo "Error: realpath is required but not installed."; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "Error: dirname is required but not installed."; exit 1; }
command -v sed >/dev/null 2>&1 || { echo "Error: sed is required but not installed."; exit 1; }

# Determine OS type
UNAME_S=$(uname -s)

# Update sed syntax for macOS and FreeBSD
if [ "$UNAME_S" = "Darwin" ] || [ "$UNAME_S" = "FreeBSD" ]; then
  SED_INPLACE="-i ''"
else
  SED_INPLACE="-i"
fi

# Display Help Menu
function display_help() {
    echo "Usage: $0 [source_path]"
    echo
    echo "This script automates the setup for ION-Core by downloading the specified version,"
    echo "extracting it, and preparing the environment for compilation."
    echo
    echo "Arguments:"
    echo "  source_path    Optional. The path to download and extract the ION-Core source."
    echo "                 If not provided, '<repo_root>/tmp/ion-open-source-<version>' will be used."
    echo
    echo "Environment Variables:"
    echo "  ION_CORE_ROOT  Optional. Path to the ION-Core repository root. Defaults to the parent of the script's directory."
    echo
    echo "Example:"
    echo "  $0              # Uses default path"
    echo "  $0 custom/path  # Uses 'custom/path' for the operation"
    echo "  ION_CORE_ROOT=/path/to/repo $0  # Specifies repository root"
    exit 1
}

# Check for help argument
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    display_help
fi

# Get the full path of the script's directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Determine the root directory of ion-core
if [[ -n "$ION_CORE_ROOT" ]]; then
  ROOT_DIR=$(realpath "$ION_CORE_ROOT")
else
  ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
fi

# Verify root directory exists
if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Error: Root directory $ROOT_DIR does not exist."
  exit 1
fi

# Read ION-DTN version from ION_DTN_VERSION file
VERSION_FILE="$ROOT_DIR/ION_DTN_VERSION"
if [[ ! -f "$VERSION_FILE" ]]; then
  echo "Error: ION_DTN_VERSION file not found at $VERSION_FILE"
  exit 1
fi

# Read the tag, skipping comments and empty lines
ION_DTN_TAG=$(grep -v '^#' "$VERSION_FILE" | grep -v '^[[:space:]]*$' | head -n1 | tr -d '[:space:]')
if [[ -z "$ION_DTN_TAG" ]]; then
  echo "Error: No valid tag found in $VERSION_FILE"
  exit 1
fi

# Extract version number from tag (e.g., "ion-open-source-4.1.3s" -> "4.1.3s")
ION_VER=$(echo "$ION_DTN_TAG" | sed -E 's/^ion-open-source-//')
echo "Using ION-DTN version: $ION_VER"

# Set the source URL using the full tag name
ION_SRC_ZIP="https://github.com/nasa-jpl/ION-DTN/archive/refs/tags/$ION_DTN_TAG.tar.gz"

# Check if a source path was provided
if [[ -z "$1" ]]; then
  SOURCE_PATH="$ROOT_DIR/tmp/ion-open-source-$ION_VER"
  rm -rf "$SOURCE_PATH" || { echo "Error: Failed to remove $SOURCE_PATH"; exit 1; }
  mkdir -p "$SOURCE_PATH" || { echo "Error: Failed to create $SOURCE_PATH"; exit 1; }
  echo "No source path specified. ION $ION_VER will be downloaded to location: $SOURCE_PATH"
  if wget -O "$ROOT_DIR/ion-open-source-$ION_VER.tar.gz" "$ION_SRC_ZIP"; then
    tar -xzf "$ROOT_DIR/ion-open-source-$ION_VER.tar.gz" -C "$SOURCE_PATH" --strip-components 1 || { echo "Error: Failed to extract tarball"; exit 1; }
    rm -f "$ROOT_DIR/ion-open-source-$ION_VER.tar.gz" || { echo "Error: Failed to remove tarball"; exit 1; }
    echo "Download and extraction successful."
  else
    echo "Error: Download failed for $ION_SRC_ZIP"
    exit 1
  fi
else
  if [[ "$1" = /* ]]; then
    SOURCE_PATH="$1"
  else
    SOURCE_PATH="$(pwd)/$1"
  fi
  SOURCE_PATH=$(realpath "$SOURCE_PATH")
  echo "Using provided source path: $SOURCE_PATH"
  if [[ ! -d "$SOURCE_PATH" ]]; then
    echo "Error: Source path $SOURCE_PATH does not exist."
    exit 1
  fi
fi

# Set the output directories
SRC="$ROOT_DIR/src"
INC="$ROOT_DIR/inc"
OUT_BIN="$ROOT_DIR/bin"
MAN="$ROOT_DIR/man"
TESTS="$ROOT_DIR/tests"

# Function to clear the content of a directory
clear_directory() {
    local dir="$1"
    if [ -d "$dir" ] && [ "$(ls -A "$dir")" ]; then
        echo "Clearing contents of: $dir"
        rm -rf "$dir"/* || { echo "Error: Failed to clear $dir"; exit 1; }
    else
        echo "Directory $dir is empty or does not exist."
    fi
}

# Clear the directories
clear_directory "$SRC"
clear_directory "$INC"
clear_directory "$OUT_BIN"
clear_directory "$TESTS"

# Create module subdirectories under src
mkdir -p "$SRC/ici" "$SRC/bpv7" "$SRC/cfdp" "$SRC/ltp" "$SRC/restart" || { echo "Error: Failed to create src subdirectories"; exit 1; }

# List of source files to link
SOURCES=(
  "$SOURCE_PATH/bpv7/bibe/bibe.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/instr/bpsec_instr.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_event.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_eventset.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_rule.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/bcb_aes_gcm_sc.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/bib_hmac_sha2_sc.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/ion_test_sc.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/rfc9173_utils.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sc_util.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sc_value.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sci_valmap.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sci.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/utils/bpsec_asb.c:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/utils/bpsec_util.c:bpv7"
  "$SOURCE_PATH/bpv7/cgr/libcgr.c:bpv7"
  "$SOURCE_PATH/bpv7/daemon/bpclm.c:bpv7"
  "$SOURCE_PATH/bpv7/daemon/bpclock.c:bpv7"
  "$SOURCE_PATH/bpv7/daemon/bptransit.c:bpv7"
  "$SOURCE_PATH/bpv7/imc/libimcfw.c:bpv7"
  "$SOURCE_PATH/bpv7/ipn/cbdedup.c:bpv7"
  "$SOURCE_PATH/bpv7/ipn/ipnadmin.c:bpv7"
  "$SOURCE_PATH/bpv7/ipn/ipnadminep.c:bpv7"
  "$SOURCE_PATH/bpv7/ipn/ipnfw.c:bpv7"
  "$SOURCE_PATH/bpv7/ipn/libipnfw.c:bpv7"
  "$SOURCE_PATH/bpv7/library/bei.c:bpv7"
  "$SOURCE_PATH/bpv7/library/eureka.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bae/bae.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpq/bpq.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/cteb/cteb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/creb/creb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpsec/bcb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpsec/bib.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/hcb/hcb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/imc/imc.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/meb/meb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/pnb/pnb.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/snw/snw.c:bpv7"
  "$SOURCE_PATH/bpv7/library/libbp.c:bpv7"
  "$SOURCE_PATH/bpv7/library/libbpP.c:bpv7"
  "$SOURCE_PATH/bpv7/library/cbr.c:bpv7"
  "$SOURCE_PATH/bpv7/ltp/ltpcli.c:bpv7"
  "$SOURCE_PATH/bpv7/ltp/ltpclo.c:bpv7"
  "$SOURCE_PATH/bpv7/saga/saga.c:bpv7"
  "$SOURCE_PATH/bpv7/stcp/stcpcli.c:bpv7"
  "$SOURCE_PATH/bpv7/stcp/stcpclo.c:bpv7"
  "$SOURCE_PATH/bpv7/stcp/libstcpcla.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpchat.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpcounter.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpdriver.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpecho.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bping.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpsink.c:bpv7"
  "$SOURCE_PATH/bpv7/test/bpsource.c:bpv7"
  "$SOURCE_PATH/bpv7/test/cbrcustodytest.c:bpv7"
  "$SOURCE_PATH/bpv7/udp/libudpcla.c:bpv7"
  "$SOURCE_PATH/bpv7/udp/udpcli.c:bpv7"
  "$SOURCE_PATH/bpv7/udp/udpclo.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpadmin.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpcancel.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_data.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_filter.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_ops.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bplist.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bprecvfile.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpsendfile.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpstats.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bptrace.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpwatch.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/bptracker.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/lgagent.c:bpv7"
  "$SOURCE_PATH/bpv7/utils/lgsend.c:bpv7"
  "$SOURCE_PATH/cfdp/bp/bputa.c:cfdp"
  "$SOURCE_PATH/cfdp/daemon/cfdpclock.c:cfdp"
  "$SOURCE_PATH/cfdp/library/libcfdp.c:cfdp"
  "$SOURCE_PATH/cfdp/library/libcfdpops.c:cfdp"
  "$SOURCE_PATH/cfdp/library/libcfdpP.c:cfdp"
  "$SOURCE_PATH/cfdp/test/cfdptest.c:cfdp"
  "$SOURCE_PATH/cfdp/utils/bpcp.c:cfdp"
  "$SOURCE_PATH/cfdp/utils/bpcpd.c:cfdp"
  "$SOURCE_PATH/cfdp/utils/cfdpadmin.c:cfdp"
  "$SOURCE_PATH/ici/bulk/STUB_BULK/bulk.c:ici"
  "$SOURCE_PATH/ici/crypto/NULL_SUITES/csi.c:ici"
  "$SOURCE_PATH/ici/daemon/rfxclock.c:ici"
  "$SOURCE_PATH/ici/library/cbor.c:ici"
  "$SOURCE_PATH/ici/library/crc.c:ici"
  "$SOURCE_PATH/ici/library/ion.c:ici"
  "$SOURCE_PATH/ici/library/ion_atomic.c:ici"
  "$SOURCE_PATH/ici/library/ion_network.c:ici"
  "$SOURCE_PATH/ici/library/ionsec.c:ici"
  "$SOURCE_PATH/ici/library/lyst.c:ici"
  "$SOURCE_PATH/ici/library/memmgr.c:ici"
  "$SOURCE_PATH/ici/library/platform_sm.c:ici"
  "$SOURCE_PATH/ici/library/platform.c:ici"
  "$SOURCE_PATH/ici/library/psm.c:ici"
  "$SOURCE_PATH/ici/library/radix.c:ici"
  "$SOURCE_PATH/ici/library/rfx.c:ici"
  "$SOURCE_PATH/ici/library/smlist.c:ici"
  "$SOURCE_PATH/ici/library/smrbt.c:ici"
  "$SOURCE_PATH/ici/library/sptrace.c:ici"
  "$SOURCE_PATH/ici/library/zco.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrcatlg.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrhash.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrlist.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrmgt.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrstring.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrtable.c:ici"
  "$SOURCE_PATH/ici/sdr/sdrxn.c:ici"
  "$SOURCE_PATH/ici/utils/ionadmin.c:ici"
  "$SOURCE_PATH/ici/utils/ionwarn.c:ici"
  "$SOURCE_PATH/ici/utils/ionwatch.c:ici"
  "$SOURCE_PATH/ici/utils/psmwatch.c:ici"
  "$SOURCE_PATH/ici/utils/sdrwatch.c:ici"
  "$SOURCE_PATH/ici/test/owltsim.c:ici"
  "$SOURCE_PATH/ltp/daemon/ltpclock.c:ltp"
  "$SOURCE_PATH/ltp/daemon/ltpdeliv.c:ltp"
  "$SOURCE_PATH/ltp/daemon/ltpmeter.c:ltp"
  "$SOURCE_PATH/ltp/library/ext/ltpextensions.c:ltp"
  "$SOURCE_PATH/ltp/library/libltp.c:ltp"
  "$SOURCE_PATH/ltp/library/libltpP.c:ltp"
  "$SOURCE_PATH/ltp/library/ltpei.c:ltp"
  "$SOURCE_PATH/ltp/sda/libsda.c:ltp"
  "$SOURCE_PATH/ltp/udp/libudplsa.c:ltp"
  "$SOURCE_PATH/ltp/udp/udplsi.c:ltp"
  "$SOURCE_PATH/ltp/udp/udplso.c:ltp"
  "$SOURCE_PATH/ltp/utils/ltpadmin.c:ltp"
  "$SOURCE_PATH/ltp/utils/ltpwatch.c:ltp"
  "$SOURCE_PATH/ltp/utils/ltpstats.c:ltp"
  "$SOURCE_PATH/restart/utils/ionrestart.c:restart"
)

HEADERS=(
  "$SOURCE_PATH/bpv7/bibe/bibe.h:bpv7"
  "$SOURCE_PATH/bpv7/bibe/bibeP.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/instr/bpsec_instr.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_event.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_eventset.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_rule.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/bcb_aes_gcm_sc.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/bib_hmac_sha2_sc.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/ion_test_sc.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/rfc9173_utils.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sc_util.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sc_value.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sci_structs.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sci_valmap.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/sci/sci.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/utils/bpsec_asb.h:bpv7"
  "$SOURCE_PATH/bpv7/bpsec/utils/bpsec_util.h:bpv7"
  "$SOURCE_PATH/bpv7/dtn2/dtn2fw.h:bpv7"
  "$SOURCE_PATH/bpv7/imc/imcfw.h:bpv7"
  "$SOURCE_PATH/bpv7/ipn/cbdedup.h:bpv7"
  "$SOURCE_PATH/bpv7/include/bp.h:bpv7"
  "$SOURCE_PATH/bpv7/include/bp_admin.h:bpv7"
  "$SOURCE_PATH/bpv7/include/eureka.h:bpv7"
  "$SOURCE_PATH/bpv7/ipn/ipnfw.h:bpv7"
  "$SOURCE_PATH/bpv7/library/bei.h:bpv7"
  "$SOURCE_PATH/bpv7/library/bpP.h:bpv7"
  "$SOURCE_PATH/bpv7/library/cbr.h:bpv7"
  "$SOURCE_PATH/bpv7/library/cbrP.h:bpv7"
  "$SOURCE_PATH/bpv7/library/cgr.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bae/bae.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpextensions.c:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpq/bpq.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/cteb/cteb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/creb/creb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpsec/bcb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/bpsec/bib.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/hcb/hcb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/imc/imc.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/meb/meb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/pnb/pnb.h:bpv7"
  "$SOURCE_PATH/bpv7/library/ext/snw/snw.h:bpv7"
  "$SOURCE_PATH/bpv7/ltp/ltpcla.h:bpv7"
  "$SOURCE_PATH/bpv7/saga/saga.h:bpv7"
  "$SOURCE_PATH/bpv7/stcp/stcpcla.h:bpv7"
  "$SOURCE_PATH/bpv7/udp/udpcla.h:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_data.h:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_filter.h:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpinspect_ops.h:bpv7"
  "$SOURCE_PATH/bpv7/utils/bpsecadmin_config.h:bpv7"
  "$SOURCE_PATH/bpv7/utils/jsmn.h:bpv7"
  "$SOURCE_PATH/cfdp/include/bputa.h:cfdp"
  "$SOURCE_PATH/cfdp/include/cfdp.h:cfdp"
  "$SOURCE_PATH/cfdp/include/cfdpops.h:cfdp"
  "$SOURCE_PATH/cfdp/library/cfdpP.h:cfdp"
  "$SOURCE_PATH/cfdp/utils/bpcp.h:cfdp"
  "$SOURCE_PATH/ici/crypto/csi_debug.h:ici"
  "$SOURCE_PATH/ici/include/bulk.h:ici"
  "$SOURCE_PATH/ici/include/cbor.h:ici"
  "$SOURCE_PATH/ici/include/crc.h:ici"
  "$SOURCE_PATH/ici/include/crypto.h:ici"
  "$SOURCE_PATH/ici/include/csi.h:ici"
  "$SOURCE_PATH/ici/include/ion.h:ici"
  "$SOURCE_PATH/ici/include/ion_atomic.h:ici"
  "$SOURCE_PATH/ici/include/ion_network.h:ici"
  "$SOURCE_PATH/ici/include/ionsec.h:ici"
  "$SOURCE_PATH/ici/include/lyst.h:ici"
  "$SOURCE_PATH/ici/include/memmgr.h:ici"
  "$SOURCE_PATH/ici/include/platform_sm.h:ici"
  "$SOURCE_PATH/ici/include/platform.h:ici"
  "$SOURCE_PATH/ici/include/psm.h:ici"
  "$SOURCE_PATH/ici/include/radix.h:ici"
  "$SOURCE_PATH/ici/include/rfx.h:ici"
  "$SOURCE_PATH/ici/include/sdr.h:ici"
  "$SOURCE_PATH/ici/include/sdrhash.h:ici"
  "$SOURCE_PATH/ici/include/sdrlist.h:ici"
  "$SOURCE_PATH/ici/include/sdrmgt.h:ici"
  "$SOURCE_PATH/ici/include/sdrstring.h:ici"
  "$SOURCE_PATH/ici/include/sdrtable.h:ici"
  "$SOURCE_PATH/ici/include/sdrxn.h:ici"
  "$SOURCE_PATH/ici/include/smlist.h:ici"
  "$SOURCE_PATH/ici/include/smrbt.h:ici"
  "$SOURCE_PATH/ici/include/sptrace.h:ici"
  "$SOURCE_PATH/ici/include/zco.h:ici"
  "$SOURCE_PATH/ici/library/lystP.h:ici"
  "$SOURCE_PATH/ici/library/platform_smP.h:ici"
  "$SOURCE_PATH/ici/library/radixP.h:ici"
  "$SOURCE_PATH/ici/sdr/sdrP.h:ici"
  "$SOURCE_PATH/ltp/include/ltp.h:ltp"
  "$SOURCE_PATH/ltp/include/ltp_admin.h:ltp"
  "$SOURCE_PATH/ltp/include/sda.h:ltp"
  "$SOURCE_PATH/ltp/library/ltpei.h:ltp"
  "$SOURCE_PATH/ltp/library/ltpP.h:ltp"
  "$SOURCE_PATH/ltp/udp/udplsa.h:ltp"
)

SCRIPTS=(
  "$SOURCE_PATH/ionstart"
  "$SOURCE_PATH/ionstop"
  "$SOURCE_PATH/ionstart.awk"
  "$SOURCE_PATH/ionprocesses.txt"
  "$SOURCE_PATH/killm"
)

MANPAGE=(
  "$SOURCE_PATH/bpv7/doc/pod1/bpadmin.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpchat.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpclm.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpclock.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpcounter.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpdriver.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpecho.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpinspect.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bping.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bplist.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpcancel.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bprecvfile.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpsendfile.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpsink.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpsource.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bpstats.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bptrace.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bptracker.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/bptransit.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/cbrcustodytest.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod3/cbr.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/ipnadmin.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/ipnadminep.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/ipnfw.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/lgagent.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/lgsend.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/ltpcli.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/ltpclo.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/stcpcli.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/stcpclo.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/udpcli.pod:bpv7"
  "$SOURCE_PATH/bpv7/doc/pod1/udpclo.pod:bpv7"
  "$SOURCE_PATH/cfdp/doc/pod1/bpcp.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod1/bpcpd.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod1/bputa.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod1/cfdpadmin.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod1/cfdpclock.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod1/cfdptest.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod3/cfdp.pod:cfdp"
  "$SOURCE_PATH/cfdp/doc/pod5/cfdprc.pod:cfdp"
  "$SOURCE_PATH/ici/doc/pod1/ionadmin.pod:ici"
  "$SOURCE_PATH/ici/doc/pod1/ionwatch.pod:ici"
  "$SOURCE_PATH/ici/doc/pod1/owltsim.pod:ici"
  "$SOURCE_PATH/ici/doc/pod1/psmwatch.pod:ici"
  "$SOURCE_PATH/ici/doc/pod1/rfxclock.pod:ici"
  "$SOURCE_PATH/ici/doc/pod1/sdrwatch.pod:ici"
  "$SOURCE_PATH/ltp/doc/pod1/ltpadmin.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/ltpclock.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/ltpmeter.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/ltpwatch.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/ltpstats.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/udplsi.pod:ltp"
  "$SOURCE_PATH/ltp/doc/pod1/udplso.pod:ltp"
  "$SOURCE_PATH/restart/doc/pod1/ionrestart.pod:restart"
)

TEST_SCRIPTS=(
  "$SOURCE_PATH/tests/runtests"
  "$SOURCE_PATH/tests/test_utils.sh"
  "$SOURCE_PATH/tests/cleanup"
  "$SOURCE_PATH/tests/setacs.sh"
  "$SOURCE_PATH/tests/pretest-script.sh"
)

TEST_DIRS=(
  "$SOURCE_PATH/demos/bench-udp"
  "$SOURCE_PATH/demos/bench-ltp"
  "$SOURCE_PATH/demos/bench-stcp"
  "$SOURCE_PATH/demos/bench-cfdp"
  "$SOURCE_PATH/tests/bptrace_terminal_test"
  "$SOURCE_PATH/tests/bping"
  "$SOURCE_PATH/tests/issue-352-bpcp-ltp"
  "$SOURCE_PATH/tests/issue-352-bpcp-stcp"
  "$SOURCE_PATH/tests/cbr-ct-orange-book/custody-simple"
  "$SOURCE_PATH/tests/cbr-ct-orange-book/crs-simple"
)

# Extract .c files
echo "Extracting source .c files from $SOURCE_PATH to $SRC"
count=0
while [ "x${SOURCES[count]}" != "x" ]; do
    IFS=':' read -r target module <<< "${SOURCES[count]}"
    filename=$(basename "$target")
    destination="$SRC/$module/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Source file missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Extract .h files
echo "Extracting header .h files from $SOURCE_PATH to $INC"
count=0
while [ "x${HEADERS[count]}" != "x" ]; do
    IFS=':' read -r target module <<< "${HEADERS[count]}"
    filename=$(basename "$target")
    destination="$INC/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Header file missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Extract ION scripts
echo "Extracting ION scripts from $SOURCE_PATH to $OUT_BIN"
count=0
while [ "x${SCRIPTS[count]}" != "x" ]; do
    target="${SCRIPTS[count]}"
    filename=$(basename "$target")
    destination="$OUT_BIN/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Script file missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Extract man page .pod files
echo "Linking man page .pod files from $SOURCE_PATH to $SRC/man"
mkdir -p "$SRC/man" || { echo "Error: Failed to create $SRC/man"; exit 1; }
count=0
while [ "x${MANPAGE[count]}" != "x" ]; do
    IFS=':' read -r target module <<< "${MANPAGE[count]}"
    filename=$(basename "$target")
    destination="$SRC/man/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Man page file missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Extract regression test scripts
echo "Extracting test scripts from $SOURCE_PATH to $TESTS"
count=0
while [ "x${TEST_SCRIPTS[count]}" != "x" ]; do
    target="${TEST_SCRIPTS[count]}"
    filename=$(basename "$target")
    destination="$TESTS/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Test script missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Link the 'system_up' script
echo "Linking 'system_up' script in root directory"
rm -f "$ROOT_DIR/system_up" || { echo "Error: Failed to remove $ROOT_DIR/system_up"; exit 1; }
ln -s "$SOURCE_PATH/system_up" "$ROOT_DIR/system_up" || { echo "Error: Failed to link $SOURCE_PATH/system_up"; exit 1; }

# For macOS, link the sysctl scripts
if [ "$UNAME_S" = "Darwin" ]; then
    echo "Linking 'sysctl_script.sh' in root directory"
    mkdir -p "$ROOT_DIR/scripts/macos" || { echo "Error: Failed to create $ROOT_DIR/scripts/macos"; exit 1; }
    rm -f "$ROOT_DIR/scripts/macos/sysctl_script.sh" || { echo "Error: Failed to remove $ROOT_DIR/scripts/macos/sysctl_script.sh"; exit 1; }
    ln -s "$SOURCE_PATH/sysctl_script.sh" "$ROOT_DIR/scripts/macos/sysctl_script.sh" || { echo "Error: Failed to link sysctl_script.sh"; exit 1; }
    echo "Linking 'install_macos_sysctl.sh' in root directory"
    rm -f "$ROOT_DIR/scripts/macos/install_macos_sysctl.sh" || { echo "Error: Failed to remove $ROOT_DIR/scripts/macos/install_macos_sysctl.sh"; exit 1; }
    ln -s "$SOURCE_PATH/install_macos_sysctl.sh" "$ROOT_DIR/scripts/macos/install_macos_sysctl.sh" || { echo "Error: Failed to link install_macos_sysctl.sh"; exit 1; }
fi

# Extract canned test configs
echo "Linking canned configurations directory 'configs'"
rm -f "$ROOT_DIR/configs" || { echo "Error: Failed to remove $ROOT_DIR/configs"; exit 1; }
ln -s "$SOURCE_PATH/configs" "$ROOT_DIR/configs" || { echo "Error: Failed to link $SOURCE_PATH/configs to $ROOT_DIR/configs"; exit 1; }

# Extract test sets
echo "Extracting test sets from $SOURCE_PATH to $TESTS"
count=0
while [ "x${TEST_DIRS[count]}" != "x" ]; do
    target="${TEST_DIRS[count]}"
    filename=$(basename "$target")
    destination="$TESTS/$filename"
    if ln -s "$target" "$destination"; then
        echo "Linked $target to $destination"
    else
        echo "Error: Failed to link $target to $destination. Test directory missing or inaccessible."
        exit 1
    fi
    count=$((count + 1))
done

# Update bpsec_policy_rule.c
# Replace the symlink with a local copy and modify the include path.
# Editing the symlink target directly would dirty the ION-DTN submodule;
# using a copy keeps the upstream source tree pristine.
echo "Replacing bpsec_policy_rule.c symlink with a modified local copy"
linkpath="$SRC/bpv7/bpsec_policy_rule.c"
upstream="$SOURCE_PATH/bpv7/bpsec/policy/bpsec_policy_rule.c"
if [ ! -f "$upstream" ]; then
    echo "Error: upstream source $upstream not found."
    exit 1
fi
rm -f "$linkpath" || { echo "Error: Failed to remove $linkpath"; exit 1; }
cp "$upstream" "$linkpath" || { echo "Error: Failed to copy $upstream to $linkpath"; exit 1; }
sed $SED_INPLACE 's!#include "../../utils/bpsecadmin_config.h"!#include "bpsecadmin_config.h"!g' "$linkpath" || { echo "Error: Failed to modify $linkpath"; exit 1; }
echo "Applied modification to local copy: $linkpath (upstream $upstream untouched)"

echo "Done"
exit 0