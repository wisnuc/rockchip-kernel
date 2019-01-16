# 如何在armbian上使用abel内核

rock64的armbian预编译二进制镜像可以在abel板子上直接boot起来，版本为4.4，但dtb文件与abel不符。

步骤如下：

1. [下载](https://www.armbian.com/rock64/)armbian的rock64镜像；使用页面上左侧的default版本，右侧是default_desktop，更大；
2. armbian官方推荐使用[Etcher]()烧录镜像到mmc卡；
3. 用mmc卡启动abel，完成首次启动配置，然后poweroff系统，取出mmc卡；
4. 把内核deb文件放到mmc卡的用户目录下；然后重新boot abel板；
5. 登录之后，用`dpkg -i`安装内核；然后做下述修改；
    
armbian的启动目录和debian/ubuntu一致，在`/boot`目录下；

armbian使用u-boot，u-boot要求内核文件的格式是不压缩的，而debian的标准格式是压缩的，所以首先需要展开内核：

```
$ mv linux-4.19.12 linux-4.19.12.gz
$ gunzip linux-4.19.12.gz
```

修改u-boot需要的内核文件符号链

```
$ rm Image
$ ln -s linux-4.19.12 Image
```

`uInitrd`文件不需要动；armbian修改了initramfs-tool的hook，在安装内核之后会自动更新initramfs，并且用cpio格式的initramfs生成传统的initrd格式的启动盘；后者是u-boot支持的。如果不是使用armbian，这一步需要自己用`mkimage`工具更新，生成initrd文件；

`dtb`文件，armbian使用了非标准的目录；事实上armbian的编译系统分开了内核和dtb的deb文件；本项目采用标准内核方式，在内核的deb包里自带了dtb文件，路径是debian/ubuntu的标准dtb文件路径

```
$ rm dtb
$ ln -s /usr/lib/linux-image-4.19.12 dtb
```

完成以上修改后，reboot系统，即可看到新的内核和dtb文件生效。
