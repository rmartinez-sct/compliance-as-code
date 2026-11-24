# platform = multi_platform_all

# Same scope as the OVAL check: root, plus the interactive users (UID >= UID_MIN, not nobody,
# shell not nologin/false). Each home gets exactly the primary group of its own user.
# Transient errors do not matter: the script succeeds only if every home ends with the right group.
rc=0
while IFS=: read -r user pass uid gid info home shell; do
    case "$uid" in ''|*[!0-9]*) continue ;; esac
    if [ "$uid" -eq 0 ]; then
        :
    elif [ "$uid" -ge {{{ uid_min }}} ] && [ "$uid" -ne {{{ nobody_uid }}} ]; then
        case "$shell" in *nologin|*false) continue ;; esac
    else
        continue
    fi
    [ -n "$home" ] && [ -d "$home" ] || continue
    if [ "$(stat -L -c %g "$home")" != "$gid" ]; then
        chgrp "$gid" "$home" || rc=1
    fi
done < /etc/passwd

[ "$rc" -eq 0 ]
