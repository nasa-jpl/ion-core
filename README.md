# ION-Core

- [ION-Core](#ion-core)
  - [Preliminary Notes](#preliminary-notes)
- [Method 1: CMake Build with Git Submodule (Recommended)](#method-1-cmake-build-with-git-submodule-recommended)
- [Method 2: Makefile Build with extract.sh (Legacy)](#method-2-makefile-build-with-extractsh-legacy)
    - [Selecting ION-core Features to Build (Method 2)](#selecting-ion-core-features-to-build-method-2)
    - [Extension Blocks Build Options (Method 2)](#extension-blocks-build-options-method-2)
    - [Man Page Installation (Method 2)](#man-page-installation-method-2)
    - [Building static and dynamic library (Method 2)](#building-static-and-dynamic-library-method-2)
    - [Post-installation Test (Method 2)](#post-installation-test-method-2)
    - [Clean up process (Method 2)](#clean-up-process-method-2)
    - [Automated Script to Build, Install, and Test Ion-core on Two Hosts (Method 2)](#automated-script-to-build-install-and-test-ion-core-on-two-hosts-method-2)
- [Creating ION configuration (".rc") files for a two-node setup](#creating-ion-configuration-rc-files-for-a-two-node-setup)
- [Adjusting Pre-Allocation of Memory/Storage Space for ION](#adjusting-pre-allocation-of-memorystorage-space-for-ion)
- [Tuning LTP Performance](#tuning-ltp-performance)
- [Prototype: macOS Build](#prototype-macos-build)
- [Prototype: FreeBSD Build Considerations](#prototype-freebsd-build-considerations)
- [CMake Build System - Detailed Reference](#cmake-build-system---detailed-reference)
  - [CMake Build Commands Reference](#cmake-build-commands-reference)
  - [Detailed Build, Test, and Cleanup Process](#detailed-build-test-and-cleanup-process)
    - [Prerequisites](#prerequisites)
    - [1. Build the Project](#1-build-the-project)
    - [2. Install the Project](#2-install-the-project)
    - [3. Test the Project](#3-test-the-project)
    - [4. Uninstall the Project](#4-uninstall-the-project)
    - [5. Clean Up Build Artifacts](#5-clean-up-build-artifacts)
    - [6. Perform Full Cleanup](#6-perform-full-cleanup)
    - [7. Remove Build Directory](#7-remove-build-directory)
    - [8. Verify Project State](#8-verify-project-state)
  - [Additional CMake Notes](#additional-cmake-notes)
- [Contributing Code](#contributing-code)
- [WSL2 Networking Issue](#wsl2-networking-issue)
- [Release Notes](#release-notes)
  - [Latest Release Tag: `4.2.0-b`](#latest-release-tag-420-b)
  - [Tag: `4.1.4`](#tag-414)
  - [Tag: `4.1.3s`](#tag-413s)
  - [Tag: `4.1.3s-a.1`](#tag-413s-a1)
  - [Tag: `4.1.3`](#tag-413)
  - [Tag: `4.1.2b`](#tag-412b)
  - [Tag: `4.1.2a`](#tag-412a)
  - [Tag: `4.1.2`](#tag-412)

## Preliminary Notes

Ion-core assumes the typical Linux OS installation location for `make` and `gcc`.

Each ion-core version is designed to work with the corresponding version of ION Open Source release, e.g., ion-core 4.2.0-b uses the ION open-source release version 4.2.0-b as its sources.

**For CMake builds (Method 1):**
- **Default:** Uses ION source code from the git submodule at `external/ION-DTN` (preserves full commit history)
- **Alternative:** Specify a custom ION source directory using the `ION_SOURCE_DIR` CMake option
- **No extract.sh required:** CMake builds use the ION source files directly from their original hierarchical directory structure
- **No symbolic links:** Does not populate `src/`, `inc/`, or `test/` directories with symbolic links
- Uses ION source files without modifications

**For Makefile builds (Method 2):**
- **Requires extract.sh:** The `extract.sh` script must be run to prepare source files
- **Symbolic links:** Creates absolute path symbolic links in `src/`, `inc/`, and `test/` directories pointing to the ION-DTN repo
- **Flat directory structure:** All source and header files are linked into flat directories (no subdirectories)
- **Important:** If you move the ION-DTN repo or the ion-core repo, you must re-run `./scripts/extract.sh` to update the symbolic links

**Note on source modifications (Makefile builds only):**
- **ION 4.1.4-b.1 and later:** The extract script modifies one ION source file (`bpsec_policy_rule.c`) to adjust an include path for compatibility with the flat symbolic link structure. The modification changes `#include "../../utils/bpsecadmin_config.h"` to `#include "bpsecadmin_config.h"`. The original source file in the ION open source repo is not modified.
- **Earlier versions:** The extract script modifies two ION source files (`bpsec_policy_rule.c`, `bpextension.c`) and places copies inside the `src` folder. The modifications are very minor and only to the extent needed to allow ion-core build to turn-on/off selected extension blocks.

---
# Method 1: CMake Build with Git Submodule (Recommended)

This method uses CMake and includes ION-DTN source code as a git submodule, preserving full commit history.

**Prerequisites:**
```bash
sudo apt update
sudo apt install make gcc cmake git
```

**Build steps:**
```bash
# Clone ion-core repository
git clone https://github.com/nasa-jpl/ion-core-dev.git
cd ion-core-dev

# Initialize and setup the ION-DTN submodule
./scripts/setup-submodule.sh

# Create build directory and configure
mkdir -p build
cd build
cmake ..

# Build and install
make
sudo make install
sudo ldconfig  # Linux only
```

**Note:** The `setup-submodule.sh` script initializes the ION-DTN submodule non-recursively (avoiding private nested submodules) and configures sparse-checkout to only include required directories. The ION-DTN version is automatically read from the `ION_DTN_VERSION` file.

**Using a custom ION source directory:**

If you want to use a different ION source directory instead of the submodule:
```bash
cmake -DION_SOURCE_DIR=/path/to/your/ION-DTN ..
make
sudo make install
```

**Generate man pages:**
```bash
make man
```

**For full build, test, and cleanup instructions using CMake, see [CMake Build System - Detailed Reference](#cmake-build-system---detailed-reference)**

---

# Method 2: Makefile Build with extract.sh (Legacy)

This method uses traditional Makefiles and requires running the `extract.sh` script to create symbolic links to ION source files in flat `src/`, `inc/`, and `test/` directories.

**Prerequisites:**
```bash
sudo apt update
sudo apt install make gcc
```

**Option A: Using an existing ION-DTN repository**

Clone the ION open source code repo:
```bash
cd <ion-source-code-folder>
git clone https://github.com/nasa-jpl/ION-DTN.git
```

Get ion-core and build:
```bash
git clone https://github.com/nasa-jpl/ion-core-dev.git
cd ion-core-dev
git checkout tags/4.2.0-b
# clean out previous build
make clean
sudo make uninstall
# build
./scripts/extract.sh <your-ion-source-code-folder>/ION-DTN
make
sudo make install
sudo ldconfig  # Linux only
```

**Option B: Automated download without commit history**

You can run `./scripts/extract.sh` without supplying a path. The script will automatically download the appropriate ION open source code version to the `tmp` folder:

```bash
git clone https://github.com/nasa-jpl/ion-core-dev.git
cd ion-core-dev
./scripts/extract.sh
make
sudo make install
sudo ldconfig  # Linux only
```

**Note:** This approach downloads a tarball without git history. You won't be able to submit pull requests to ION-DTN. This is provided as a convenience for quick testing.

**Generate man pages:**
```bash
make man
```

### Selecting ION-core Features to Build (Method 2)

You can select the features you want to include in ion-core build by updating the `build-list.mk` file. See the `build-list.mk` file for the list of features.

At least one CLA must be selected. All necessary programs/daemons associated with a feature or a CLA are listed on one line, so when commenting/uncommenting features, please do so at the "line level", not the individual program.

You can select build for either 32-bit or 64-bit and for Linux or MacOS (darwin).

You can also select which bundle protocol extension blocks to include for locally sourced bundles.

Save the changes to the `build-list.mk`, remove the old installation by running `make clean`, `sudo make uninstall`, and then rebuild ion-core.

### Extension Blocks Build Options (Method 2)

As of ion-core 4.1.3s, the `build-list.mk` file enables toggling which extension blocks will be added to locally created bundle. Here are some of the limitations:

1. Support for all extension blocks types, however, remains mandatory:
    * `PBN_EXT` : Previous Node Extension Block
    * `BPQ_EXT` : Bundle Protocol QoS Extension Block
    * `BAE_EXT` : Bundle Age Extension Block
    * `SNW_EXT` : Spray and Wait Permit Extension Block
    * `IMC_EXT` : IMC Multicast Extension Block
2. There is not yet control through `build-list.mk` to set whether each locally created extension block should use CRC16, CRC32, or none applied. The default value is `noCRC` in the `./scripts/bpextension-ion-core.c`.
3. The file `./scripts/bpextension-ion-core.c` is manually derived from the ION open-source; it is modified to support the toggling of which extension blocks to include in locally created bundle.
4. __This is the only ION source file modified by ion-core release using the legacy Makefile build (Method 2). This modification is manually performed by the ion-core development team right now. This file is re-evaluated for each ion-core release to make sure it is taylored for the most likely use case for users. The user of ion-core can further modify it to suite their deployment/testing needs.__

### Man Page Installation (Method 2)

Run:

`sudo make man`

### Building static and dynamic library (Method 2)

To build and install static linking library for ION, execute the following command:

```bash
# build the static library
make static

# build the dynamic library
make shared

# install the libraries
sudo make install-lib

# uninstall the libraries
sudo make uninstall-lib
```

### Post-installation Test (Method 2)

After installation, you can run the following command to test the installation for each of the CLAs included in the build:

```bash
make test
```

The result of the test will be captured in a file called `progress` under the `tests` directory.

### Clean up process (Method 2)

To remove executables and libraries installed in the host, run: `sudo make clean`
To clean up the compilation artifacts, run: `make clean`
To remove all complication artifacts, as well as all ION source and test files extracted from the ION open source code, run: `make distclean`

### Automated Script to Build, Install, and Test Ion-core on Two Hosts (Method 2)

To streamline the process, we have created two bash scripts that can automate the build, installation, and testing of ion-core.

To build and install ion-core, run:

`./scripts/build-install.sh`

To run a bping test between two nodes. On host A, run
`./scripts/bping-send.sh <IP Address of Host A> <IP Address of the Host B> <opt: udp or stcp>`

On host B, run

`./scripts/bping-echo.sh <IP Address of Host B> <IP Address of the Host A> <opt: udp or stcp>`

Note:
* This script will automatically create the ION configuration files needed and launch a `bping` test using BP and LTP CLA.
* To ensure that all bping messages will be received by the peer DTN node, it is recommended that you run bping-echo on the second host first, and then run bping-send on the first host.
* Both `bping-send.sh` and `bping-echo.sh` takes an optional 3rd argument to specify either the `udp` or `stcp` CLAs. But they must be the same on both hosts to ensure compatibility.

On `bping` side, you will see ION starting and then bping launched automatically with output similar to the following:

```bash
... Wait 10 seconds for the other side to start ION...

run bping...
64 bytes from ipn:12.2  seq=0 time=0.003641 s
64 bytes from ipn:12.2  seq=1 time=0.001756 s
64 bytes from ipn:12.2  seq=2 time=0.001767 s
64 bytes from ipn:12.2  seq=3 time=0.001590 s
64 bytes from ipn:12.2  seq=4 time=0.001676 s
64 bytes from ipn:12.2  seq=5 time=0.001711 s
64 bytes from ipn:12.2  seq=6 time=0.001766 s
64 bytes from ipn:12.2  seq=7 time=0.001742 s
64 bytes from ipn:12.2  seq=8 time=0.001675 s
64 bytes from ipn:12.2  seq=9 time=0.001663 s
10 bundles transmitted, 10 bundles received, 0.00% bundle loss, time 19.003910 s
rtt min/avg/max/sdev = 1.590/1.898/3.641/0.585 ms

bping SUCCESS!
```

On the receiving (echo) side, you will likely see:

```bash
Start bpecho...., Ctrl-C to stop.
..........
```
Each `.` indicates that an 'echo' message has been sent back to acknowledge the reception of a 'bping' messages.

The test will end once the bping recieved echos for all ping messages.

At this point, ION will be running on both hosts and you may continue to run different applications until you stop ION by executing the `ionstop` script, which is globally installed for execution.

This test also generates two directories that you can use as template for future ION testing:

* `hostxx_testdir` - this directory contains the ION configuration files for host A, whose IP address ends in `xx`.
* `hostyy_testdir` - this directory contains the ION configuration files for host A, whose IP address ends in `yy`.

Within in each folder, you will find the ION log file `ion.log` which records the main events during previous runs and also, if present, current/on-going running instance of ION.

To launch ION manually, you will need to enter into the directory and execute the command `ionstart -I hostxx.rc`

Using the generated ION configuration folder, you can only launch one ION instance per host. To ability to run multiple ION instances in one host is utilized in automated regression testing (recall `make test`) and is a advanced topic described in the [ION online documentation](https://nasa-jpl.github.io/ION-DTN/).

# Creating ION configuration (".rc") files for a two-node setup

`./scripts/host.sh <IP-this-host> <IP-the-other-host>`

For example:

`./scripts/host.sh 192.168.254.192 192.168.254.194`

Makes the config file `host192.rc` and places it inside the folder `host192_testdir`. You can run lauch ION by cd into the directory `cd host192_testdir` and run `ionstart -I host192.rc`.

For the other host, run the same command with the order of IP addresses reversed.

The default protocol stack is BP/LTP but you can select the UDP or STCP CLAs if they are included in the `build-list.mk`.

To generate configuration files using either UDP or the STCP CLA, add either `udp` or `stcp` as the third argument to `host.sh`. For example,  to generate configuration using STCP, run 

`./scripts/host.sh 192.168.254.192 192.168.254.194` stcp

Similar syntax goes for udp.

To use other convergence layers such as UDP or STCP, you will need to modify the .rc files. See the ION documentation for more information. For example, you may consult the [ION Configuration Tutorials and Configuration Templates.](https://nasa-jpl.github.io/ION-DTN/Basic-Configuration-File-Tutorial/)

# Adjusting Pre-Allocation of Memory/Storage Space for ION

ION is designed to run within a pre-allocated memory space. If, while running ION, you encounter errors due to a lack of working memory or SDR heap space, you can increase the pre-allocated allocation by modifying the `host.ionconfig` file and then regenerate configuration files using the `./scripts/host.sh` command. The current default ION SDR and working memory allocation is as follows:

```
configFlags 1
heapWords 15000000
sdrWmSize 15000000
wmSize 15000000
```

The `configFlags` value of 1 creates a Simple Data Recorder (SDR) instance in DRAM. The SDR provides the primary data storage for ION. The 'heap' space, where user data are buffered, is set to 15 mega words, each word is 64 bits (or 8 bytes) for a 64-bit platform. The `sdrWmSize` specifies the SDR's internal working memory space measured in bytes; the `wmSize` specifies the general ION working memory in bytes.

These values can be adjusted to control how much storage ION is allowed to consume in the host system. The proper setting requires some insight into the host system's capabilities, the traffic load ION is expected to handle as impacted by locally generated DTN traffic, and the average and peak inbound and outbound data rates of the network.

Pleaser consult the `ionconfig` manual page for a detailed explanation of the full set of configuration parameters.

# Tuning LTP Performance

Actual throughput of LTP link protocol depends significantly on the underlying radio communication or wired network speed and reliability, the host system's processing speed, the frequency of communication contact, the size of the bundles being sent, the round trip delay between the two hosts, and also on the LTP configuration. Check the `ltprc` manual page entry for details on how to adjust LTP settings to maximize throughput.

In the ION source code's root directory, there is an Excel file named `ION-LTP-configuration_tool.xlsm` which can be used to generate recommended LTP settings for your configuration to maximize the throughput of your system.

# Prototype: macOS Build

The process for building ion-core on macOS follows the same steps as the Linux build process. However, there are some differences that need to be addressed:

1. The `ldconfig` command is not available on macOS, and not necessary.
2. Although ion-core can be build on macOS as it is, exerpimentation showed that several default kernel parameters that control shared memory and UDP datagram sizes should be modified in order to support basic ION operations and UDP traffic. Without these modification, ION will not function properly or at all due to resource limitations.
3. __Minimum Recommended Setting:__ Under the `scripts/macOS` directory, there is a `sysctl_script.sh` script that checks whether these parameters meet or exceed certain minimum, recommended values, as follows:

    ```bash
    kern.sysv.shmmax = 83886080
    kern.sysv.shmseg = 32
    kern.sysv.shmall = 32768
    net.inet.udp.maxdgram = 32000
    ```

This set of minimum values are sufficient to pass the regression tests under the `tests` folder in the ION Open Source repository.

4. While the minimum recommended values can support basic ION operations, they are not sufficient to support the more intenstive bench tests under the `demos` folder in the ION Open Source repository. Therefore a more generous configuration is as follows:
  
    ```bash
    kern.sysv.shmmax=2147483648
    kern.sysv.shmseg=32  
    kern.sysv.shmall=1048576 
    net.inet.udp.maxdgram=655360 
    ``` 
5. This higher recommended setting, for your convenience, can be implemented using the `install_macos_sysctl.sh` script so that it will persist through shutdown and reboot. After executing this script, make sure you reboot the system for the changes to take effect.
  * Note: the `net.inet.udp.maxdgram` value is set to 655360 (640KB), 10 times larger than the maximum UDP datagram 65535 (64KB). For reasons not clear at this point, setting this much larger value actually enables smoother handling of UDP datagrams pass them through `localhost`.
6. In the end, we recommend you experiment and adjust these kernel parameters to fit the specific needs of your application. These scripts provide the basic template on what paramters to check and adjust and how to implement them.

# Prototype: FreeBSD Build Considerations

1. The default make command for FreeBSD is `bmake.` ION require `gmake`. So you can either invoke `gmake` or create a symbolic link to `gmake` as `make`.

# CMake Build System - Detailed Reference

CMake is the recommended build method for ion-core as of version 4.1.4. For basic build instructions, see the [Build & Install](#build--install) section. This section provides detailed CMake command reference and advanced usage.

**Key features:**
- Uses ION-DTN as a git submodule (`external/ION-DTN`)
- Supports custom ION source directory via `-DION_SOURCE_DIR` option
- Automatically searches for pod files in ION-DTN's distributed documentation structure
- Safe `distclean` target that preserves the submodule

**Key Change:** Project configuration (like enabled programs, OS flags, and extension flags) is now primarily controlled by `build-list.cmake`. This file acts as the central configuration for your build.

## CMake Build Commands Reference

The following commands are used to manage the build process in a `build` directory:

* **Configure the build system**:

    ```bash
    cmake ..
    ```

    This command generates build files (e.g., `Makefile`) based on `CMakeLists.txt` and the settings in `build-list.cmake`. Run this from your `build` directory.

* **Build the project**:

    ```bash
    make
    ```

    This compiles libraries (e.g., `libicicore.a`, `libbpcore.so`) and executables (e.g., `ionadmin`, `bpadmin`) into the project's `lib` and `bin` directories.

* **Generate man pages**:

    ```bash
    make man
    ```

    This creates compressed man pages (e.g., `man/ionadmin.1.gz`) from `.pod` files.

* **Install the project**:

    ```bash
    sudo make install
    ```

    This installs libraries to `/usr/local/lib`, executables and scripts to `/usr/local/bin`, and man pages to `/usr/local/share/man/man1`.

* **Uninstall the project**:

    ```bash
    sudo make uninstall
    ```

    This removes installed files from `/usr/local/lib`, `/usr/local/bin`, and `/usr/local/share/man/man1`.

* **Clean build artifacts**:

    ```bash
    make clean_all
    ```

    This removes files generated during the build in `lib`, `bin`, and `man` directories, while preserving essential files like `.gitkeep` and specific scripts.

* **Full cleanup**:

    ```bash
    make distclean
    ```

    This performs a complete cleanup, removing all extracted source files, headers, and all generated files in `src`, `inc`, `lib`, `bin`, `man`, `tests`, and other specific project files.

* **Verbose output (for debugging)**:

    ```bash
    make <target> VERBOSE=1
    ```

    Shows detailed command execution (e.g., `make uninstall VERBOSE=1`).

## Detailed Build, Test, and Cleanup Process

Follow these steps to manage your ION-Core project. The process assumes you're starting from the project root directory and working with the CMake build system.

### Prerequisites

* Verify required tools: CMake (3.10+), make, gcc, pod2man, gzip.

    ```bash
    cmake --version
    gcc --version
    pod2man --version
    gzip --version
    ```

* **Setup ION-DTN submodule** (if not already done):

    ```bash
    ./scripts/setup-submodule.sh
    ```

    This initializes the ION-DTN submodule, checks out the correct version from `ION_DTN_VERSION`, and configures sparse-checkout.

* **Clean submodule** (if you need to reinitialize):

    ```bash
    ./scripts/clean-submodule.sh
    ```

    Use this to completely remove and clean the submodule state. After cleaning, run `setup-submodule.sh` again to reinitialize.

* Create a `build` directory (if not already present) and navigate into it:

    ```bash
    mkdir build
    cd build
    ```

### 1. Build the Project

**Purpose**: Compile libraries, executables, and prepare for man page generation.

1.  **Configure CMake**:

    ```bash
    cmake ..
    ```

    * This step reads `CMakeLists.txt` and `build-list.cmake` to set up the build system.
    * Check for errors; if found, ensure the ION source is available and `build-list.cmake` is correctly configured.

2.  **Build libraries and executables**:

    ```bash
    make
    ```

    * This compiles libraries and executables based on the programs enabled in `build-list.cmake`.
    * Verify artifacts:

        ```bash
        ls ../lib ../bin
        ```

3.  **Generate man pages**:

    ```bash
    make man
    ```

    * This creates compressed man pages for programs included in `MAN_PROGRAMS` as configured via `build-list.cmake`.
    * Verify:

        ```bash
        ls ../man/*.1.gz
        ```

### 2. Install the Project

**Purpose**: Install built components to the system's `/usr/local` directory.

1.  **Install**:

    ```bash
    sudo make install
    ```

    * This installs libraries, executables, scripts, and man pages. CMake automatically ensures man pages are generated before installation.
    * Verify:

        ```bash
        ls /usr/local/lib/libicicore*
        ls /usr/local/bin/ionadmin
        ls /usr/local/share/man/man1/ionadmin.1.gz
        ```

### 3. Test the Project

**Purpose**: Validate the built executables using test suites configured in `build-list.cmake`.

1.  **Run Tests**:

    ```bash
    make test
    ```

    * This command uses the test mapping defined in `build-list.cmake` to execute the relevant `runtests` script with the specified test suites.
    * Verify test results by examining the output in your terminal.

### 4. Uninstall the Project

**Purpose**: Remove installed files from `/usr/local`.

1.  **Uninstall**:

    ```bash
    sudo make uninstall
    ```

    * This removes libraries, executables, scripts, and man pages installed previously.
    * Verify by checking that the files are no longer present in the installation paths.

### 5. Clean Up Build Artifacts

**Purpose**: Remove intermediate build artifacts from the project's build directories.

1.  **Clean**:

    ```bash
    make clean_all
    ```

    * This clears build artifacts from `lib`, `bin`, and `man` directories.

### 6. Perform Full Cleanup

**Purpose**: Remove all extracted source files, headers, and all generated files to return the project to a pristine state.

1.  **Distclean**:

    ```bash
    make distclean
    ```

    * This removes all build-related files and symbolic links.

### 7. Remove Build Directory

**Purpose**: Delete the `build` directory.

1.  **Remove**:

    ```bash
    cd ..
    rm -rf build
    ```

### 8. Verify Project State

**Purpose**: Confirm the project directory is clean and ready for a fresh build or archiving.

1.  **Check root**:

    ```bash
    ls -a .
    ```

    * You should mainly see source control files, original build scripts, and empty directories marked with `.gitkeep`.

## Additional CMake Notes

* **Permissions**: Use `sudo` for `make install` and `make uninstall`. User permissions suffice for other commands.

* **Version Management**: ION-Core now uses a centralized version file (`ION_DTN_VERSION`) that controls which ION-DTN release to use:
    * Edit `ION_DTN_VERSION` to change the ION-DTN version (e.g., `ion-open-source-4.1.4-b.1`)
    * The ION-CORE version is automatically derived (e.g., `ION-CORE-4.1.4-b.1`)
    * All build systems (Makefile, CMake) and scripts read from this file
    * To update ION-DTN version:
        1. Edit `ION_DTN_VERSION` with the new tag
        2. Run `./scripts/clean-submodule.sh` to clean the existing submodule
        3. Run `./scripts/setup-submodule.sh` to checkout the new version
        4. Rebuild with `cmake .. && make`

* **Configuration via `build-list.cmake`**: This file now defines:
    * The ION-DTN tag (read from `ION_DTN_VERSION`)
    * The project version (`VER`) derived from the ION-DTN tag
    * Platform-specific compiler flags (`OS_FLAGS`)
    * Extension flags (`EXT_FLAGS`)
    * The list of all programs (`PROGRAMS`) to be built and installed
    * The mapping of program combinations to test suites (`COMBINATION_TESTS`)
    * Modify `build-list.cmake` to customize your build configuration

* **Custom Install Prefix**: If you specify a custom installation prefix (e.g., `cmake -DCMAKE_INSTALL_PREFIX=/custom/path ..`), remember to adjust your verification paths accordingly.

* **Rebuilding after `distclean`**: After running `make distclean`, the ION source files may need to be re-initialized depending on your setup (submodule or custom source directory).

* **Submodule Management Scripts**:
    * `./scripts/setup-submodule.sh` - Initialize and configure the ION-DTN submodule
    * `./scripts/clean-submodule.sh` - Clean and deinitialize the submodule for fresh setup
    * Both scripts read the ION-DTN version from `ION_DTN_VERSION`
    * Use `--help` flag for detailed usage information

# Contributing Code

Please see the file `developer_notes.txt` for more information.

# WSL2 Networking Issue

WLS2 is known to have issues with VPN connection. One approach is to downgrade to WSL1:

In Windows Powershell get your name/version:

`wsl -l -v`

Set it to version 1:

`wsl --set-version Ubuntu-22.04 1`

Alternative approach is to use the WSL Vpnkit to provide VPN connection:

https://github.com/sakai135/wsl-vpnkit

# Release Notes

## Latest Release Tag: `4.2.0-b`

7/10/2026
Update codebase to ION open source version 4.2.0-b (`ion-open-source-4.2.0-b`).

* Submodule pinned to ION-DTN tag `ion-open-source-4.2.0-b` (see `ION_DTN_VERSION`).
* Mandatory new upstream dependencies wired into both build methods:
  * `ici/library/ion_atomic.c` + `ici/include/ion_atomic.h` — new atomics helpers now pulled in unconditionally by `ion.h` (batched-statistics support).
  * `bpv7/ipn/cbdedup.c` + `cbdedup.h` — critical-bundle forward de-duplication now called by `ipnfw.c`.
  * `ici/library/platform_smP.h` — new private header included by `libbpP.c`, `libcfdpP.c`, `libltpP.c`, and `rfx.c`.
* New BP utility `bpwatch` (from `bpv7/utils/`) is built and installed.
* `-DENABLE_IMC` added to `EXT_FLAGS` in both build lists: 4.2.0 gates the IMC handler table (in `bpextensions.c`) and the IMC forwarding path (in `libbpP.c`) on `ENABLE_IMC`, which replaced 4.1.x's unconditional IMC. Without it the IMC sources compile but never register, silently disabling multicast.
* Darwin build flags now pass `-D__unix__`: 4.2.0 gates the "All UNIX platforms" block in `platform.h` on `__unix__` (4.1.x used bare `unix`); Apple clang predefines neither, so Darwin must supply it explicitly. Matches ION's `configure.ac`.
* Test harness fixes for 4.2.0: `extract.sh` now links the new `tests/test_utils.sh` (sourced by `runtests`) and the renamed `tests/pretest-script.sh` (was `pretest-script`; it exports `CONFIGSROOT`, without which canned-config tests such as `bping` cannot start their node).
* BSL (BPSec Library, new `bpv7/bsl/`) is intentionally **not** bundled; `USING_BSL` stays `0`. BSL support is planned for a release after ION-Core 4.2.1.
* Verified: both build methods build clean on 64-bit Linux and macOS (arm64). Regression/bench set on Linux: `custody-simple`, `crs-simple`, `bping`, `bptrace_terminal_test`, `issue-352-bpcp-ltp`, `issue-352-bpcp-stcp`, `bench-cfdp`, `bench-stcp` all pass; `bench-ltp` skips unless the kernel UDP buffers are tuned (`net.core.rmem_max >= 4 MB`).

## Tag: `4.1.4`

4/29/2026
Update codebase to ION open source version 4.1.4 (`ion-open-source-4.1.4`).

* Submodule pinned to ION-DTN tag `ion-open-source-4.1.4` (see `ION_DTN_VERSION`).
* Both build methods now work against 4.1.4 stable:
  * **Method 1 (CMake, recommended):** updated source list and include paths for new ION sources (`cbr.c`, `cteb.c`, `creb.c`); removed `bpversion` (deleted upstream); replaced `ionprocesslist.sh` with `ionprocesses.txt` (consumed by `killm`).
  * **Method 2 (extract.sh + Makefile, legacy):** `mdir/libbp.mk` updated for new BP sources; new `mdir/cbrcustodytest.mk`; `mdir/psmwatch.mk` now links the full ICI library (4.1.4 `psmwatch` calls `ionAttach`/`getIonsdr`/`sdr_*`); `extract.sh` now copies (instead of symlinking) the one file it modifies, so the ION-DTN submodule working tree stays clean across branch switches.
* New BP utility `cbrcustodytest` (from `bpv7/test/`) is built and installed; used by the two new regression tests below.
* New regression tests added to the `make test` set, both drawn from ION's `cbr-ct-orange-book/` test suite:
  * `custody-simple` — end-to-end Custody Transfer with CCS-based release.
  * `crs-simple` — Compressed Reporting Signal (CRS) status reporting.
* Man pages:
  * `cbrcustodytest(1)` — tool man page, generated automatically by both build methods.
  * `cbr(3)` — concept man page covering Custody Transfer (CT) and Compressed Bundle Reporting (CRS), drawn from upstream `bpv7/doc/pod3/cbr.pod`. New section-3 generation and install support added to `make-man-pages.sh`, the Makefile, and CMakeLists.txt.
* Verified: 9/9 regression tests pass under both build methods on 64-bit Linux.

## Tag: `4.1.3s`

7/3/2025
Update codebase to ION open source verion 4.1.3s - BPSec prototype is still considered experimental, therefore not included in this release. Following updates were made:
  * Reorganized source file symbolic links into subfolders by module name
  * Created a CMake prototype for experimentation
  * Fixed bug for `ionadmin` to display correct ION version number instead of "unknown"
  * Added `bpcp` related regression tests for LTP and STCP convergence layers

## Tag: `4.1.3s-a.1`

1/5/2025
* First alpha release for 4.1.3s
* Switch to 4.1.3s ION open source codebase
* Switch to using symbolic link (instead of copying source code file) to preserve original Git history and support upstream code push to Open Source
* Improved OS support for compilation 

## Tag: `4.1.3`

9/24/2024
* Update codebase to ION open source verion 4.1.3
* Add regression test for each available CLA
* Add target to build static and shared libraries

## Tag: `4.1.2b`

Added ability to select/exclude certain features from build

## Tag: `4.1.2a`

2/01/2024
* Added STCP CLA to ver 4.1.2

## Tag: `4.1.2`

11/30/2023
* Based on ION Open Source 4.1.2
* Initial public release of ion-core (prototype)
* Basic features:
  * BPv7
  * CGR
  * LTP
  * UDPCL
  * IPN Nameing Scheme
  * Load-n-Go Command


