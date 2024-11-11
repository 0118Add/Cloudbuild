#!/bin/bash
# mihomo
if curl -s "https://$mirror/openwrt/24-config-common" | grep -q "^CONFIG_PACKAGE_luci-app-mihomo=y"; then
git clone https://$github/morytyann/OpenWrt-mihomo  package/new/openwrt-mihomo
mkdir -p files/etc/mihomo/run/ui
curl -Lso files/etc/mihomo/run/Country.mmdb https://$github/NobyDa/geoip/raw/release/Private-GeoIP-CN.mmdb
curl -Lso files/etc/mihomo/run/GeoIP.dat https://$github/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.dat
curl -Lso files/etc/mihomo/run/GeoSite.dat https://$github/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
curl -Lso metacubexd-gh-pages.tar.gz https://$github/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.tar.gz
tar zxf metacubexd-gh-pages.tar.gz
mv metacubexd-gh-pages files/etc/mihomo/run/ui/metacubexd
fi

# sysupgrade keep files
echo "/etc/hotplug.d/iface/*.sh" >> files/etc/sysupgrade.conf
echo "/etc/init.d/beszel-agent" >> files/etc/sysupgrade.conf

# add UE-DDNS
curl -skLo ue-ddns.sh ddns.03k.org
chmod +x ue-ddns.sh
mkdir -p files/usr/bin
mv ue-ddns.sh files/usr/bin/ue-ddns

# from pmkol/openwrt-plus
# comment out the following line to restore the full description
sed -i '/# timezone/i grep -q '\''/tmp/sysinfo/model'\'' /etc/rc.local || sudo sed -i '\''/exit 0/i [ "$(cat /sys\\/class\\/dmi\\/id\\/sys_vendor 2>\\/dev\\/null)" = "Default string" ] \&\& echo "x86_64" > \\/tmp\\/sysinfo\\/model'\'' /etc/rc.local\n' package/new/default-settings/default/zzz-default-settings
sed -i '/# timezone/i sed -i "s/\\(DISTRIB_DESCRIPTION=\\).*/\\1'\''OpenWrt $(sed -n "s/DISTRIB_DESCRIPTION='\''OpenWrt \\([^ ]*\\) .*/\\1/p" /etc/openwrt_release)'\'',/" /etc/openwrt_release\nsource /etc/openwrt_release \&\& sed -i -e "s/distversion\\s=\\s\\".*\\"/distversion = \\"$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_REVISION)\\"/g" -e '\''s/distname    = .*$/distname    = ""/g'\'' /usr/lib/lua/luci/version.lua\nsed -i "s/luciname    = \\".*\\"/luciname    = \\"LuCI Master\\"/g" /usr/lib/lua/luci/version.lua\nsed -i "s/luciversion = \\".*\\"/luciversion = \\"v'$(date +%Y%m%d)'\\"/g" /usr/lib/lua/luci/version.lua\necho "export const revision = '\''v'$(date +%Y%m%d)'\'\'', branch = '\''LuCI Master'\'';" > /usr/share/ucode/luci/version.uc\n/etc/init.d/rpcd restart\n' package/new/default-settings/default/zzz-default-settings
curl -fsSL https://raw.githubusercontent.com/0118Add/Cloudbuild/main/patches/os-release > package/base-files/files/etc/os-release
