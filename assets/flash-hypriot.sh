#!/bin/bash

#for debutting, enable command printout
if [ -n "$DEBUG" ]; then
    set -x
fi

set -eu
# We need root to install
if [ $(id -u) -eq "0" ]; then
    echo "Please, do not run this script as SUDO or root ^C..."
    echo "The script requires SUDO/root access for flashing the image "
    echo "and to write config files to HyrpiotOS."
    echo "You will be asked for your password at that time."
    exit 1
fi

DEPS_LIST=(wget tar udisksctl docker) # lib32stdc++6 curl pv unzip hdparm sudo file udev golang-go jq)

TMP_DIR="/tmp/duckietown"
mkdir -p ${TMP_DIR}

MOD_FILE="${TMP_DIR}/mod"

ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
ETCHER_DIR="${TMP_DIR}/etcher-cli"
TMP_ETCHER_LOCAL=$(mktemp -p ${TMP_DIR})

HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.9.0/hypriotos-rpi-v1.9.0.img.zip"
HYPRIOT_LOCAL="${TMP_DIR}/${HYPRIOT_URL##*/}"

IMAGE_DOWNLOADER_CACHEDIR="${TMP_DIR}/docker_images"
mkdir -p ${IMAGE_DOWNLOADER_CACHEDIR}

DUCKIE_ART_URL="https://raw.githubusercontent.com/duckietown/Software/master/misc/duckie.art"

declare -A PRELOADED_DOCKER_IMAGES=( \
    ["portainer"]="portainer/portainer:linux-arm" \
    # ["duckietown"]="duckietown/software:latest" \
)

prompt_for_configs() {
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
    read -p "Please enter a hostname (default is $DEFAULT_HOSTNAME) > " HOST_NAME
    HOST_NAME=${HOST_NAME:-$DEFAULT_HOSTNAME}
    read -p "Please enter a WIFI SSID (default is $DEFAULT_WIFISSID) > " WIFISSID
    WIFISSID=${WIFISSID:-$DEFAULT_WIFISSID}
    read -p "Please enter a WIFI PSK (default is $DEFAULT_WIFIPASS) > " WIFIPASS
    WIFIPASS=${WIFIPASS:-$DEFAULT_WIFIPASS}
}

check_deps() {
    missing_deps=()
    for dep in ${DEPS_LIST[@]}; do
        if [ ! $(command -v ${dep}) ]; then
            missing_deps+=("${dep}")
        fi
    done
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "The following dependencies are missing. Please install corresponding packages for:"
        echo "${missing_deps[@]}"
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
}

download_etcher() {
    if [ -f "$ETCHER_DIR/etcher" ]; then
        echo "Prior etcher-cli install detected at $ETCHER_DIR, skipping..."
    else
        # Download tool to burn image
        echo "Downloading etcher-cli..."
        wget -cO "${TMP_ETCHER_LOCAL}" "${ETCHER_URL}"
        
        # Unpack archive
        echo "Installing etcher-cli to $ETCHER_DIR..."
        mkdir -p $ETCHER_DIR && tar fvx ${TMP_ETCHER_LOCAL} -C ${ETCHER_DIR} --strip-components=1
    fi
   
    rm -rf ${TMP_ETCHER_LOCAL}
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
    sudo -p "[sudo] Enter password for '%p' which is required to run Etcher: " \
        ${ETCHER_DIR}/etcher -u false ${HYPRIOT_LOCAL}
    echo "Flashing Hypriot image succeeded."
}

download_docker_image() {
    image_name="$1"
    docker_tag="$2"
    image_filename="${IMAGE_DOWNLOADER_CACHEDIR}/${image_name}.tar.gz"

    # download docker image if it doesn't exist
    if [ -f ${image_filename} ]; then
        echo "${docker_tag} was previously downloaded to ${image_filename}, skipping..."
    else
        echo "Downloading ${docker_tag} from Docker Hub..."
        docker pull ${docker_tag} && docker save --output ${image_filename} ${docker_tag}
    fi
}

download_docker_images() {
    for image_name in "${!PRELOADED_DOCKER_IMAGES[@]}"; do
        docker_tag=${PRELOADED_DOCKER_IMAGES[$image_name]}
        download_docker_image ${image_name} ${docker_tag}
    done
}

# todo - move this in the cloud-init payload
preload_docker_images() {
    echo "Configuring DuckieOS installation..." 
    # Preload image(s) to speed up first boot
    echo "Writing preloaded Docker images to /var/local/"
    for image_name in "${!PRELOADED_DOCKER_IMAGES[@]}"; do
        docker_tag=${PRELOADED_DOCKER_IMAGES[$image_name]}
        image_filename="${IMAGE_DOWNLOADER_CACHEDIR}/${image_name}.tar.gz"
        sudo cp ${image_filename} $TMP_ROOT_MOUNTPOINT/var/local/
    done
}

write_configurations() {
    # Add i2c to boot configuration
    echo "dtparam=i2c1=on" >> $TMP_HYPRIOT_MOUNTPOINT/config.txt
    echo "dtparam=i2c_arm=on" >> $TMP_HYPRIOT_MOUNTPOINT/config.txt
}

write_motd() {
    # todo: check if the file on the server changed
    if [ ! -f $MOD_FILE ]; then
        echo "Downloading Message Of the Day"
        wget --no-check-certificate -O $MOD_FILE $DUCKIE_ART_URL
    fi
    sudo cp $MOD_FILE $TMP_ROOT_MOUNTPOINT/etc/update-motd.d/duckie.art
    printf '#!/bin/sh\nprintf "\\n$(cat /etc/update-motd.d/duckie.art)\\n"\n' | sudo tee -a $TMP_ROOT_MOUNTPOINT/etc/update-motd.d/20-duckie > /dev/null
    sudo chmod +x $TMP_ROOT_MOUNTPOINT/etc/update-motd.d/20-duckie
}

# todo - move this in the cloud-init payload
copy_ssh_credentials() {
    PUB_KEY=/home/${USER}/.ssh/id_rsa.pub
    if [ -f $PUB_KEY ]; then
        echo "Writing $PUB_KEY to $TMP_ROOT_MOUNTPOINT/home/$USERNAME/.ssh/authorized_keys"
        sudo mkdir -p $TMP_ROOT_MOUNTPOINT/home/$USERNAME/.ssh
        cat $PUB_KEY | sudo tee -a $TMP_ROOT_MOUNTPOINT/home/$USERNAME/.ssh/authorized_keys > /dev/null
    fi
}

mount_disks() {
    # wait 1 second for the /dev/disk/by-label to be refreshed
    sleep 1s
    TMP_ROOT_MOUNTPOINT="/media/$USER/root"
    TMP_HYPRIOT_MOUNTPOINT="/media/$USER/HypriotOS"
    udisksctl mount -b /dev/disk/by-label/HypriotOS
    udisksctl mount -b /dev/disk/by-label/root
}

unmount_disks() {
    udisksctl unmount -b /dev/disk/by-label/HypriotOS
    udisksctl unmount -b /dev/disk/by-label/root
}

write_userdata() {
    echo "Writing custom cloud-init user-data..."
    USER_DATA=$(cat <<EOF
#cloud-config
# vim: syntax=yaml

# The currently used version of cloud-init is 0.7.9
# http://cloudinit.readthedocs.io/en/0.7.9/index.html

hostname: $HOST_NAME
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
      country=CA
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
        i2c-bcm2708
        i2c-dev
    path: /etc/modules
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
#   - [ modprobe, i2c-bcm2708 ]
#   - [ modprobe, i2c-dev ]
  - [ systemctl, stop, docker ]
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker-tcp.socket ]
  - [ systemctl, start, --no-block, docker ]
  - [ docker, swarm, init ]
  - [ docker, load, "--input", "/var/local/portainer.tar.gz" ]
# Disabled pre-loading duckietown/software due to insuffient space on /var/local
# https://github.com/hypriot/image-builder-rpi/issues/244#issuecomment-390512469
#  - [ docker, load, "--input", "/var/local/software.tar.gz"]

# for convenience, we will install and start Portainer.io
   - 'docker service create --detach=false --name portainer --quiet --no-resolve-image --publish published=9000,target=9000,mode=host --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock portainer/portainer:linux-arm -H unix:///var/run/docker.sock --no-auth'
EOF
)
    echo "$USER_DATA" > $TMP_HYPRIOT_MOUNTPOINT/user-data
}


# main()

# configs
check_deps
prompt_for_configs

# downloads
download_etcher
download_hypriot
download_docker_images

# flash
flash_hypriot

#write_custom_files
mount_disks
    preload_docker_images
    copy_ssh_credentials
    write_configurations
    write_motd
    write_userdata
    sync  # flush all buffers
unmount_disks

echo "Finished preparing SD card. Please remove and insert into a Duckiebot."

#end main()
