# platform = multi_platform_all

# Crear el archivo si no existe
if [ ! -f /etc/issue.net ]; then
    touch /etc/issue.net
fi

# Aplicar propietario root de forma segura
chown root:root /etc/issue.net

# Asegurar que los permisos sean los correctos para un banner de sistema
chmod 0644 /etc/issue.net
