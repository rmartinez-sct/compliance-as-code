# platform = multi_platform_all

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs 2>/dev/null)
[ -z "$UID_MIN" ] && UID_MIN=1000

while IFS=: read -r user pass uid gid info home shell; do
    # Filtrar solo usuarios interactivos (UID >= UID_MIN, ignorar nobody y cuentas sin shell)
    if [ "$uid" -ge "$UID_MIN" ] && [ "$uid" -ne 65534 ] && [ "$shell" != "/sbin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        if [ -d "$home" ]; then
            find "$home" -maxdepth 1 -type f -name ".*" -exec chmod go-w {} + 2>/dev/null
        fi
    fi
done < /etc/passwd
