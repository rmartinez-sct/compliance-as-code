# platform = multi_platform_all

# Crear el archivo vacío si no existe
if [ ! -f /etc/issue.net ]; then
    touch /etc/issue.net
fi

# Aplicar propietario root:root
chown root:root /etc/issue.net

# Asegurar que los permisos sean correctos (0644)
chmod 0644 /etc/issue.net
