# platform = multi_platform_sle

# Busca recursivamente todos los archivos en /var/log y elimina exactamente los
# permisos que prohíbe el OVAL, manteniendo intactos los propietarios.
find /var/log -type f -exec chmod u-xs,g-wxs,o-rwx,a-t {} + 2>/dev/null || true
