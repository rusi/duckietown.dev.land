#!/bin/sh

set -e

# We need root to install
if [ $(id -u) != "0" ]; then
    echo "Please provide root access or press ^C..."
    exec sudo "$0" "$@"
fi

ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
ETCHER_DIR="/tmp/etcher-cli"
ETCHER_LOCAL=$(mktemp)

HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.8.0/hypriotos-rpi-v1.8.0.img.zip"
HYPRIOT_FILE=${HYPRIOT_URL##*/}
HYPRIOT_LOCAL="/tmp/$HYPRIOT_FILE"

install_deps()
{
    apt-get -y install wget tar lib32stdc++6
}

install_etcher()
{
    # Download tool to burn image
    echo "Downloading etcher-cli..."
    wget -O ${ETCHER_LOCAL} ${ETCHER_URL}
    echo "Downloading complete."
    
    # Unpack archive
    mkdir $ETCHER_DIR
    echo "Installing etcher-cli to $ETCHER_DIR..."
    tar fvx ${ETCHER_LOCAL} -C ${ETCHER_DIR} --strip-components=1
}

download_hypriot()
{
    # Download the Hypriot Image
    echo "Downloading Hypriot image to ${HYPRIOT_LOCAL}"
    wget -O ${HYPRIOT_LOCAL} ${HYPRIOT_URL}
    echo "Downloading complete."
}

flash_hypriot()
{
    echo "Flashing Hypriot image $HYPRIOT_LOCAL to disk..."
    ${ETCHER_DIR}/etcher ${HYPRIOT_LOCAL}
    echo "Flashing Hypriot image succeeded."
}

install_deps

if [ ! -f "$ETCHER_DIR/etcher" ]; then
    echo "Could not find etcher-cli. Installing..."
    install_etcher
else
    echo "Prior etcher-cli install detected at $ETCHER_DIR"
fi

if [ ! -f ${HYPRIOT_LOCAL} ]; then
    echo "Could not find Hypriot. Installing..."
    download_hypriot
else
    echo "Prior HypriotOS image detected at $HYPRIOT_LOCAL"
fi

LSBLK=$(lsblk -o name,mountpoint,label)
if echo $LSBLK | grep -q HypriotOS; then
   echo "HypriotOS may have previously been installed:\n$LSBLK"
   while true; do
      read -p "Would you like to overwrite HypriotOS? (Y/N) > " REPLY
      case $REPLY in
          [yY] ) echo "Reinstalling HypriotOS..."; flash_hypriot; break;;
          [nN] ) echo "Aborted Hypriot install."; exit; break;;
      esac
   done
fi

write_userdata()
{
    echo "Configuring DuckiebotOS (press ^C to cancel)..."
    MOUNTPOINT=$(mktemp -d)
    mount -L HypriotOS $MOUNTPOINT

    DEFAULT_HOSTNAME="duckiebot"
    DEFAULT_USERNAME="duckie"
    DEFAULT_PASSWORD="quackquack"
    DEFAULT_WIFISSID="duckietown"
    DEFAULT_WIFIPASS="quackquack"

    read -p "Please enter a username (default is $DEFAULT_USERNAME) > " USERNAME
    USERNAME=${USERNAME:-$DEFAULT_USERNAME}
    read -p "Please enter a password (default is $DEFAULT_PASSWORD) > " PASSWORD
    PASSWORD=${PASSWORD:-$DEFAULT_PASSWORD}
    read -p "Please enter a hostname (default is $DEFAULT_HOSTNAME) > " HOSTNAME
    HOSTNAME=${HOSTNAME:-$DEFAULT_HOSTNAME}
    read -p "Please enter a WIFI SSID (default is $DEFAULT_WIFISSID) > " WIFISSID
    WIFISSID=${WIFISSID:-$DEFAULT_WIFISSID}
    read -p "Please enter a WIFI PSK (default is $DEFAULT_WIFIPASS) > " WIFIPSK
    WIFIPASS=${WIFIPASS:-$DEFAULT_WIFIPASS}
    
    echo "Writing custom user-data..."
    
    echo "#cloud-config
# vim: syntax=yaml

# The currently used version of cloud-init is 0.7.9
# http://cloudinit.readthedocs.io/en/0.7.9/index.html

hostname: $HOSTNAME
manage_etc_hosts: true

users:
  - name: $USERNAME
    gecos: \"Duckietown\"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: $PASSWORD
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
      ssid=\"$WIFISSID\"
      psk=\"$WIFIPASS\"
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
      \"--detach=false\",
      \"--name\", \"portainer\",
      \"--publish\", \"published=9000,target=9000,mode=host\",
      \"--mount\", \"type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock\",
      \"portainer/portainer\", \"-H\", \"unix:///var/run/docker.sock\", \"--no-auth\"
    ]" > $MOUNTPOINT/user-data
    
    echo "Un-mounting HypriotOS..."
    
    umount $MOUNTPOINT

    echo "Finished writing to SD card."
}

write_userdata

echo "Installation complete! You may now remove the SD card."
