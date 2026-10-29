# platform = multi_platform_sle

FILE="/etc/cron.allow"

# 1. Crear el archivo si no existe
if [ ! -f "$FILE" ]; then
    touch "$FILE"
fi

# 2. Asegurar propietario y grupo root
chown root:root "$FILE"

# 3. Aplicar permisos estrictos 0640
chmod 0640 "$FILE"
