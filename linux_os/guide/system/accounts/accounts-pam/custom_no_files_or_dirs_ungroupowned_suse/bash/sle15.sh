# platform = multi_platform_sle

# Obtener los puntos de montaje de sistemas de archivos locales
local_mounts=$(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | awk '{ print $1 }')

# Buscar archivos/directorios sin grupo en esos puntos de montaje y asignarles 'root'
for mountpoint in $local_mounts; do
    find "$mountpoint" -xdev -nogroup -exec chgrp root {} + 2>/dev/null
done
