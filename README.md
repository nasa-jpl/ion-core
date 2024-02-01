## ION-Core for Windows and Linux

### WSL2 Networking Issue

WLS2 is known to have issues with VPN connection. One approach is to downgrade to WSL1:

In Windows Powershell get your name/version:

`wsl -l -v`

Set it to version 1:

`wsl --set-version Ubuntu-22.04 1`

Alternative approach is to use the WSL vpnkit to provide VPN connection:

https://github.com/sakai135/wsl-vpnkit

### To build:

Currently ion-core only builds on 64-bit OS. Future releases will support 32-bit OS.

Be sure you have the tools installed:
```
sudo apt update
sudo apt install make gcc
```

Get the ion sources:
```
wget https://sourceforge.net/projects/ion-dtn/files/ion-open-source-4.1.2.tar.gz
tar -zxvf ion-open-source-4.1.2.tar.gz
```

Get the ION-Core repo:
```
git clone https://github.com/nasa-jpl/ion-core.git
cd ion-core
git checkout tags/4.1.2
./scripts/extract.sh ../ion-open-source-4.1.2
make
sudo make install
```

You can also run `./scripts/extract.sh` without supplying the path to an existing ION source code folder. In that case, the script will automatically download the appropriate ION source and extract the source files.

## Man Page Installation

First run: 

`./scripts/make-man-pages.sh ../ion-open-source-4.1.2/`

Then run:

`sudo make man-install`

## Creating ION configuration (".rc") files for a two-node setup

`./scripts/host.sh <IP-this-host> <IP-the-other-host>`

For example:

`./scripts/host.sh 192.168.254.192 192.168.254.194`

Makes the config file host192.rc

`ionstart -I host192.rc`

Now we can use it to launch ION on the host with an IP address of 192.168.254.192 and run `bping`, `bpsource`, or `bprecvfile` etc. For the other host, run the same command with the order of IP addresses reversed.

### Tuning Memory Allocation

If while running ION, you encounter errors due to lack of working memory or SDR heap space, you can increase the pre-allocated SDR space by modifying the `host.ionconfig` file and then regenerate the `./scripts/host.sh` command. The current default ION SDR and working memory allocation is as follows:

```
configFlags 1
heapWords 15000000
sdrWmSize 15000000
wmSize 15000000
```

The `configFlags` value of 1 creates a Simple Data Recorder (SDR) instance in the DRAM. The SDR is the primary program and data storage for ION. The 'heap' space, where user data are buffered, is set to 15 mega words, each word is 64 bits (or 8 bytes) for a 64-bit platform. The `sdrWmSize` specifies the SDR's working memory space measured in bytes; the `wmSize` specifies the general ION working memory in bytes.

These values can be adjusted to control how much storage ION is allowed to consume in the host system. The proper setting requires some insight into the host system's capabilities, the traffic injection rate, and the expected inbound and outbound data rate.

Pleaser consult the manual page entry for `ionconfig` for a detailed explanation of the full set of configuration parameters.

## Tuning LTP Performance

Actual throughput of data transfer depends on the underlying network connection speed, the host's processor speed, the contact graph's data rate, the size of the bundles being sent, the round trip delay between the two hosts, and also on the LTP configuration. Check the manual page entry for `ltprc` for details on how to adjust LTP settings to maximize throughput. In the ION source code's root directory, there is an Excel file named `ION-LTP-configuration_tool.xlsm` which may assist you in optimizing your LTP configuration to get the highest available throughput out of your system.

## Building Library
To build a static linking library for ION, execute the command `./scripts/lib.sh`.

## Contributing Code
Please see the file `developer_notes.txt` for more information.

--------------------------

## Release Notes

Latest Release

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


