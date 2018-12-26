This is not a source repo.

This repo holds only the kernel config and dts file for wisnuc hardware based on Rockchip processors.

This repo provides kernel deb package via github release for other repo to build the rootfs or full system image. Do not use this repo as the source for installing or updating a kernel on a user system.

Each release has the following conventions.

**tag_name**

`tag_name` should start with a lower-case `v`, followed by `${major}.${minor}.${revision}.${build}`. 

The build string is padded to 3-digits. 

Example: `v4.19.12.001`

**files (assets)**

Each release should include `buildinfo`, `changes`, `headers`, `image`, `libc-dev`, and optionally, `dbg` package.

They must be named as the following if provided:

```
linux-${tag_name}-arm64.buildinfo
linux-${tag_name}-arm64.changes
linux-headers-${tag_name}-arm64.deb
linux-image-${tag_name}-arm64.deb
linux-image-${tag_name}-dbg-arm64.deb # optional
linux-libc-dev-${tag_name}-arm64.deb
```

**pre-release**

beta release should sete pre-release to true.


