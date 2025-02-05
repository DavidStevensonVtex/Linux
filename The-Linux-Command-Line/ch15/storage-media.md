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

#### Viewing a List of Mounted File Systems

The _mount_ command is used to mount file systems.
This command without arguments will display a list of file systems currently mounted.


```
$ ls /dev
autofs           fd         input   loop23        psaux   sg2       tty14  tty31  tty49  tty9       ttyS24   userio  vcsu4
block            full       kmsg    loop3         ptmx    sg3       tty15  tty32  tty5   ttyprintk  ttyS25   vcs     vcsu5
bsg              fuse       log     loop4         pts     sg4       tty16  tty33  tty50  ttyS0      ttyS26   vcs1    vcsu6
btrfs-control    gpiochip0  loop0   loop5         random  sg5       tty17  tty34  tty51  ttyS1      ttyS27   vcs2    vfio
bus              hidraw0    loop1   loop6         rfkill  sg6       tty18  tty35  tty52  ttyS10     ttyS28   vcs3    vga_arbiter
cdrom            hidraw1    loop10  loop7         rtc     shm       tty19  tty36  tty53  ttyS11     ttyS29   vcs4    vhci
cdrw             hpet       loop11  loop8         rtc0    snapshot  tty2   tty37  tty54  ttyS12     ttyS3    vcs5    vhost-net
char             hugepages  loop12  loop9         sda     snd       tty20  tty38  tty55  ttyS13     ttyS30   vcs6    vhost-vsock
console          hwrng      loop13  loop-control  sda1    sr0       tty21  tty39  tty56  ttyS14     ttyS31   vcsa    zero
core             i2c-0      loop14  mapper        sda2    stderr    tty22  tty4   tty57  ttyS15     ttyS4    vcsa1   zfs
cpu              i2c-1      loop15  mcelog        sdb     stdin     tty23  tty40  tty58  ttyS16     ttyS5    vcsa2
cpu_dma_latency  i2c-2      loop16  mei0          sdb1    stdout    tty24  tty41  tty59  ttyS17     ttyS6    vcsa3
cuse             i2c-3      loop17  mem           sdb2    tty       tty25  tty42  tty6   ttyS18     ttyS7    vcsa4
disk             i2c-4      loop18  mqueue        sdc     tty0      tty26  tty43  tty60  ttyS19     ttyS8    vcsa5
dri              i2c-5      loop19  net           sdd     tty1      tty27  tty44  tty61  ttyS2      ttyS9    vcsa6
dvd              i2c-6      loop2   null          sde     tty10     tty28  tty45  tty62  ttyS20     udmabuf  vcsu
dvdrw            i2c-7      loop20  nvram         sdf     tty11     tty29  tty46  tty63  ttyS21     uhid     vcsu1
ecryptfs         i2c-8      loop21  port          sg0     tty12     tty3   tty47  tty7   ttyS22     uinput   vcsu2
fb0              initctl    loop22  ppp           sg1     tty13     tty30  tty48  tty8   ttyS23     urandom  vcsu3
```

CDs are auto-mounted. An alert recognizing the CD/DVD insertion will prompt use to open the Files application to see the contents of the CD/DVD. The Files application can be also used to unmount the
CD/DVD.

* Parent Folder: /media/dstevenson
* Volume: GRMSXEVAL_EN_DVD


```
$ ll /media/dstevenson
total 10
drwxr-x---+ 3 root       root       4096 Feb  5 08:06 ./
drwxr-xr-x  3 root       root       4096 Dec  5 15:27 ../
dr-xr-xr-x  7 dstevenson dstevenson  548 Jul 14  2009 GRMSXEVAL_EN_DVD/
```

Unmounting CD/DVD

`$ umount /media/dstevenson/GRMSXEVAL_EN_DVD/`


##### Unmounting a CD and Remounting at new mount point

```
$ sudo umount /dev/sdc
[sudo] password for dstevenson: 
umount: /dev/sdc: not mounted.
```