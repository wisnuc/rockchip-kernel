# 内核编译说明

在`configs`目录下提供了3个文件，分别放在不同版本命名的目录内。

+ `rk3328.dtsi`文件来自mainline内核有少量修改，可以不修改使用；
+ `rk3320-rock64.dts`文件根据abel板的实际硬件原理和功能要求做了相应的修改；
+ `rockchip_linux_defconfg`是内核配置，仅供参考，原始文件来自rockchip的开源项目，该文件没有和rk官方项目同步的必要；

`build.sh`文件仅供参考。

# 内核配置说明

## WLAN

支持wlan要求内核使能如下配置：

**CFG80211 & CFG80211_WEXT**

```
Networking support > Wireless
    <M>   cfg80211 - wireless configuration API
    ....
    [*]     cfg80211 wireless extensions compatibility
```

该选项应该选择为module编译，否则需要修改initramfs把firmware放进去；如果选择为内置模块又不在initramfs里提供firmware会观察到错误并且在磁盘根文件系统挂载时并不会再次触发probe加载固件，必须bind/unbind driver。

CFG80211选项不是必须的，但有些linux wifi网络配置命令需要该接口工作；

**BRCMFMAC**

```
Device Drivers > Network device support > Wireless LAN
    [*]   Broadcom devices
    <M>     Broadcom FullMAC WLAN driver
    [*]     SDIO bus interface support for FullMAC driver
    ....
    [ ]     Broadcom driver debug functions
```

如果需要打印brcmfmac的调试信息可以打开debug选项，在insmod的时候提供loglevel参数；

firmware文件为：`/lib/firmware/brcm/brcmfmac4356-sdio.bin`，armbian自带了该文件；由`linux-firmware`包提供；

```

$ dmesg | grep brcmfmac

brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4356-sdio.clm_blob failed with error -2
brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4356/2 wl0: May 14 2014 19:51:52 version 7.35.17 (r477908) FWID 01-2ed3ee81
```

TODO 补充brcmfmac的dts配置说明

其他：

linux内核支持从userspace强制bind/unbind driver；对于sdio来说没有别的办法强制probe，使用bind/unbind是一个办法：

```
# unbind sdio host driver
echo -n "ff510000.dwmmc" > /sys/devices/platform/ff510000.dwmmc/driver/unbind
# bind sdio host driver
echo -n "ff510000.dwmmc" > /sys/devices/platform/ff510000.dwmmc/subsystem/drivers/dwmmc_rockchip/bind
```