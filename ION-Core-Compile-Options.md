# ION-Core Compile Options

This document covers the build-time options for ION-Core 4.2.0-b. Two build paths are supported: **CMake** (recommended) and **Makefile + `extract.sh`** (legacy). Most ION-Core feature selection is done by editing the build-list files (`build-list.cmake` for CMake, `build-list.mk` for the Makefile path), not via `cmake -D`.

## CMake Cache Options (set via `cmake -D`)

| Option | Default | Possible Values | Purpose |
|--------|---------|-----------------|---------|
| `ION_SOURCE_DIR` | `${CMAKE_SOURCE_DIR}/external/ION-DTN` | Any valid path | Use an ION-DTN source tree outside the submodule. The build fails fast if the directory does not exist. |
| `CMAKE_INSTALL_PREFIX` | `/usr/local` | Any valid path | Install destination for libraries, binaries, scripts, and man pages (sections 1 and 3). |
| `CMAKE_BUILD_TYPE` | (none — `-g` is forced via `add_compile_options`) | `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel` | Standard CMake optimization / debug profile. |
| `CMAKE_C_FLAGS` | (see "Compile Flags Applied" below) | Any valid C flags | Append or override compiler flags. |
| `CMAKE_SYSTEM_NAME` | Auto-detected | `Linux`, `Darwin`, `FreeBSD` | Used to select platform-specific defines (`-Dlinux`, `-Ddarwin`, `-Dfreebsd`). |

Examples:

```bash
# Use a hand-checked-out ION source tree instead of the submodule
cmake -DION_SOURCE_DIR=/path/to/ION-DTN ..

# Install under /opt/ion-core
cmake -DCMAKE_INSTALL_PREFIX=/opt/ion-core ..

# Build with optimization
cmake -DCMAKE_BUILD_TYPE=Release ..
```

## Submodule / Source Version

The ION-DTN tag the build is pinned to is **not** a CMake option — it lives in the file `ION_DTN_VERSION` at the repo root. `scripts/setup-submodule.sh` reads that file when initializing or updating the submodule.

```bash
$ cat ION_DTN_VERSION | grep -v '^#' | head -1
ion-open-source-4.2.0-b
```

To target a different ION-DTN tag, edit `ION_DTN_VERSION`, then:

```bash
./scripts/setup-submodule.sh --update
```

## Feature Selection (edit `build-list.*`)

### Programs (CLAs, utilities, daemons)

The set of programs to build is defined as a list:

- **CMake (Method 1):** `PROGRAMS` list in `build-list.cmake`.
- **Makefile (Method 2):** `PROGRAMS` variable in `build-list.mk`.

To exclude an optional component, comment out the line that adds it. At least one CLA (LTP, UDP, or STCP) must be included.

### BP Extension Blocks for locally sourced bundles

Extension blocks fall into three groups:

| Group | Blocks | How toggled |
|-------|--------|-------------|
| Enabled by default for outbound bundles | BPQ, IMC | `EXT_FLAGS` in `build-list.{cmake,mk}` (`-DBPQ_EXT`, `-DIMC_EXT` and, new in 4.2.0, `-DENABLE_IMC` which gates the IMC handler table and forwarding path) |
| Optional for outbound bundles | PNB, BAE, SNW | Add `-DPNB_EXT` / `-DBAE_EXT` / `-DSNW_EXT` to `EXT_FLAGS` |
| Always processed on receive (no toggle) | MEB, HCB, BIB, BCB, CTEB, CREB | Always compiled in |

CTEB and CREB are new in 4.1.4 and back the Custody Transfer / Compressed Bundle Reporting feature.

### Regression test set

Test combinations are listed in `COMBINATION_TESTS` in `build-list.cmake` (Method 1) or `build-list.mk` (Method 2). Each entry maps a set of required programs to one or more test directories under `external/ION-DTN/tests/` or `external/ION-DTN/demos/`. If the required programs are in `PROGRAMS`, the test is added to `make test`.

## Compile Flags Applied (Method 1)

The CMake build passes the following to every translation unit, in addition to user-supplied `CMAKE_C_FLAGS`:

```
-g -Wall -DBP_EXTENDED -fPIC
-DVNAME=ION-CORE-<version>      # from build-list.cmake (PROJECT_VERSION)
-DION_CORE_BUILD                # from build-list.cmake (ION_CORE_FLAG)
${EXT_FLAGS}                    # e.g. -DBPQ_EXT -DIMC_EXT
-Dlinux -DSPACE_ORDER=3 -fno-strict-aliasing   # 64-bit Linux
```

`SPACE_ORDER=3` corresponds to a 64-bit address space; on 32-bit builds it is set to `2`. Platform defines (`-Dlinux`, `-Ddarwin`, `-Dfreebsd`) are auto-set from `CMAKE_SYSTEM_NAME` and architecture detection.

## Compile Flags Applied (Method 2)

The Makefile path constructs `CFLAG` from the same building blocks (`OS_FLAGS`, `VER`, `ION_CORE_FLAG`, `BP_EXTENDED`, `EXT_FLAGS`) defined in `build-list.mk`. `extract.sh` flattens the ION-DTN source tree into `src/` symlinks and then writes a single local copy of `bpsec_policy_rule.c` with an adjusted include path; the upstream submodule tree is left pristine.

## Verification

To inspect what the configure step decided:

```bash
# show all CACHE values, including ION_SOURCE_DIR and CMAKE_INSTALL_PREFIX
cmake -LA | grep -E "ION_SOURCE_DIR|CMAKE_INSTALL_PREFIX|CMAKE_BUILD_TYPE"

# show the actual compile commands executed
make VERBOSE=1
```

To confirm the active ION-DTN tag:

```bash
git -C external/ION-DTN describe --tags
# expected: ion-open-source-4.2.0-b
```
