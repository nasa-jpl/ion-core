## ION-Core for Windows and Linux

After some Windows 10 updates, WSL2 has no network connection... downgrade:
In Windows Powershell get your name/version:
> wsl -l -v

Set it to version 1:
> wsl --set-version Ubuntu-22.04 1"

Yeah, so after some Googling this seems to be an issue with WSL2 and some unknown versions of Windows 10. Geez. Just downgrade.

## To build:

Be sure you have the tools installed:
> sudo apt update
>
> sudo apt install make gcc

Get the ion sources:

> wget https://sourceforge.net/projects/ion-dtn/files/ion-open-source-4.1.2.tar.gz/download
>
> tar -zxvf download

Get the ION-Core repo:

> git clone https://github.jpl.nasa.gov/PTL/ION-Core.git
>
> cd ION-Core
>
> git checkout 4.1.2
>
> ./scripts/extract.sh ../ion-open-source-4.1.2
>
> make
>
> make install

## Want man pages?
> ./scripts/make-man-pages.sh ../ion-open-source-4.1.2/

## Make a host.rc file

> ./scripts/host.sh this IP that IP 

For example:

> ./scripts/host.sh 192.168.254.192 192.168.254.194 

Makes the config file host192.rc

> ionstart -i host192.rc

Now we can use bping, bpsource, bprecvfile etc.
