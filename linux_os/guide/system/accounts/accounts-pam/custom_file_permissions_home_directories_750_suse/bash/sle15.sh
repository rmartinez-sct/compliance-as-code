# platform = multi_platform_sle
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

while IFS=: read -r user pass uid gid info home shell; do
    # Ignorar usuarios excluidos y UID 0
    case "$user" in
        root|halt|sync|shutdown) continue ;;
    esac
    case "$uid" in
        ''|0|*[!0-9]*) continue ;;
    esac

    # Ignorar shells no interactivos
    case "$shell" in
        ''|/usr/sbin/nologin|/usr/bin/false|/sbin/nologin|/bin/false) continue ;;
    esac

    # Quitar barra final si la hubiera (sin vaciar "/")
    home="${home%/}"
    [ -z "$home" ] && continue

    # Validar que el home existe, es un directorio real y no es un enlace simbólico
    if [ -d "$home" ] && [ ! -L "$home" ]; then
        chmod g-w,o-rwx "$home"
    fi
done < /etc/passwd

exit 0
