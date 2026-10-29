# platform = multi_platform_all

while IFS=: read -r user pass uid gid info home shell; do
    # Omitir a root
    [ "$uid" -eq 0 ] && continue

    # Filtro de seguridad vital: omitir directorios críticos del SO
    case "$home" in
        /|/bin|/sbin|/usr|/usr/bin|/usr/sbin|/dev*|/nonexistent|/var|/var/empty|/run*|/proc|/sys)
            continue
            ;;
    esac

    # 1. Crear el directorio si no existe
    if [ ! -d "$home" ]; then
        mkdir -p "$home" 2>/dev/null
    fi

    # 2. Configurar el propietario exacto y su grupo
    chown "$uid:$gid" "$home" 2>/dev/null

    # 3. Restringir permisos (0750 es el estándar estricto CIS)
    chmod 0750 "$home" 2>/dev/null

done < /etc/passwd
