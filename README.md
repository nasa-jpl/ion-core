# ION-Core for Linux (and WSL)

## Build & Install

Currently ion-core only builds on 64-bit OS. Future releases will support 32-bit OS.

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

## Man Page Installation

First Run:

`./scripts/make-man-pages.sh ../ion-open-source-4.1.2/`

Then run:

`sudo make man-install`

## Creating ION configuration (".rc") files for a two-node setup

`./scripts/host.sh <IP-this-host> <IP-the-other-host>`

For example:

`./scripts/host.sh 192.168.254.192 192.168.254.194`

Makes the config file host192.rc

`ionstart -I host192.rc`

Now we can use it to launch ION on this host with an IP address of 192.168.254.192 and an IPN node number of 192. For the other host, run the same command with the order of IP addresses reversed.

The default protocol stack is BP/LTP. 

To generate configuration files using UDP or the STCP CLA, add either `udp` or `stcp` as the third argument to `host.sh`. For example to generate configuration using STCP, run 

`./scripts/host.sh 192.168.254.192 192.168.254.194` stcp

Similar syntax goes for udp.

To use other convergence layer such as UDP or STCP, you will need to modify the .rc files. See the ION documentation for more information. For example, you may consult the [ION Configuration Tutorials and Configuration Templates.](https://nasa-jpl.github.io/ION-DTN/Basic-Configuration-File-Tutorial/)

## Automated Script to Build, Install, and Test Ion-core on Two Hosts

To streamline the process, we have created a two scripts that automates the build, installation, and testing of ion-core.

To build and install ion-core, run:

`./scripts/build-install.sh`

To run a bping test between two nodes. On host A, run
`./scripts/bping-send.sh <IP Address of Host A> <IP Address of the Host B>`

On host B, run

`./scripts/bping-echo.sh <IP Address of Host B> <IP Address of the Host A>`

Note:
* This script will automatically create the ION configuration files needed and launch a `bping` test using BP and LTP CLA.
* To ensure that all bping message will be received by the peer DTN node, it is recommended that you run bping-echo on second host first, and then run bping-send on the first host.
* Both bping-send.sh and bping-echo.sh takes an optional 3rd argument to specify either the udp or stcp CLAs. But they must be the same on both host to ensure compatibility.

## Adjusting Pre-Allocation of Memory/Storage Space for ION

ION is designed to run within a pre-allocated memory space. If, while running ION, you encounter errors due to lack of working memory or SDR heap space, you can increase the pre-allocated allocation by modifying the `host.ionconfig` file and then regenerate configuration files using the `./scripts/host.sh` command. The current default ION SDR and working memory allocation is as follows:

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

To build a static linking library for ION, execute the command `./scripts/lib.sh`.

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


