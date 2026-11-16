# platform = multi_platform_all

# Busca cualquier archivo oculto dentro de /home que tenga permisos de escritura de grupo o de otros, y se los quita
find /home -type f -name ".*" \( -perm -0020 -o -perm -0002 \) -exec chmod go-w {} + 2>/dev/null
