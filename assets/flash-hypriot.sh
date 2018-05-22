#!/bin/sh

set -e

# We need root to install
if [ $(id -u) != "0" ]; then
    echo "Please provide root access or press ^C..."
    exec sudo "$0" "$@"
fi

HYPRIOT_LOCAL="/tmp/hypriot.img.zip"
ETCHER_LOCAL=$(mktemp)
ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.7.1/hypriotos-rpi-v1.7.1.img.zip"
INSTALL_DIR="/tmp/etcher-cli"

install_etcher()
{
	# Download tool to burn image
	echo "Downloading etcher-cli..."
	wget -O ${ETCHER_LOCAL} ${ETCHER_URL}
	echo "Downloading complete."

	# Unpack archive
	mkdir $INSTALL_DIR
	echo "Installing etcher-cli to $INSTALL_DIR..."
	tar fvx ${ETCHER_LOCAL} -C ${INSTALL_DIR} --strip-components=1
}

download_hypriot()
{
	# Download the Hypriot Image
	echo "Downloading Hypriot image to ${HYPRIOT_LOCAL}"
	wget -O ${HYPRIOT_LOCAL} ${HYPRIOT_URL}
	echo "Downloading complete."
}

if [ ! -f "$INSTALL_DIR/etcher" ]; then
    echo "Could not find etcher-cli. Installing..."
    install_etcher
fi

if [ ! -f ${HYPRIOT_LOCAL} ]; then
    echo "Could not find hypriot. Installing..."
    download_hypriot
fi

echo "Flashing Hypriot image $HYPRIOT_LOCAL to disk..."

${INSTALL_DIR}/etcher ${HYPRIOT_LOCAL}

echo "Flashing Hypriot image succeeded."

read -p "Please enter a hostname  > " HOSTNAME
read -p "Please enter a username  > " USERNAME
read -p "Please enter a password  > " PASSWORD
read -p "Please enter a wifi-ssid > " WIFI_SSID
read -p "Please enter a wifi-psk  > " WIFI_PSK

MOUNTPOINT=$(mktemp -d)
mount -L HypriotOS $MOUNTPOINT

echo "Writing user-data to HypriotOS..."

echo -e "
#cloud-config
# vim: syntax=yaml

# The currently used version of cloud-init is 0.7.9
# http://cloudinit.readthedocs.io/en/0.7.9/index.html

hostname: $HOSTNAME
manage_etc_hosts: true

users:
  - name: $USERNAME
    gecos: "Duckietown"
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
      ssid="$WIFI_SSID"
      psk="$WIFI_PSK"
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
" > $MOUNTPOINT/user-data

echo "Un-mounting HypriotOS..."

umount $MOUNTPOINT

echo "Installation complete!"
