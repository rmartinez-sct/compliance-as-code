# platform = multi_platform_all

FILE="/etc/cron.allow"

# 1. Crear el archivo si no existe
if [ ! -f "$FILE" ]; then
    touch "$FILE"
fi

# 2. Asegurar que el propietario es root
chown root "$FILE"
