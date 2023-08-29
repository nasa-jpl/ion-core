## ION-Core for Windows and Linux

### WSL2 Networking Issue

WLS2 is known to have issues with VPN connection. One approach is to downgrade to WSL1:

In Windows Powershell get your name/version:
> wsl -l -v

Set it to version 1:
> wsl --set-version Ubuntu-22.04 1"

Alternative approach is to use the WSL vpnkit to provide VPN connection: https://github.com/sakai135/wsl-vpnkit

### To build:

Be sure you have the tools installed:
> sudo apt update
>
> sudo apt install make gcc

Get the ion sources:

> wget https://sourceforge.net/projects/ion-dtn/files/ion-open-source-4.1.2.tar.gz/download
>
> tar -zxvf download

Get the ION-Core repo:

> git clone https://github.com/nasa-jpl/ion-core.git
>
> cd ion-core
>
> git checkout 4.1.2
>
> ./scripts/extract.sh ../ion-open-source-4.1.2
>
> make
>
> make install

## Man Page Installation

> ./scripts/make-man-pages.sh ../ion-open-source-4.1.2/

## Creating "host.rc" files for a two-node configuration

> ./scripts/host.sh <IP-of-host1> <IP-of-host2> 

For example:

> ./scripts/host.sh 192.168.254.192 192.168.254.194 

Makes the config file host192.rc

> ionstart -i host192.rc

Now we can use bping, bpsource, bprecvfile etc.
