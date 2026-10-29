# platform = multi_platform_sle

local_mounts=$(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | awk '{ print $1 }')

for mountpoint in $local_mounts; do
    find "$mountpoint" -xdev -nouser -exec chown root {} + 2>/dev/null
done
