FROM scratch
ADD immortalwrt-armsr-armv8-generic-rootfs.tar.gz /
EXPOSE 22 53 80 443 7681
# using exec format so that /sbin/init is proc 1 (see procd docs)
ENTRYPOINT ["/sbin/init"]
