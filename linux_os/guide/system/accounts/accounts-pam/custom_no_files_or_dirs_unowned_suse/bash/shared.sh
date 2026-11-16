# platform = multi_platform_all

# -h: actuar sobre el propio enlace simbólico (sin -h, chown cambia el destino
# y el enlace con UID huérfano sigue apareciendo en find -nouser y en el OVAL).
# Las exclusiones coinciden con las del OVAL: no se toca el almacenamiento de
# contenedores, donde los UID huérfanos son normales (user namespaces).
find / \
  \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path '/.snapshots*' \
     -o -path /var/lib/docker -o -path /var/lib/containers -o -path /var/lib/containerd \) -prune -o \
  -nouser -exec chown -h root {} + 2>/dev/null || true
