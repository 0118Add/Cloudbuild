#!/bin/bash -e

# golang 1.22
rm -rf feeds/packages/lang/golang
git clone https://$github/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://$github/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node

# Default settings
git clone https://$github/sbwml/default-settings package/new/default-settings

# lrzsz - 0.12.20
rm -rf feeds/packages/utils/lrzsz
git clone https://$github/sbwml/packages_utils_lrzsz package/new/lrzsz

# irqbalance - openwrt master
rm -rf feeds/packages/utils/irqbalance
cp -a ../master/packages/utils/irqbalance feeds/packages/utils/irqbalance
# irqbalance: disable build with numa
if [ "$ENABLE_DPDK" = "y" ]; then
    curl -s https://$mirror/openwrt/patch/irqbalance/011-meson-numa.patch > feeds/packages/utils/irqbalance/patches/011-meson-numa.patch
    sed -i '/-Dcapng=disabled/i\\t-Dnuma=disabled \\' feeds/packages/utils/irqbalance/Makefile
fi

# OpenClash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash package/new/OpenClash

# autoCore
git clone https://$github/sbwml/autocore-arm -b openwrt-23.05 package/new/autocore

# ddns-go
#git clone https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# netkit-ftp
git clone https://$github/sbwml/package_new_ftp package/new/ftp

# nethogs
git clone https://github.com/sbwml/package_new_nethogs package/new/nethogs

# SSRP & Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://$github/sbwml/openwrt_helloworld package/new/helloworld -b v5
rm -rf package/new/helloworld/{luci-app-passwall,luci-app-passwall2}
git clone -b luci-smartdns-dev --single-branch https://github.com/lwb1978/openwrt-passwall package/passwall-luci

# SmartDNS
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns

# DAED
#git clone -b master --depth 1 https://github.com/QiuSimons/luci-app-daed package/new/daed
#git clone https://$github/QiuSimons/luci-app-daed-next package/new/daed-next

# immortalwrt homeproxy
git clone https://github.com/muink/luci-app-homeproxy package/new/homeproxy
#git clone https://$github/immortalwrt/homeproxy package/new/homeproxy
#sed -i "s/ImmortalWrt/OpenWrt/g" package/new/homeproxy/po/zh_Hans/homeproxy.po
#sed -i "s/ImmortalWrt proxy/OpenWrt proxy/g" package/new/homeproxy/htdocs/luci-static/resources/view/homeproxy/{client.js,server.js}

# alist
#git clone https://$github/sbwml/openwrt-alist package/new/alist

# Netdata
rm -rf feeds/packages/admin/netdata
cp -a ../master/packages/admin/netdata feeds/packages/admin/netdata
sed -i 's/syslog/none/g' feeds/packages/admin/netdata/files/netdata.conf

# unblockneteasemusic
git clone https://$github/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/new/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/音乐解锁/g' package/new/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# Theme
git clone --depth 1 https://$github/sbwml/luci-theme-argon.git package/new/luci-theme-argon
sed -i 's/Argon 主题设置/主题设置/g' package/new/luci-theme-argon/luci-app-argon-config/po/zh_Hans/argon-config.po

# iperf3
rm -rf feeds/packages/net/iperf3
cp -a ../master/packages/net/iperf3 feeds/packages/net/iperf3
sed -i "s/D_GNU_SOURCE/D_GNU_SOURCE -funroll-loops/g" feeds/packages/net/iperf3/Makefile

# custom packages
rm -rf feeds/packages/utils/coremark
rm -rf feeds/packages/net/zerotier
git clone https://$github/8688Add/openwrt_pkgs package/new/custom --depth=1
# coremark - prebuilt with gcc15
if [ "$platform" = "rk3568" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-4-threads > package/new/custom/coremark/src/musl/coremark.aarch64
elif [ "$platform" = "rk3399" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-6-threads > package/new/custom/coremark/src/musl/coremark.aarch64
elif [ "$platform" = "armv8" ]; then
    curl -s https://$mirror/openwrt/patch/coremark/coremark.aarch64-16-threads > package/new/custom/coremark/src/musl/coremark.aarch64
fi

# luci-compat - fix translation
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# unzip
rm -rf feeds/packages/utils/unzip
git clone https://$github/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# tcp-brutal
git clone https://$github/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# 克隆immortalwrt-luci仓库
git clone --depth=1 -b openwrt-23.05 https://github.com/immortalwrt/luci.git immortalwrt-luci
#cp -rf immortalwrt-luci/applications/luci-app-alist feeds/luci/applications/luci-app-alist
#ln -sf ../../../feeds/luci/applications/luci-app-alist ./package/feeds/luci/luci-app-alist
cp -rf immortalwrt-luci/applications/luci-app-smartdns feeds/luci/applications/luci-app-smartdns
ln -sf ../../../feeds/luci/applications/luci-app-smartdns ./package/feeds/luci/luci-app-smartdns
cp -rf immortalwrt-luci/applications/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
ln -sf ../../../feeds/luci/applications/luci-app-ddns-go ./package/feeds/luci/luci-app-ddns-go
# 克隆immortalwrt-packages仓库
git clone --depth=1 -b openwrt-23.05 https://github.com/immortalwrt/packages.git immortalwrt-packages
#cp -rf immortalwrt-packages/net/alist feeds/packages/net/alist
#ln -sf ../../../feeds/packages/net/alist ./package/feeds/packages/alist
cp -rf immortalwrt-packages/net/ddns-go feeds/packages/net/ddns-go
ln -sf ../../../feeds/packages/net/ddns-go ./package/feeds/packages/ddns-go
cp -rf immortalwrt-packages/net/dae feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
cp -rf immortalwrt-packages/net/smartdns feeds/packages/net/smartdns
ln -sf ../../../feeds/packages/net/smartdns ./package/feeds/packages/smartdns
cp -rf immortalwrt-packages/net/zerotier feeds/packages/net/zerotier
ln -sf ../../../feeds/packages/net/zerotier ./package/feeds/packages/zerotier
cp -rf immortalwrt-packages/libs/libcron feeds/packages/libs/libcron
ln -sf ../../../feeds/packages/libs/libcron ./package/feeds/packages/libcron
