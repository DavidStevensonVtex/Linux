# The Linux Command Line, 2nd Edition, © 2019

## Chapter 15: Storage Media

* mount Mount a file system
* umount Unmount a file system
* fsck Check and repair a file system
* fdisk Manipulate disk partition table
* mkfs Create a file system
* dd Convert and copy a file
* genisoimage (mkisofs) Create an ISO 9660 image file
* wodim (cdrecord) Write data to optical storage media
* md5sum Calculate an MD5 checksum

### Mounting and Unmounting Storage Devices

In the old days (say, 2004) this stuff had to be done manually.

The first step in managing a storage device is attaching the device to the file system tree.
This rocess, called _mounting_, allows the device to interact with the operating system.

A file named _/etc/fstab_ (short for "file system table") lists the devices (typically hard disk partitions) that are mounted at boot time.

```
$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=97772a19-33ef-4041-a1f6-91c36f7fd7bb /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/sda1 during installation
UUID=70C9-E06B  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0
```

/etc/fstab Fields

* 1 Device
* 2 Mount point
* 3 File system type
* 4 Options
* 5 Frequency
* 6 Order
