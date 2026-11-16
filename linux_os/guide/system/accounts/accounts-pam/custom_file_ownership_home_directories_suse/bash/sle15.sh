# platform = multi_platform_sle
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# Same scope as the OVAL check: UID != 0 and interactive shell (not nologin/false).
# Homes in /, /bin, /sbin, /usr, /dev, /proc and /sys are never touched: /bin and /sbin are links
# to /usr/bin and /usr/sbin, and a chown there would hand system directories to a regular account.
# Only the owner is changed (each home gets exactly its own user); the group is left as it is.
rc=0
while IFS=: read -r user pass uid gid info home shell; do
    case "$uid" in ''|*[!0-9]*) continue ;; esac
    [ "$uid" -eq 0 ] && continue
    [ -n "$home" ] || continue
    case "$home" in
        /|/bin|/bin/*|/sbin|/sbin/*|/usr|/usr/*|/dev|/dev/*|/proc|/proc/*|/sys|/sys/*) continue ;;
    esac
    case "$shell" in
        *nologin|*false) continue ;;
    esac
    if [ -d "$home" ] && [ "$(stat -c %u "$home")" != "$uid" ]; then
        chown "$uid" "$home" || rc=1
    fi
done < /etc/passwd

[ "$rc" -eq 0 ]
