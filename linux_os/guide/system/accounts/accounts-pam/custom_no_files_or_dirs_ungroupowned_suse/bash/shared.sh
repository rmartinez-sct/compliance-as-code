# platform = multi_platform_all

# -h: actuar sobre el propio enlace simbólico (sin -h, chgrp cambia el destino
# y el enlace con GID huérfano sigue apareciendo en find -nogroup y en el OVAL)
find / \
  \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path '/.snapshots*' \) -prune -o \
  -nogroup -exec chgrp -h root {} + 2>/dev/null || true
