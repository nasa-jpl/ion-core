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

Currently ion-core only builds on 64-bit OS. Future release will support 32-bit OS.

Be sure you have the tools installed:
```
sudo apt update
sudo apt install make gcc
```

Get the ion sources:
```
wget https://sourceforge.net/projects/ion-dtn/files/ion-open-source-4.1.2.tar.gz/download
tar -zxvf download
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

## Man Page Installation

First run: 

`./scripts/make-man-pages.sh ../ion-open-source-4.1.2/`

Then run:

`sudo make man-install`

## Creating "host.rc" files for a two-node configuration

`./scripts/host.sh <IP-this-host> <IP-the-other-host>`

For example:

`./scripts/host.sh 192.168.254.192 192.168.254.194`

Makes the config file host192.rc

`ionstart -I host192.rc`

Now we can use it to launch host with IP of 192.168.254.192 and run bping, bpsource, bprecvfile etc. For the other host, do the same with reversed order of IP addresses.

### tuning ionconfig

If you encounter ION error related to exhaustion of working memory or heap space, you can increase the preallocated memory by modifying the host.ionconfig file which is currently as follows:

```
configFlags 1
heapWords 15000000
sdrWmSize 15000000
wmSize 15000000
```

The configFlags of 1 creates a Simple Data Recorder (SDR) instance in DRAM that. The SDR is the primary program and data storage for ION. The 'heap' space, where user data are buffered, is set to 15 mega words, each WORD is 64 bits (or 8 bytes) for 64-bit platform. the sdrWmSize specifies the SDR's working memory space measured in bytes; the wmSize specifies the general ION working memory in bytes.

These values can be adjust to allocate sufficient storage to ION while imposing a limit on the total resource ION is allowed to consume in the host.

Read the man page `man ionconfig` for detailed explanation of the configuration parameters.

## building library

To build ION library from ion-core, execute the command `./scripts/lib.sh`.

## Contributing Code

* Please see the file `developer_notes.txt` for more information.

--------------------------

## Release Notes

Latest Release

Tag: `4.1.2`

10/09/2023

* Based on ION Open Source 4.1.2
* Initial public release of ion-core (prototype)
* Basic features:
  * BPv7
  * CGR
  * LTP
  * UDPCL
  * IPN Nameing Scheme
  * Load-n-Go Command


