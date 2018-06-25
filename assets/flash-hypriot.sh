#!/bin/bash

set -e

# We need root to install
if [ $(id -u) != "0" ]; then
    echo "Please provide root access or press ^C..."
    exec sudo "$0" "$@"
fi

if [ -z "$ETCHER_URL" ]; then
    echo "Setting environment variables..."
    ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
    ETCHER_DIR="/tmp/etcher-cli"
    ETCHER_LOCAL=$(mktemp)
    
    HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.9.0/hypriotos-rpi-v1.9.0.img.zip"
    HYPRIOT_LOCAL="/tmp/${HYPRIOT_URL##*/}"

    IMAGE_DOWNLOADER_URL="https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh"
    IMAGE_DOWNLOADER_LOCAL="/tmp/${IMAGE_DOWNLOADER_URL##*/}"

    FLASHER_URL="https://raw.githubusercontent.com/rusi/duckietown.dev.land/master/assets/flash-hypriot.sh"
    FLASHER_LOCAL="/tmp/${FLASHER_URL##*/}"

    FLASH_URL="https://github.com/hypriot/flash/releases/download/2.1.1/flash"
    FLASH_LOCAL="/tmp/${FLASH_URL##*/}"
    
    DUCKIE_ART_URL="https://raw.githubusercontent.com/duckietown/Software/master/misc/duckie.art"

    PORTAINER_LOCAL=/tmp/portainer.tar.gz
fi

prompt_for_configs() {
    if [ -n "$1" ]; then
        echo "Dependencies installed."; exit
    fi
    
    echo "Configuring DuckiebotOS (press ^C to cancel)..."
    
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
}

install_deps() {
    apt-get -y install wget tar lib32stdc++6 curl pv unzip hdparm sudo file udev golang-go jq --no-install-recommends
}

install_flasher() {
    if [ -f "$ETCHER_DIR/etcher" ]; then
        echo "Prior etcher-cli install detected at $ETCHER_DIR"
    else
        # Download tool to burn image
        echo "Downloading etcher-cli..."
        wget -cO "${ETCHER_LOCAL}" "${ETCHER_URL}"
        
        # Unpack archive
        echo "Installing etcher-cli to $ETCHER_DIR..."
        mkdir $ETCHER_DIR && tar fvx ${ETCHER_LOCAL} -C ${ETCHER_DIR} --strip-components=1
    fi
   
    if [ -f $FLASH_LOCAL ]; then
        echo "hypriot/flash was previously downloaded to $FLASH_LOCAL, skipping..."
    else
        echo "Installing hypriot/flash to $FLASH_LOCAL..."
        wget -cO ${FLASH_LOCAL} ${FLASH_URL} && chmod 777 ${FLASH_LOCAL}
    fi

    rm -rf ${ETCHER_LOCAL}
}

download_hypriot() {
    if [ -f $HYPRIOT_LOCAL ]; then
        echo "HypriotOS image was previously downloaded to $HYPRIOT_LOCAL, skipping..."
    else
        # Download the Hypriot Image echo "Downloading Hypriot image to ${HYPRIOT_LOCAL}"
        wget -cO ${HYPRIOT_LOCAL} ${HYPRIOT_URL}
        echo "Downloading Hypriot image complete."
    fi
}

flash_hypriot() {
    echo "Flashing Hypriot image $HYPRIOT_LOCAL to disk..."
    if [ -f /.dockerenv ]; then
        ${FLASH_LOCAL} ${HYPRIOT_LOCAL}
    else
        ${ETCHER_DIR}/etcher ${HYPRIOT_LOCAL}
    fi
    echo "Flashing Hypriot image succeeded."
}

download_docker_images() {
    echo "Downloading image downloader from ${IMAGE_DOWNLOADER_URL}"
    wget -cO ${IMAGE_DOWNLOADER_LOCAL} ${IMAGE_DOWNLOADER_URL} && chmod 777 ${IMAGE_DOWNLOADER_LOCAL}
    mkdir -p /tmp/portainer /tmp/software

    echo "Downloading portainer/portainer:arm from Docker Hub..."
    ${IMAGE_DOWNLOADER_LOCAL} /tmp/portainer portainer/portainer:arm
    tar -czvf ${PORTAINER_LOCAL} -C /tmp/portainer/ .

    # echo "Downloading duckietown/software:latest from Docker Hub..."
    # ${IMAGE_DOWNLOADER_LOCAL} /tmp/software duckietown/software:latest
    # tar -czvf /tmp/software.tar.gz /tmp/software/

    rm -rf /tmp/portainer /tmp/software
}

# download_docker_images_from_outside_docker() {
#     echo "Downloading portainer/portainer:latest from Docker Hub..."
#     if [ -f /tmp/portainer.tar.gz ]; then
#         echo "portainer/portainer was previously downloaded to /tmp/portainer.tar.gz, skipping..."
#     else
#         docker pull portainer/portainer && docker save --output /tmp/portainer.tar.gz portainer/portainer:latest
#     fi
#     # echo "Downloading duckietown/software:latest from Docker Hub..."
#     # docker pull duckietown/software && docker save --output /tmp/software.tar.gz duckietown/software:latest
# }

prompt_for_configs

install_deps

install_flasher

download_hypriot

# if [ -f /.dockerenv ]; then
#    echo "Docker container detected. Downloading image manually..."
download_docker_images
# else
#     echo "Linux detected. Downloading image with docker save..."
#     download_docker_images_from_outside_docker
# fi
flash_hypriot

preload_docker_images() {
    echo "Configuring DuckieOS installation..." 
    # Preload image(s) to speed up first boot
    echo "Writing preloaded Docker images to /var/local/"
    cp ${PORTAINER_LOCAL} $ROOT_MOUNTPOINT/var/local/
    # cp /tmp/software.tar.gz $ROOT_MOUNTPOINT/var/local/
}

write_configurations() {
    # Add i2c to boot configuration
    echo "dtparam=i2c1=on" >> $HYPRIOT_MOUNTPOINT/config.txt
    echo "dtparam=i2c_arm=on" >> $HYPRIOT_MOUNTPOINT/config.txt
    echo "i2c-bcm2708" >> $ROOT_MOUNTPOINT/etc/modules
    echo "i2c-dev" >> $ROOT_MOUNTPOINT/etc/modules
}

write_motd() {
    wget --no-check-certificate -O $ROOT_MOUNTPOINT/etc/update-motd.d/duckie.art $DUCKIE_ART_URL
    printf '#!/bin/sh\nprintf "\\n$(cat /etc/update-motd.d/duckie.art)\\n"\n' > $ROOT_MOUNTPOINT/etc/update-motd.d/20-duckie
    chmod +x $ROOT_MOUNTPOINT/etc/update-motd.d/20-duckie
}

# TODO
# write_ssh_keys() {
#     cat ~/.ssh/id_rsa.pub $ROOT_MOUNTPOINT
# }

mount_disks() {
    HYPRIOT_MOUNTPOINT=$(mktemp -d)
    ROOT_MOUNTPOINT=$(mktemp -d)
    mount -L HypriotOS $HYPRIOT_MOUNTPOINT
    mount -L root $ROOT_MOUNTPOINT
}

unmount_disks() {
    umount $HYPRIOT_MOUNTPOINT
    umount $ROOT_MOUNTPOINT
}

write_userdata() {
    echo "Writing custom cloud-init user-data..."

    echo "$USER_DATA" > $HYPRIOT_MOUNTPOINT/user-data
    echo "Un-mounting HypriotOS..."
    unmount_disks
    echo "Finished preparing SD card. Please remove and insert into a Duckiebot."
}

write_custom_files() {
    preload_docker_images
    write_configurations
    write_motd
}

mount_disks
write_custom_files

USER_DATA=$(cat <<EOF
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
      ssid="$WIFISSID"
      psk="$WIFIPASS"
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

# These commands will be run once on first boot only
runcmd:
  - 'systemctl restart avahi-daemon'
  - 'mkdir /data && chown 1000:1000 /data'
  - [ systemctl, stop, docker ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker ]
  - [ docker, swarm, init ]
  - [ docker, load, "--input", "/var/local/portainer.tar.gz"]
# Disabled pre-loading duckietown/software due to insuffient space on /var/local
# https://github.com/hypriot/image-builder-rpi/issues/244#issuecomment-390512469
#  - [ docker, load, "--input", "/var/local/software.tar.gz"]

# for convenience, we will install and start Portainer.io
  - [
      docker, service, create,
      "--detach=false",
      "--name", "portainer",
      "--publish", "published=9000,target=9000,mode=host",
      "--mount", "type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock",
      "portainer/portainer:arm", "-H", "unix:///var/run/docker.sock", "--no-auth"
    ]
EOF
)

write_userdata
