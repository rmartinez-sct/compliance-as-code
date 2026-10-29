# platform = multi_platform_all

# Crear el archivo vacío si no existe
if [ ! -f /etc/issue.net ]; then
    touch /etc/issue.net
fi

# Asegurar que los permisos sean correctos (0644)
chmod 0644 /etc/issue.net
