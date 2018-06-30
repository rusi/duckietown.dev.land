#!/bin/bash

#for debugging, enable command printout
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

DEPS_LIST=(wget tar udisksctl docker base64) # lib32stdc++6 curl pv unzip hdparm sudo file udev golang-go jq)

TMP_DIR="/tmp/duckietown"
mkdir -p ${TMP_DIR}

ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
ETCHER_DIR="${TMP_DIR}/etcher-cli"
TMP_ETCHER_LOCAL=$(mktemp -p ${TMP_DIR})

HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.9.0/hypriotos-rpi-v1.9.0.img.zip"
HYPRIOT_LOCAL="${TMP_DIR}/${HYPRIOT_URL##*/}"

IMAGE_DOWNLOADER_CACHEDIR="${TMP_DIR}/docker_images"
mkdir -p ${IMAGE_DOWNLOADER_CACHEDIR}

MOD_FILE="${TMP_DIR}/mod"
DUCKIE_ART_URL="https://raw.githubusercontent.com/duckietown/Software/master/misc/duckie.art"

declare -A PRELOADED_DOCKER_IMAGES=( \
    ["portainer"]="portainer/portainer:linux-arm" \
    # ["duckietown"]="duckietown/software:latest" \
)

read_password() {
    # thanks: https://stackoverflow.com/questions/1923435/how-do-i-echo-stars-when-reading-password-with-read
    # unset password
    password=""
    prompt=$1
    while IFS= read -p "$prompt" -r -s -n 1 char
    do
        if [[ $char == $'\0' ]]; then
            break
        fi
        # thanks: https://askubuntu.com/questions/299437/how-can-i-use-the-backspace-character-as-a-backspace-when-entering-a-password
        if [[ $char == $'\177' ]];  then
            prompt=$'\b \b'
            password="${password%?}"
        else
            prompt='*'
            password+="$char"
        fi
    done
    echo
    # thanks: https://stackoverflow.com/questions/3236871/how-to-return-a-string-value-from-a-bash-function
    eval "$2='$password'"
}

prompt_for_configs() {
    echo "Configuring DuckiebotOS (press ^C to cancel)..."
    
    DEFAULT_HOSTNAME="duckiebot"
    DEFAULT_USERNAME="duckie"
    DEFAULT_PASSWORD="quackquack"
    DEFAULT_WIFISSID="duckietown"
    DEFAULT_WIFIPASS="quackquack"
    
    read -p "Please enter a username (default is $DEFAULT_USERNAME) > " USERNAME
    USERNAME=${USERNAME:-$DEFAULT_USERNAME}
    read_password "Please enter a password (default is $DEFAULT_PASSWORD) > " PASSWORD
    PASSWORD=${PASSWORD:-$DEFAULT_PASSWORD}
    read -p "Please enter a hostname (default is $DEFAULT_HOSTNAME) > " HOST_NAME
    HOST_NAME=${HOST_NAME:-$DEFAULT_HOSTNAME}
    read -p "Please enter a WIFI SSID (default is $DEFAULT_WIFISSID) > " WIFISSID
    WIFISSID=${WIFISSID:-$DEFAULT_WIFISSID}
    read_password "Please enter a WIFI PSK (default is $DEFAULT_WIFIPASS) > " WIFIPASS
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
    sudo -k -p "[sudo] Enter password for '%p' which is required to run Etcher: " \
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
        # TODO: find a way to pre-load docker containers without needing SUDO access
        sudo -p "[sudo] Enter password for '%p' which is required to pre-load docker containers: " \
            cp ${image_filename} $TMP_ROOT_MOUNTPOINT/var/local/
    done
    sudo -K # forget any cached sudo credentials
}

write_configurations() {
    _cfg="$TMP_HYPRIOT_MOUNTPOINT/config.txt"
    # Add i2c to boot configuration
    sed $_cfg -i -e "s/^start_x=0/start_x=1/"
    sed $_cfg -i -e "s/^gpu_mem=16/gpu_mem=256/"
    echo "dtparam=i2c1=on" >> $_cfg
    echo "dtparam=i2c_arm=on" >> $_cfg
}

write_motd() {
    # todo: check if the file on the server changed
    if [ ! -f $MOD_FILE ]; then
        echo "Downloading Message of the Day"
        wget --no-check-certificate -O $MOD_FILE $DUCKIE_ART_URL
    fi
    DUCKIE_ART=$(cat $MOD_FILE | base64 -w 0)
}

copy_ssh_credentials() {
    PUB_KEY=$(cat /home/${USER}/.ssh/id_rsa.pub)
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
  - encoding: b64 
    content: $DUCKIE_ART
    path: /etc/update-motd.d/duckie.art
  - content: |
      #!/bin/sh
      printf "\n$(cat /etc/update-motd.d/duckie.art)\n"
    path: /etc/update-motd.d/20-duckie
    permissions: '0755'
  - content: $PUB_KEY
    path: /home/$USERNAME/.ssh/authorized_keys
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
  - [ docker, load, "--input", "/var/local/portainer.tar.gz" ]
# Disabled pre-loading duckietown/software due to insuffient space on /var/local
# https://github.com/hypriot/image-builder-rpi/issues/244#issuecomment-390512469
#  - [ docker, load, "--input", "/var/local/software.tar.gz"]

# for convenience, we will install and start Portainer.io
  - 'docker run -d --restart always --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer:linux-arm -H unix:///var/run/docker.sock --no-auth'

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
