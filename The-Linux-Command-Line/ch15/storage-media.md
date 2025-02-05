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

##### Determining Device Names


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

Linux Storage Device Names

* /dev/fd* Floppy disk drives
* /dev/hd* IDE (PATA) disks on older systems.
* /dev/lp* Printers
* /dev/sd* SCSI disks. On modern Linux systems, the kernel treats all disk-like devices as SCSI disks.
* /dev/sr* Optical drives (CD/DVD readers and burners)

In addition, we often see symbolic links such as _/dev/cdrom_, _/dev/dvd_, and _/dev/floppy_, which point to the actual device files, provided as a convenience.

```
$ ll /dev/cd* /dev/dvd* /dev/sr0
lrwxrwxrwx  1 root root      3 Feb  5 08:06 /dev/cdrom -> sr0
lrwxrwxrwx  1 root root      3 Feb  5 08:06 /dev/cdrw -> sr0
lrwxrwxrwx  1 root root      3 Feb  5 08:06 /dev/dvd -> sr0
lrwxrwxrwx  1 root root      3 Feb  5 08:06 /dev/dvdrw -> sr0
brw-rw----+ 1 root cdrom 11, 0 Feb  5 08:06 /dev/sr0
```

```
$ sudo tail -f /var/log/syslog
Feb  5 08:13:16 dstevensonlinux1 systemd[1624]: Started Tracker metadata database store and lookup manager.
Feb  5 08:13:16 dstevensonlinux1 udisksd[951]: Unmounted /dev/sr0 on behalf of uid 1000
Feb  5 08:13:46 dstevensonlinux1 tracker-store[12555]: OK
Feb  5 08:13:46 dstevensonlinux1 systemd[1624]: tracker-store.service: Succeeded.
Feb  5 08:17:01 dstevensonlinux1 CRON[12811]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Feb  5 08:30:01 dstevensonlinux1 CRON[13027]: (root) CMD ([ -x /etc/init.d/anacron ] && if [ ! -d /run/systemd/system ]; then /usr/sbin/invoke-rc.d anacron start >/dev/null; fi)
Feb  5 08:30:59 dstevensonlinux1 systemd[1]: Started Run anacron jobs.
Feb  5 08:30:59 dstevensonlinux1 anacron[13058]: Anacron 2.3 started on 2025-02-05
Feb  5 08:30:59 dstevensonlinux1 anacron[13058]: Normal exit (0 jobs run)
Feb  5 08:30:59 dstevensonlinux1 systemd[1]: anacron.service: Succeeded.
```

Insert flash drive.

```
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.567186] usb 2-1.6: new high-speed USB device number 5 using ehci-pci
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.682543] usb 2-1.6: New USB device found, idVendor=058f, idProduct=6387, bcdDevice= 1.00
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.682546] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.682549] usb 2-1.6: Product: Mass Storage
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.682550] usb 2-1.6: Manufacturer: Generic
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.682552] usb 2-1.6: SerialNumber: B65369E4
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.683047] usb-storage 2-1.6:1.0: USB Mass Storage device detected
Feb  5 08:40:59 dstevensonlinux1 kernel: [ 9383.685170] scsi host7: usb-storage 2-1.6:1.0
Feb  5 08:40:59 dstevensonlinux1 mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6"
Feb  5 08:40:59 dstevensonlinux1 mtp-probe: bus: 2, device: 5 was not an MTP device
Feb  5 08:40:59 dstevensonlinux1 mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6"
Feb  5 08:40:59 dstevensonlinux1 mtp-probe: bus: 2, device: 5 was not an MTP device
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.705172] scsi 7:0:0:0: Direct-Access     Generic  Flash Disk       8.07 PQ: 0 ANSI: 4
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.705550] sd 7:0:0:0: Attached scsi generic sg7 type 0
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.706731] sd 7:0:0:0: [sdg] 7864320 512-byte logical blocks: (4.03 GB/3.75 GiB)
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.709331] sd 7:0:0:0: [sdg] Write Protect is off
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.709337] sd 7:0:0:0: [sdg] Mode Sense: 23 00 00 00
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.713885] sd 7:0:0:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.732370]  sdg: sdg1
Feb  5 08:41:00 dstevensonlinux1 kernel: [ 9384.760989] sd 7:0:0:0: [sdg] Attached SCSI removable disk
Feb  5 08:41:01 dstevensonlinux1 systemd[1]: Finished Clean the /media/dstevenson/3C02-FD57 mount point.
Feb  5 08:41:01 dstevensonlinux1 udisksd[951]: Mounted /dev/sdg1 at /media/dstevenson/3C02-FD57 on behalf of uid 1000
Feb  5 08:41:01 dstevensonlinux1 dbus-daemon[1639]: [session uid=1000 pid=1639] Activating via systemd: service name='org.freedesktop.Tracker1' unit='tracker-store.service' requested by ':1.70' (uid=1000 pid=2059 comm="/usr/libexec/tracker-miner-fs " label="unconfined")
Feb  5 08:41:01 dstevensonlinux1 dbus-daemon[1639]: [session uid=1000 pid=1639] Activating service name='org.gnome.Shell.HotplugSniffer' requested by ':1.25' (uid=1000 pid=1777 comm="/usr/bin/gnome-shell " label="unconfined")
Feb  5 08:41:01 dstevensonlinux1 systemd[1624]: Starting Tracker metadata database store and lookup manager...
Feb  5 08:41:01 dstevensonlinux1 dbus-daemon[1639]: [session uid=1000 pid=1639] Successfully activated service 'org.freedesktop.Tracker1'
Feb  5 08:41:01 dstevensonlinux1 systemd[1624]: Started Tracker metadata database store and lookup manager.
Feb  5 08:41:01 dstevensonlinux1 dbus-daemon[1639]: [session uid=1000 pid=1639] Successfully activated service 'org.gnome.Shell.HotplugSniffer'
Feb  5 08:41:31 dstevensonlinux1 tracker-store[13551]: OK
Feb  5 08:41:31 dstevensonlinux1 systemd[1624]: tracker-store.service: Succeeded.

```

### Creating New File Systems

Suppose we want to reformat the flash drive wityh a Linux native file system, rather than the FAT32 system it has now. This involves two steps.

1. (optional) create a new partition layout if the existing one is not to our liking.
2. Create a new, empty file system on the drive.

#### Manipulating Partitions with fdisk

It was easy to format the thumb drive using the Disks application.

If you want to use the fdisk command line, determine the /dev/sd* 

Example (verify device first! using Disks application)

```
sudo umount /dev/sdg
sudo fdisk /dev/sdg
```

```
$ sudo fdisk /dev/sdg

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): 

```

```
Command (m for help): p
Disk /dev/sdg: 3.77 GiB, 4026531840 bytes, 7864320 sectors
Disk model: Flash Disk      
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xa2f07b25
```

```
Command (m for help): l

 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden or  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi ea  Rufus alignment
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f0  Linux/PA-RISC b
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f4  SpeedStor      
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      f2  DOS secondary  
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fb  VMware VMFS    
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fc  VMware VMKCORE 
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
1c  Hidden W95 FAT3 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
1e  Hidden W95 FAT1 80  Old Minix       be  Solaris boot    ff  BBT    
```

```
Command (m for help): t
No partition is defined yet!

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-7864319, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-7864319, default 7864319): 

Created a new partition 1 of type 'Linux' and of size 3.8 GiB.
```

```
Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): 83
Changed type of partition 'Linux' to 'Linux'.
```

```
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

#### Creating a New File System with mkfs

`mkfs` - Make File System

```
$ sudo mkfs -t ext4 /dev/sdg
mke2fs 1.45.5 (07-Jan-2020)
Found a dos partition table in /dev/sdg
Proceed anyway? (y,N) y
Creating filesystem with 983040 4k blocks and 245760 inodes
Filesystem UUID: a8677690-e1dc-48fe-bd0b-ad959e206cde
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 
```

To reformat as its original FAT32 file system, specify `vfat` as the file system type.

`$ sudo mkfs -t vfat /dev/sdg`

### Testing and Repairing File Systems

To check our flash drive (which should be unmounted first), we could do the following:

```
$ umount /dev/sdg
$ sudo fsck /dev/sdg
fsck from util-linux 2.34
e2fsck 1.45.5 (07-Jan-2020)
/dev/sdg: clean, 11/245760 files, 35658/983040 blocks
```

These days, file system corruption is  quite rare unless there is a hardware problem, such as a failing disk drive.

On most systems, file system corruption detected at boot time will cause the system to stop and drirect you to run `fsck` before continuing.

### Moving Data Directly to and from Devices

The `dd` program performs this task.
It copies blocks of data from one place to another.

`dd if=input_file of=output_file [bs=block_size [count=blocks]]`

`dd if=/dev/sdb of=/dev/sdc`

`dd if/dev/sdb of=flash_drive.img`

#### Creating CD-ROM Images

Writing a recordable CD-ROM (either a CD-R or CD-RW) consists of two steps.

1. Constructing an ISO image file that is the exact file system image of tbe CD-ROM.
2. Writing the image file onto the CD-ROM.

##### Creating an Image Copy of a CD-ROM

If we want to make an ISO image of an existing CD-ROM, we can use dd to read all the data blocks off the CD-ROM and copy them to a local file. Say we had an Ubuntu CD and we wanted to make an ISO file that we could later use to make more copies.

`dd if=/dev/cdrom of=ubuntu.iso`

This technique works for data DVDs as well but will not work for audio cdS, as they do not use a file system for storage.

##### Creating an Image from a Collection of Files

To create an ISO image file containing the contents of a diretory, we use the `genisoimage` program.

Create an image file named _cd-rom.iso_ from ~/cd-rom-files.

`genisoimage -o cd-rom.iso -R-J ~/cd-rom-files`

The \-R option adds metadata for the _Rock Ridge extensions_, which allows the use of long filenames and POSIX-style file permissions. Likewise, the \-J option enables the _Joliet extensions_, which permit long filenames for Windows.

#### Writing CD-ROM Images

After we have an image file, we can bur it onto our optical media.

##### Mounting an ISO Image Directly

By adding the -o loop option to _mount_ (along with the required -t iso9660 file system type), we can mount the image file as though it were a device and attach it to the file system tree.

```
mkdir /mnt/iso_image
mount -t iso9660 -o loop image.iso /mnt/iso_image
```

In this example, we created a mount point named _/mnt/iso_image_ and then mounted the image file _image.iso_ at that mount point. After the image is mounted, it  can be treated just as though it were a real CD-ROM or DVD. _Remember to unmount the image when it is no longer needed_.

#### Blanking a Rewritable CD-ROM

Rewritable CD-RW media needs to be erased or _blanked_ before it can be reused. To this, we can use _wodim_, specifying the device name forthe CD writer and the type of blanking to be performed.

`wodim dev=/dev/cdrw blank=fast`
