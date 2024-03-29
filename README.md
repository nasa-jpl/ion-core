# ION-Core for Linux (and WSL)

- [ION-Core for Linux (and WSL)](#ion-core-for-linux-and-wsl)
  - [Build \& Install](#build--install)
  - [Selecting ION-core Features to Build](#selecting-ion-core-features-to-build)
  - [Man Page Installation](#man-page-installation)
  - [Creating ION configuration (".rc") files for a two-node setup](#creating-ion-configuration-rc-files-for-a-two-node-setup)
  - [Automated Script to Build, Install, and Test Ion-core on Two Hosts](#automated-script-to-build-install-and-test-ion-core-on-two-hosts)
  - [Adjusting Pre-Allocation of Memory/Storage Space for ION](#adjusting-pre-allocation-of-memorystorage-space-for-ion)
  - [Tuning LTP Performance](#tuning-ltp-performance)
  - [Building Static Linking Library](#building-static-linking-library)
  - [Contributing Code](#contributing-code)
  - [WSL2 Networking Issue](#wsl2-networking-issue)
  - [Release Notes](#release-notes)

## Build & Install

Be sure you have the tools installed:
```bash
sudo apt update
sudo apt install make gcc
```

Get the ION Open Source Code:
```bash
wget https://sourceforge.net/projects/ion-dtn/files/ion-open-source-4.1.2.tar.gz
tar -zxvf ion-open-source-4.1.2.tar.gz
```

Get the ION-Core Repo, Extract Source File, Build and Install
```bash
git clone https://github.com/nasa-jpl/ion-core.git
cd ion-core
git checkout tags/4.1.2
./scripts/extract.sh ../ion-open-source-4.1.2
make
sudo make install
```

You can also run `./scripts/extract.sh` without supplying the path to an existing ION source code folder. In that case, the script will automatically download the appropriate ION open source code into a `./tmp` directory and extract the needed files into ion-core.

## Selecting ION-core Features to Build

You can select the features you want to include in ion-core build by updating the `build-list.mk` file. See the `build-list.mk` file for the list of features.

At least one CLA must be selected. All necessary programs/daemons associated with a feature or a CLA are listed on one line, so when commenting/uncommenting features, please do so at the "line level", not the individual program.

You can select build for either 32-bit or 64-bit Operating Systems.

You can also select which bundle protocol extension blocks to include for locally sourced bundles.

Save the changes to the `build-list.mk`, remove the old installation by running `make clean`, `sudo make uninstall`, and then rebuild ion-core.

## Man Page Installation

Run:

`sudo make man`

## Creating ION configuration (".rc") files for a two-node setup

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

## Automated Script to Build, Install, and Test Ion-core on Two Hosts

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

## Adjusting Pre-Allocation of Memory/Storage Space for ION

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

## Tuning LTP Performance

Actual throughput of LTP link protocol depends significantly on the underlying radio communication or wired network speed and reliability, the host system's processing speed, the frequency of communication contact, the size of the bundles being sent, the round trip delay between the two hosts, and also on the LTP configuration. Check the `ltprc` manual page entry for details on how to adjust LTP settings to maximize throughput.

In the ION source code's root directory, there is an Excel file named `ION-LTP-configuration_tool.xlsm` which can be used to generate recommended LTP settings for your configuration to maximize the throughput of your system.

## Building Static Linking Library

To build a static linking library for ION, execute the command `make lib`, and the static library `libioncore.a` will be created in the `lib` directory. All the related object files are under the `lib/object` folder.

## Contributing Code

Please see the file `developer_notes.txt` for more information.

## WSL2 Networking Issue

WLS2 is known to have issues with VPN connection. One approach is to downgrade to WSL1:

In Windows Powershell get your name/version:

`wsl -l -v`

Set it to version 1:

`wsl --set-version Ubuntu-22.04 1`

Alternative approach is to use the WSL Vpnkit to provide VPN connection:

https://github.com/sakai135/wsl-vpnkit



--------------------------

## Release Notes

Latest Release

Tag: `4.1.2a`

2/01/2024

* Added STCP CLA to ver 4.1.2

Tag: `4.1.2`

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


