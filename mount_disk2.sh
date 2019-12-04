# ensure you are root
CHK1=`whoami`

if
[ $CHK1 = "root" ]
then
echo "You are root "
else
echo "You are not root"
exit
fi

DSK2=`fdisk -l | grep ^Disk | grep 477 | awk '{print $2}' | cut -d _ -f 1`

echo "Amending $DSK2"
echo "g then w"

fdisk $DSK2

#encrypting second disk
cryptsetup -y -v luksFormat $DSK2

cryptsetup luksOpen $DSK2 disk2_crypt

#create physical volume (data_crypt)
pvcreate /dev/mapper/disk2_crypt

#create volume group (data_crypt_vg)
vgcreate data_crypt_vg dev/mapper/disk2_crypt

# create logical volume (data)
lvcreate -l 100%FREE -n data /dev/data_crypt_vg

# format new volume (data)
mkfs.ext4 /dev/data_crypt_vg/data

# mount the new volume (data)
mkdir /data
mount /dev/data_crypt_vg/data /data

# unlocking new volume on boot
dd if=/dev/urandom of=/root/.keyfile bs=1024 count=4
chmod 0400 /root/.keyfile
cryptsetup luksAddKey $DSK2 /root/.keyfile

# getting the UUID
ID0="UUID"
ID1=`blkid $DSK2 | awk '{print $2}' | cut -d \" -f 2`
ID2="data_crypt_vg $ID0=$ID1 none luks,discard"
echo "$ID2" >> /etc/crypttab

ID3="/dev/mapper/data_crypt_vg-data    /data    ext4     defaults    0    2"
echo "$ID3" >> /etc/fstab
