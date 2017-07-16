# How to setup local pool for Komodo (KMD)?

## What's this?

First of all - sorry for my english, this is not my native language. But i'm hope that everything will be clear.

In this guide we will learn how to setup Komodo (KMD) platform, how to run local wallet and how to create our own local pool for mining KMD in solo on GPU's. 

As we are know [komodo](https://github.com/jl777/komodo) software is available only for Linux now, but most users running Windows on their PC. In this case we will use [Oracle VM Virtual Box](https://www.virtualbox.org/) in this guide. It's available on Windows, OS X and Linux hosts, so, we can setup all we need in VM, independently on OS that we used on host PC.

## Installing VirtualBox and Linux

**1.** Download [VirtualBox binaries](https://www.virtualbox.org/wiki/Downloads) for your platform and install Virtual Box.
**2.** Create new VM (virtual machine) with the following options:

- OS Type: Linux
- Version: Ubuntu (64-bit)
- RAM: 4096 Mb (4 Gb seems will be enought, but better to use 8 Gb RAM in VM, it all depends on your host's RAM amount, if you have 16 Gb RAM on your host PC - choose 8192 Mb for VM, if only 8 Gb - choose 4096 Mb for VM).
- HDD: VDI (Virtual Disk Image), dynamic, 25 Gb size (25 Gb will be enough at first time, current Komodo blockchain size is near 1.7 Gb, later if 25 Gb size looks like small - you always can expand this size by using VBoxManage tool as it described here - [How to resize a Virtual Drive](https://forums.virtualbox.org/viewtopic.php?f=35&t=50661))

**3.** Download Ubuntu 16.04.2 LTS ISO Image from [official site](https://www.ubuntu.com/download/desktop) or from [one](http://mirror.yandex.ru/ubuntu-releases/)  of mirrors. I'm using that ISO - [ubuntu-16.04.2-desktop-amd64.iso](http://mirror.yandex.ru/ubuntu-releases/16.04.2/ubuntu-16.04.2-desktop-amd64.iso) (also we can use this [torrent](http://mirror.yandex.ru/ubuntu-releases/16.04.2/ubuntu-16.04.2-desktop-amd64.iso.torrent)  for download).

**4.** Install Ubuntu in VM: just put downloaded ISO in optical disk drive and run the VM, then install Ubuntu:

![](./image_02.png) 

Be sure that in your VM parameters you have 25 Gb HDD size, if you miss HDD set step and leave it as default (8 Gb), installer will cause error and report that you have insufficient disk space to install.

During install i was used *pool / pool123 *as login / password, because i plan to upload this VM Image somewhere after finished this guide (look at the downloads section at the end, you can download complete VM Image and skip all setup procedures and just start using Komodo and pool). Of course using password such that is unsafe, but for local use and learning purposes - that's ok. On login and password setup screen - choose "Automatically login" options, for your convenience.

**5.** Ok, now we have installed Ubuntu x64 Desktop. If you never use Linux-based OS before - there is no problem, following this guide you can setup all needed stuff simply. But you'll need some additional knowledge. For, example, most of commands described here should be entered in Terminal (console) window, which can be easily opened by pressing *Ctrl-Alt-T* on keyboard or from Main Menu -> Search box -> Terminal application.

![](./image_01.png) 

Also, in case running in Virtual Box we need to install Guest Additions for VM. How we can do this described in following manuals: [How do I install Guest Additions in a VirtualBox VM?](https://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-a-virtualbox-vm) and [Installing the Linux Guest Additions](https://www.virtualbox.org/manual/ch04.html#idm1959). When we inserted Guest Additions ISO image in virtual optical disk drive, Ubuntu's autorun automatically launch all needed and prompts to enter administrator (supervisor) password - it's *pool123* in our case.

After installing Guest Additions we need to reboot our virtual machine. Now enable common clipboard and drag&drop function in VirtualBox Devices menu to be able to copy & paste text and other data between Host OS and Guest OS.

**6.** Let's do some useful preparations: installing two file managers - MC (Midnight Commander) and Far (Far Manager for Linux), Git and some other needed stuff. Open Terminal window and type into it following commands (if system prompts you about supervisor / administrator passwords - use *pool123* password, which we entered during setup):

	sudo apt install mc
	sudo apt install git
	wget https://raw.githubusercontent.com/unxed/far2l-deb/master/far2l_64.deb
	sudo dpkg -i far2l_64.deb
	sudo apt-get -f install # to solve needed dependencies
	sudo dpkg -i far2l_64.deb # another time to install package

Now we can launch Midnight Commander and Far2l from applications menu, it can be useful in future.

## Let's setup Komodo

**1. ** Open Terminal window (Ctrl-Alt-T) and successively type following:

	sudo apt install build-essential pkg-config libc6-dev libevent-dev m4 g++-multilib autoconf libtool libncurses5-dev unzip git python zlib1g-dev wget bsdmainutils automake libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libdb++-dev ntp ntpdate
	sudo apt install libcurl4-gnutls-dev 
	git clone https://github.com/jl777/komodo
	cd komodo
	./zcutil/fetch-params.sh # it's took some time and fetch some additional data
	./zcutil/build.sh -j8 # compiling all this also take some time
	
All this steps described in this [manual](https://github.com/jl777/komodo/blob/master/README.md), i'm only make small changes in building without any problems on Ubuntu 16.04.

During process you will see some magic ;) on the screen ... this is compiling process:

![](./image_03.png) 
		
If it ends without errors you should see something like this in your terminal:

![](./image_04.png) 	

And in ~/komodo/src directory you should see compilied binaries. To ensure that the binaries are exists and build was succefull type the following command:

	ls -l ~/komodo/src/komodod ~/komodo/src/komodo-cli
	
If you see that binaries are exists - that's Ok:

![](./image_05.png) 

**2.** Now we should run komodo (Komodo Daemon) ans sync the blockchain of Komdo. But first we need to write komodo.conf file.

	mkdir -p ~/.komodo
	gedit ~/.komodo/komodo.conf
	
Add the following lines in komodo.conf and save it:

	rpcuser=bitcoinrpc
	rpcpassword=password
	txindex=1
	addnode=5.9.102.210
	addnode=78.47.196.146
	addnode=178.63.69.164
	addnode=88.198.65.74
	addnode=5.9.122.241
	addnode=144.76.94.38
	addnode=89.248.166.91	
	
After it done, run komodod:

	gnome-terminal -e "/home/pool/komodo/src/komodod"	
	
Last command will open another terminal window with running Komodo Daemon (don't close it). Now it's syncing blockchain. It tooks some time and a lot of internet trafic (at July 2017 komodo's blockchain size is near	1.7 GB). We should wait it to finish. Unfortunatelly, output of komodod is not very informative, but we can check blockchain downloading status following ways:

	~/komodo/src/komodo-cli getblockcount 
	# or
	~/komodo/src/komodo-cli getblockchaininfo | grep blocks
	
You should see current downloaded block number, to see current network block number visit [http://kmd.explorer.supernet.org/status](http://kmd.explorer.supernet.org/status)  and look in "Initial Block Chain Height" field. 

![](./image_06.png) 

As we are see here our komodod succefully downloaded 46697 of 408235 blocks. It's near 11% of current blockchain. Also we can check current blockchain folder size:

	du ~/.komodo -h
	
This is output of this:

![](./image_07.png) 

Here we see that the blocks folder size iz 226M, and as we know it should be near 1.7 Gb at the end of sync. So, waiting until komodod will sync it all.

Also, ht.xxxxxx strings in komodod's windows gives us information about height of current block. For example, ht.48156 string tell us that the komodod currently sync 48156 block, but for complete sync we still need wait to sync all 408235 blocks.

Unfortunatelly Komodo haven't komodo-qt GUI wallet now (like Bitcoin, for example, it have bitcoin-qt client, as we are all know). You can control your KMD wallet by using komodo-cli, but for most users this will be inconvenient. So, we need to install any GUI wallet or another tool that can control your wallet via GUI. I stopped at [Komodo Desktop GUI Wallet](https://github.com/ca333/komodoGUI) at this step. It's Java based and have "New/Experimental" status, but current release seems works fine. You can send / receive your KMD coins with this and for most people it will be enough. Let's install it ... 

	cd ~
	sudo apt-get install git default-jdk ant
	sudo apt-get install openjfx # It provides the following JAR files to the OpenJDK installation on Ubuntu systems: ant-javafx.jar, javafx-mx.jar and others
	sudo apt-get install openjfx-source # this may not be needed, but i install it
	git clone https://github.com/ca333/komodoGUI
	cd komodoGUI/
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
	ant -buildfile ./src/build/build.xml release
	
If build was succefull you should see the following:

![](./image_08.png) 	
	
Now it's time to make KomodoSwingWalletUI.jar executable (+x) attr and copy it to komodo folder:

	cd ~/komodoGUI/build/jars/
	chmod +x KomodoSwingWalletUI.jar
	cp KomodoSwingWalletUI.jar ~/komodo/src/
	cd ~/komodo/src/
	gnome-terminal -e "java -jar ./KomodoSwingWalletUI.jar"
	
Welcome to the Komodo Wallet GUI:

![](./image_09.png) 	

Perfect ... Next step we will look how to setup our own local pool for KMD mining.

## Setup a local pool ...

To be continued ...