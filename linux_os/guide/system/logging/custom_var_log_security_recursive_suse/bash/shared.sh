# platform = multi_platform_sle

# 1. Aplicamos explícitamente 0740 a los directorios del primer nivel
find /var/log -maxdepth 1 -mindepth 1 -type d -exec chmod 0750 {} + 2>/dev/null || true

# 2. Aplicamos explícitamente 0640 a los archivos del primer nivel
find /var/log -maxdepth 1 -mindepth 1 -type f -exec chmod 0640 {} + 2>/dev/null || true
