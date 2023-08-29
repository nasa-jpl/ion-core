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
git checkout 4.1.2
./scripts/extract.sh ../ion-open-source-4.1.2
make
make install
```

## Man Page Installation

`./scripts/make-man-pages.sh ../ion-open-source-4.1.2/`

## Creating "host.rc" files for a two-node configuration

`./scripts/host.sh <IP-this-host> <IP-the-other-host>`

For example:

`./scripts/host.sh 192.168.254.192 192.168.254.194`

Makes the config file host192.rc

`ionstart -i host192.rc`

Now we can use it to launch host with IP of 192.168.254.192 and run bping, bpsource, bprecvfile etc. For the other host, do the same with reversed order of IP addresses.

### adding ionconfig.rc

The basic host.rc files uses default heap and working memory allocation for ION. For basic, low traffic load scenario it should be sufficient. For higher throughput operation, it may result in insufficient memory error. ION depends on the user to allocate sufficient memory to operate - it is not allowed to dynamically request memory from OS in order support flight system constraints - therefore to customize ION for higher buffer and throughput operation, one should add an additional ionconfig.rc file. An example is as follows:

```
configFlags 1
heapWords 15000000
sdrWmSize 15000000
wmSize 15000000
```

Create a `host.ionconfig` file as above and placed it in the same directory with .rc file generated by host.sh.

Read the man page `man ionconfig` for detailed explanation of the configuration parameters.

In the hostxxx.rc file generated by host.sh, point it to the ionconfig file created by replacing the line:

`1 192 ''`

with

`1 192 host.ionconfig`

This tells ION to read the host.config file to obtain the proper memory allocation and configuraiton.
