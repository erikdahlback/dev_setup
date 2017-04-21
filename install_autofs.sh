#!/bin/sh
#

# Open firewall for SMB and NFS
# Or disable it completely
disable_firewall()
{
  if which firewall-cmd >/dev/null 2>&1; then
    firewall-cmd   --add-service=samba
    firewall-cmd   --add-service=nfs
    return 0
  fi
  sudo chkconfig iptables off && return

  echo >&2 you may need to set up the firewall
}

#
prepare_nfs_packages()
{
  if ! which mount.nfs >/dev/null; then
    if which yum >/dev/null; then 
      sudo yum install nfs-utils
    fi &&
    if which apt-get >/dev/null; then 
      sudo apt-get install nfs-common
    fi
  fi &&
  file=/etc/idmapd.conf
  if ! grep "Local-Realms = esss.lu.se" $file ; then
    sudo cp $file $file.orig &&
    sed -e "s/# set your own domain here.*/Local-Realms = esss.lu.se/" \
    -e "s/#Local-Realms =.*/Local-Realms = esss.lu.se/"  \
    <$file.orig >/tmp/$$.new &&
    sudo mv -f /tmp/$$.new $file
  fi &&
  if ! grep "Domain = esss.lu.se" $file ; then
    sudo cp $file $file.orig &&
    sed -e "s/# Domain = localdomain/Domain = esss.lu.se/" \
    -e "s/#Domain = local.domain.edu.*/Domain = esss.lu.se/" \
    <$file.orig >/tmp/$$.new &&
    sudo mv -f /tmp/$$.new $file
  fi 
}
#
add_to_etc_auto_nfs()
{
  nfsXdata="$1"

  filename=auto.nfs
  tmpfile=/tmp/$filename.$$
  if ! grep "$nfsXdata" /etc/$filename; then
    echo sudo touch /etc/$filename &&
    sudo touch /etc/$filename &&
    cp /etc/$filename $tmpfile &&
    echo "$nfsXdata" >>$tmpfile &&
    echo sudo cp $tmpfile /etc/$filename &&
    sudo cp $tmpfile /etc/$filename
  fi
}

disable_firewall &&
prepare_nfs_packages &&

if ! test -f /etc/auto.master; then
  if type yum >/dev/null 2>/dev/null; then
    echo sudo yum install autofs &&
    sudo yum install autofs
  elif type apt-get >/dev/null 2>/dev/null; then
    echo sudo apt-get install autofs &&
    sudo apt-get install autofs
  else
    echo >&2 not a yum system, update script
    exit 1
  fi
fi


if ! test -f /etc/auto.master; then
  echo >&2 /etc/auto.master not found, update script
  exit 1
fi &&
if ! grep "^/nfs */etc/auto.nfs" /etc/auto.master >/dev/null 2>/dev/null
then
  (
    tmpfile=/tmp/auto.master.$$
    cp /etc/auto.master $tmpfile &&
    echo "/nfs    /etc/auto.nfs" >>$tmpfile
    echo "cp $tmpfile /etc/auto.master" &&
    sudo cp $tmpfile /etc/auto.master
  )
fi &&
(
  add_to_etc_auto_nfs "home -fstype=nfs4 nfs01.esss.lu.se:/home" &&
  for NFX in nfs01; do
    #Note: nfs02 should be phased out
    nfsXdata="${NFX}-data -fstype=nfs4 ${NFX}.esss.lu.se:/exports/${NFX}-data"
    add_to_etc_auto_nfs "$nfsXdata"
  done
) &&
sudo service autofs restart
sudo systemctl enable autofs


