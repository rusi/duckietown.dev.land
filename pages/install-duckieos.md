---
title: Installing DuckieOS
path: /build/duckieos/
---

<section>

# Installing DuckieOS

Duckiebot is powered by DuckieOS which is ~~based on~~ just [ResinOS](https://resinos.io/).

### Downloads & Tools
* [Etcher](https://etcher.io) - used to burn images to SD cards & USB drives
* [ResinOS for rpi3](https://resinos.io/#downloads-raspberrypi) - ResinOS for Raspberry Pi 3 ([direct download link](https://files.resin.io/resinos/raspberrypi3/2.0.0-beta.1/resin-dev.zip))

### Prerequisites
* [NodeJS](https://nodejs.org) 6.x & npm
* **Resin Device Toolbox** (**rdt**) requires **rsync** and **ssh**
* **[Docker](https://www.docker.com)** is used to install and control containers running on your Duckiebot

</section>

<section>

## Step 1 - Flash SD Card

Download all tools and packages and install all prerequisites listed above.

Install **Resin Device Toolbox**
```
$ npm install -g resin-device-toolbox
```

Configure the ResinOS image. First, make a copy of the ResinOS image.
NOTE: you should use a unique Hostname, rather than 'duckiebot'
```
$ cp resin.img resin-custom.img
$ rdt configure ./resin-custom.img
? Network SSID DuckieWiFi
? Network Key quackquack
? Do you want to set advanced settings? Yes
? Device Hostname duckiebot
? Do you want to enable persistent logging? No
Done!
```

**TODO**: HAVE TO ADD THE FOLLOWING TO **config.txt**
<!-- {p:.alert .alert-danger} -->

```
start_x=1             # essential
disable_camera_led=1  # optional; turn off led
#gpu_mem=128           # at least, or maybe more if you wish
```


Using Etcher, burn the image on your SD card.

![etcher1](/images/etcher1.png)<!-- {.small} -->
![etcher3](/images/etcher3.png)<!-- {.small} -->
<!-- {p:.center} -->

</section>

<section>

## Step 2 - Boot DuckieOS (_ResinOS_)

Insert the SD card in Duckiebot (Raspberry Pi) and power it on. Wait a minute or so and check if the device has booted and is online:

```
$ ping duckiebot.local
PING duckiebot.local (192.168.1.111): 56 data bytes
64 bytes from 192.168.1.111: icmp_seq=0 ttl=64 time=21.265 ms
64 bytes from 192.168.1.111: icmp_seq=1 ttl=64 time=15.905 ms
^C
--- duckiebot.local ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 15.905/18.585/21.265/2.680 ms
```

#### **Advanced** - you can SSH into Duckiebot

Either use **rdt** to discover all devices:
```
$ rdt ssh --host
Reporting discovered devices
? select a device (Use arrow keys)
❯ duckiebot.local (192.168.1.111)
root@duckiebot:~#
```

Or directly SSH into the device:
```
$ ssh root@duckiebot.local -p22222
root@duckiebot:~#
```

</section>

<section>

## Step 3 - Setting up Docker Client

DuckieOS / ResinOS uses Docker v1.10.3. However, most likely you have the latest Docker version running
on your machine (e.g. v17.03.0-ce). This means that you cannot talk to and control your docker containers
directly from your system. Luckily, there is the [Docker Version Manager](https://github.com/howtowhale/dvm) which allows you to install and manage multiple Docker client versions.

To find out which version DuckieOS / ResinOS is running, do the following:
```
$ rdt ssh --host
Reporting discovered devices
? select a device duckiebot.local (192.168.1.111)
root@duckiebot:~# docker --version
Docker version 1.10.3, build 20f81dd-unsupported
```

Install **Docker Version Manager** following [these instruction](https://getcarina.com/blog/docker-version-manager/).
On Mac OS X with Homebrew:
```
$ brew update
$ brew install dvm
$ vim ~/.bash_profile
```

Add the following to your _.bash_profile_:
```
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh
```

Reload your _~/.bash_profile_, and check what version(s) of Docker client are installed:
```
$ source ~/.bash_profile
$ dvm ls
->	system (1.11.0)
```

If necessary, install the version that is running on Duckiebot:
```
$ dvm install 1.10.3
Installing 1.10.3...
Now using Docker 1.10.3
```

Test your installation and verify that Docker client can directly communicate with Duckiebot:
```
$ ping duckiebot.local
PING duckiebot.local (192.168.1.111): 56 data bytes
64 bytes from 192.168.1.111: icmp_seq=0 ttl=64 time=21.265 ms
^C
$ docker --host=192.168.1.111:2375 info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.10.3
   ...
```

</section>

<section>

## Step 4 - Running Docker containers

First, we will install [Portainer.io](http://portainer.io) - a lightweight management UI for Docker Host (NOTE: use the Host IP for your Duckiebot):
```
$ docker --host=192.168.1.111:2375 run -d --name portainer \
  -p 80:9000 -v /var/run/docker.sock:/var/run/docker.sock \
  --restart always portainer/portainer
```
Then open http://duckiebot.local/ to configure Portainer.

Enter admin password (e.g. "quackquack").

[![portainer1](/images/portainer1.png)](/images/portainer1.png)<!-- {.small} -->
<!-- {p:.center} -->

Login and configure Portainer to "Manage the Docker instance where Portainer is running"

[![portainer2](/images/portainer2.png)](/images/portainer2.png)<!-- {.small} -->
[![portainer3](/images/portainer3.png)](/images/portainer3.png)<!-- {.small} -->
<!-- {p:.center} -->

After you login, you will see the Portainer Dashboard.

[![portainer4](/images/portainer4.png)](/images/portainer4.png)<!-- {.small} -->
<!-- {p:.center} -->

</section>

<section>

## Step 5 - Test RPi Camera Module

To test the Raspberry Pi Camera use the demo
**[Docker(python + raspberry pi + camera) on ResinOS](https://github.com/rusi/resin-rpi-python-picamera)** App.

```
$ git clone https://github.com/rusi/resin-rpi-python-picamera.git
$ cd resin-rpi-python-picamera
$ rdt push duckiebot.local -s .
```

After the container is built and deployed, point your browser to http://duckiebot.local:8080/image.jpg

</section>

<section>

## Step 6 - Running ROS + RC

</section>

<section>

### Resources

* **Step 1** and **Step 2** are based on [Getting Started with ResinOS](https://resinos.io/docs/raspberrypi3/gettingstarted/)

</section>