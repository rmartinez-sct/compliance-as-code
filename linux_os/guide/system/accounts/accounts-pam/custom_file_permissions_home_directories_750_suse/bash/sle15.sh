# platform = multi_platform_sle
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# Only the bits forbidden by 0750 are removed (group write, any access for others),
# so a directory that is already stricter (0700, 0710...) is never loosened.

# 1. Homes listed in /etc/passwd: UID != 0 and interactive shell (not nologin/false).
#    No path is excluded.
while IFS=: read -r user pass uid gid info home shell; do
    case "$uid" in ''|*[!0-9]*) continue ;; esac
    [ "$uid" -eq 0 ] && continue
    [ -n "$home" ] || continue
    case "$shell" in
        *nologin|*false) continue ;;
    esac
    if [ -d "$home" ]; then
        chmod g-w,o-rwx "$home"
    fi
done < /etc/passwd

# 2. Every directory directly under /home, including users that exist only in the
#    directory service (not in /etc/passwd).
for home in /home/*/; do
    home="${home%/}"
    [ -d "$home" ] || continue
    chmod g-w,o-rwx "$home"
done
