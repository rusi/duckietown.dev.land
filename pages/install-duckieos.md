---
title: Installing DuckieOS
path: /build/duckieos/
---

<section>

# Installing DuckieOS

Duckiebot is powered by DuckieOS which is ~~based on~~ just [HypriotOS](http://blog.hypriot.com).

### Downloads & Tools
* [Etcher](https://etcher.io) - used to burn images to SD cards & USB drives
* [HypriotOS for rpi3](http://blog.hypriot.com/downloads/) - HypriotOS for Raspberry Pi 3 ([direct download link (260.7MB)](https://github.com/hypriot/image-builder-rpi/releases/download/v1.7.1/hypriotos-rpi-v1.7.1.img.zip))

### Prerequisites
* **[Docker](https://www.docker.com)** is used to install and control containers running on your Duckiebot

</section>

<section>

## Step 1 - Flash SD Card

Using Etcher, burn the image on your SD card.

![etcher1](/images/etcher1.png)<!-- {.small} -->
![etcher2](/images/etcher2.png)<!-- {.small} -->
<!-- {p:.center} -->

## Step 2 - Configure HypriotOS

HypriotOS uses `cloud-init` to configure the OS. See http://cloudinit.readthedocs.io/en/0.7.9/index.html for full list of configuration options.
These [examples](http://cloudinit.readthedocs.io/en/0.7.9/topics/examples.html) are particularly useful.

1. Mount the newly flashed SD card (on a Mac it should be mounted under `/Volumes/HypriotOS/`)
2. Edit `/Volumes/HypriotOS/user-data` to configure your Duckiebot; in particular:
    * set the hostname (`hostname`; NOTE: you should use a unique Hostname, rather than 'duckiebot')
    * modify the user (`name` and `plain_text_passwd`)
    * configure the WiFi settings (`ssid` and `psk`)
    * enable Docker remote API (tcp:2375)
      https://coreos.com/os/docs/latest/customizing-docker.html

Following is a complete listing of `user-data`:
```yaml
#cloud-config
# vim: syntax=yaml

# The currently used version of cloud-init is 0.7.9
# http://cloudinit.readthedocs.io/en/0.7.9/index.html

hostname: duckiebot
manage_etc_hosts: true

users:
  - name: duckie
    gecos: "Duckietown"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: quackquack
    lock_passwd: false
    ssh_pwauth: true
    chpasswd: { expire: false }

package_upgrade: false

write_files:
  - content: |
      allow-hotplug wlan0
      iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
      iface default inet dhcp
    path: /etc/network/interfaces.d/wlan0
  - content: |
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
      update_config=1
      network={
      ssid="DuckieWiFi"
      psk="quackquack"
      proto=RSN
      key_mgmt=WPA-PSK
      pairwise=CCMP
      auth_alg=OPEN
      }
    path: /etc/wpa_supplicant/wpa_supplicant.conf
  - content: |
      [Unit]
      Description=Docker Socket for the API

      [Socket]
      ListenStream=2375
      BindIPv6Only=both
      Service=docker.service

      [Install]
      WantedBy=sockets.target
    path: /etc/systemd/system/docker-tcp.socket

# These commands will be ran once on first boot only
runcmd:
  - 'systemctl restart avahi-daemon'
  - 'ifup wlan0'

  - 'mkdir /data && chown 1000:1000 /data'

  - [ systemctl, stop, docker ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker ]

  - [docker, swarm, init ]
  # for convenience, we will install and start Portainer.io
  - [
      docker, service, create,
      "--detach=false",
      "--name", "portainer",
      "--publish", "published=9000,target=9000,mode=host",
      "--mount", "type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock",
      "portainer/portainer", "-H", "unix:///var/run/docker.sock", "--no-auth"
    ]
```
</section>

<section>

## Step 3 - Boot DuckieOS

Insert the SD card in Duckiebot (Raspberry Pi) and power it on. Wait a minute or so and check if the device has booted and is online:

```sh
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

```sh
$ ssh duckie@duckiebot.local
HypriotOS/armv7: duckie@duckiebot in ~
$
```

#### Speedtest

```sh
$ easy_install speedtest-cli
$
```

</section>

<section>

## Step 4 - Setting up Docker Client

DuckieOS uses Docker 17.10.0-ce (kernel 4.4.50). However, you might have a different Docker version running
on your machine (e.g. 17.12.0-ce-mac49). This means that you cannot talk to and control your docker containers
directly from your system. Luckily, there is the [Docker Version Manager](https://github.com/howtowhale/dvm) which allows you to install and manage multiple Docker client versions.

Install **Docker Version Manager** following [these instruction](https://howtowhale.github.io/dvm/install.html).
On Mac OS X with Homebrew:
```sh
$ brew update
$ brew install dvm
```

Edit `vim ~/.bash_profile` and add `dvm` to your _.bash_profile_ by inserting the following line:
```
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh
```

Reload your _~/.bash_profile_, and check what version(s) of Docker client are installed:
```sh
$ source ~/.bash_profile
$ dvm ls
->	system (17.12.0-ce)
```

If necessary, install the version that is running on Duckiebot:
```sh
$ dvm install 17.10.0-ce
Installing 17.10.0-ce...
Now using Docker 17.10.0-ce
```

Test your installation and verify that Docker client can directly communicate with Duckiebot:
```sh
$ docker -H duckiebot.local info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.10.3
   ...
Kernel Version: 4.4.50-hypriotos-v7+
Operating System: Raspbian GNU/Linux 8 (jessie)
OSType: linux
Architecture: armv7l
CPUs: 4
Total Memory: 861.9MiB
Name: duckiebot
   ...
```
</section>

<section>

## Step 5 - Running Docker containers

Test Docker on the RPi3:
```sh
$ docker -H duckiebot.local run --rm -it hello-world
```

We will use [Portainer.io](http://portainer.io) - a lightweight management UI for Docker Host - to monitor and manage some of our containers.
Portainer is already automatically installed and is running as a service.
Go to http://duckiebot.local:9000/ after DuckieOS boots to see the Portainer Dashboard.

[![portainer4](/images/portainer4.png)](/images/portainer4.png)<!-- {.small} -->
<!-- {p:.center} -->

</section>

<section>

## Step 6 - Test RPi Camera Module

To test the Raspberry Pi Camera use the demo
**[(python + raspberry pi + camera) on Docker](https://github.com/rusi/rpi-docker-python-picamera)** App.

```sh
$ git clone git@github.com:rusi/rpi-docker-python-picamera.git
$ cd rpi-docker-python-picamera
# build the container on the Raspberry Pi
$ docker -H duckiebot.local build . -t rpi-picam
# run the app
$ docker -H duckiebot.local run -it --rm --privileged -p 8080:8080 rpi-picam
```

After the container is built and deployed, point your browser to http://duckiebot.local:8080/image.jpg

</section>

<section>

## Step 7 - Running ROS + Pi Camera

The ROS Docker Container is based on [maidbot/resin-raspberrypi3-ros](https://hub.docker.com/r/maidbot/resin-raspberrypi3-ros/).

First, clone the DuckieSoft repository:
```sh
$ git clone https://github.com/rusi/duckiesoft.git
$ cd duckiesoft
```

```sh
$ ./rdk.sh build -t roscam -f rosbot/Dockerfile .
$ ./rdk.sh run -it --rm roscam
```

</section>

<section>

## Step 8 - Running ROS + RC Duckie

For this step, you need to connect the Logitech Gamepad F710 USB adapter into one of the Raspberry Pi USB ports.

The ROS Docker Container is based on [maidbot/resin-raspberrypi3-ros](https://hub.docker.com/r/maidbot/resin-raspberrypi3-ros/).

First, clone the DuckieSoft repository:
```sh
$ git clone https://github.com/rusi/duckiesoft.git
$ cd duckiesoft
```

Build "rosdev" (locally) and "rosbot" (on the robot / RPi3) containers:
```sh
$ docker build -t rosdev ./rosdev/

$ docker --host=192.168.1.111:2375 build -t rosbot ./rosbot/
# or use the `rdk.sh` script:
$ ./rdk.sh build -t rosbot ./rosbot/
```

Start the ROS Master container on the robot (RPi3):
```sh
$ docker --host=192.168.1.111:2375 run -d --net host \
-v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
--name rosmaster rosbot roscore

# You can use the `rdk.sh` script to start ROS Master
$ ./rdk.sh run -d --name rosmaster rosbot roscore
```

To start an interactive ROS shell on the robot (RPi3):
```sh
$ docker --host=192.168.1.111:2375 run -it --rm --net host \
-v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
rosbot

# You can use the `rdk.sh` script to run ROS Node
$ ./rdk.sh run -it --rm rosbot
```

Start a publisher on the robot (RPi3):
```sh
$ ./rdk.sh run -it --rm rosbot
$ rostopic pub -r 1 /bot std_msgs/String "Hello Duckie!"
```

Start a subscriber on the robot (RPi3):
```sh
$ ./rdk.sh run -it --rm rosbot
$ rostopic echo /bot
```

On your development laptop you need to create a separate network
for your ROS Dev containers in order for multiple of them to
communicate with each other. Then start ROS Master:
```sh
$ export set HOST_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
$ xhost + $HOST_IP
$ docker network create duckienet
$ docker run -it --rm \
  -e DISPLAY=$HOST_IP:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.ros:/root/.ros/ \
  -v ${PWD}:/workspace \
  --net duckienet \
  --env ROS_MASTER_URI=http://rosmaster:11311 \
  --name rosmaster rosdev roscore

# You can also use the `rosdev.sh` script to automatically create 'duckienet'
# and start ROS Master if it is not running:
$ ./rosdev.sh
```

Start an interactive ROS shell on your local machine:
```sh
$ cd ros_ws
$ ../rosdev.sh
```



---
---

Run an interactive ROS Node container to test the setup:
```sh
$ docker --host=192.168.1.111:2375 run -it --rm --net duckienet --name rosnode rosnode
root@60a4dc3d914d:/# rostopic list
/rosout
/rosout_agg
root@60a4dc3d914d:/#
```


</section>

<section>

### Resources

* **Step 1** and **Step 2** are based on [Getting Started with ResinOS](https://resinos.io/docs/raspberrypi3/gettingstarted/)

</section>
