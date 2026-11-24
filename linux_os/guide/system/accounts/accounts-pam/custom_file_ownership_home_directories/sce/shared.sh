#!/bin/bash
# platform = multi_platform_all
# check-import = stdout

# Interactive users: UID >= UID_MIN, not nobody, shell not nologin/false; plus root.
# Each home must be owned by ITS OWN user. Every offending home is printed, so it shows up
# in the report. Same scope as the remediation.
uid_min={{{ uid_min }}}
nobody_uid={{{ nobody_uid }}}
bad=0

while IFS=: read -r user pass uid gid info home shell; do
    case "$uid" in ''|*[!0-9]*) continue ;; esac
    if [ "$uid" -eq 0 ]; then
        :
    elif [ "$uid" -ge "$uid_min" ] && [ "$uid" -ne "$nobody_uid" ]; then
        case "$shell" in *nologin|*false) continue ;; esac
    else
        continue
    fi
    [ -n "$home" ] && [ -d "$home" ] || continue
    current=$(stat -L -c %u "$home")
    if [ "$current" != "$uid" ]; then
        echo "$home: owner $(stat -L -c %U "$home") (uid $current), expected $user (uid $uid)"
        bad=1
    fi
done < /etc/passwd

if [ "$bad" -eq 0 ]; then
    exit "$XCCDF_RESULT_PASS"
fi
exit "$XCCDF_RESULT_FAIL"
