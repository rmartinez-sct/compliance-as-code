# platform = multi_platform_sle
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

# Same scope as the OVAL check: UID != 0 and interactive shell (not nologin/false).
# No path is excluded. A missing home is created owned by its user with 0750, so the
# rule that requires 0750 or stricter stays compliant. /etc/skel is not copied.
rc=0
while IFS=: read -r user pass uid gid info home shell; do
    case "$uid" in ''|*[!0-9]*) continue ;; esac
    [ "$uid" -eq 0 ] && continue
    [ -n "$home" ] || continue
    case "$shell" in
        *nologin|*false) continue ;;
    esac
    if [ ! -d "$home" ]; then
        install -d -m 0750 -o "$uid" -g "$gid" "$home" || rc=1
    fi
done < /etc/passwd

[ "$rc" -eq 0 ]
