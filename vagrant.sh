#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export MER_ROOT=/srv/mer

if [ ! -e /etc/firstrun ]; then
  touch /etc/firstrun
  apt-get update && apt-get upgrade -y
  apt-get install aria2 curl wget vim htop -y
fi

if [ ! -e $MER_ROOT ]; then
  mkdir -p $MER_ROOT/sdks/sdk
  aria2c --dir=/tmp -x 5 --check-certificate=false https://img.merproject.org/images/mer-sdk/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2
  cd $MER_ROOT/sdks/sdk
  sudo tar --numeric-owner -p -xjf /tmp/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2
fi

if ! grep MER_ROOT /home/vagrant/.bashrc; then
  echo "export MER_ROOT=$MER_ROOT" >> /home/vagrant/.bashrc
  echo 'alias sdk=$MER_ROOT/sdks/sdk/mer-sdk-chroot' >> /home/vagrant/.bashrc
  echo "echo ." >> /home/vagrant/.bashrc
  echo 'echo To enter the SDK environment please type: sdk' >> /home/vagrant/.bashrc
fi

cat << 'EOF' > /home/vagrant/.mersdk.profile
PS1="MerSDK $PS1"
if [ -d /etc/bash_completion.d ]; then
   for i in /etc/bash_completion.d/*;
   do
	. $i
   done
fi
EOF


