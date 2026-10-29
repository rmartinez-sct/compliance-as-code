# platform = multi_platform_all

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs 2>/dev/null)
[ -z "$UID_MIN" ] && UID_MIN=1000

file_test_fix() {
    local file="$1"
    local exp_perm="$2"
    local exp_user="$3"
    local exp_group="$4"

    # 1. Aplicar permisos (mínimo 0640)
    chmod "$exp_perm" "$file" 2>/dev/null

    # 2. Arreglar Propietario
    curr_user=$(stat -c "%U" "$file" 2>/dev/null)
    if [[ "$exp_user" == *"|"* ]]; then
        if ! echo "$curr_user" | grep -Eq "^($exp_user)$" ; then
            chown "${exp_user%%|*}" "$file" 2>/dev/null
        fi
    else
        if [ "$curr_user" != "$exp_user" ]; then
            chown "$exp_user" "$file" 2>/dev/null
        fi
    fi

    # 3. Arreglar Grupo
    curr_group=$(stat -c "%G" "$file" 2>/dev/null)
    if [[ "$exp_group" == *"|"* ]]; then
        if ! echo "$curr_group" | grep -Eq "^($exp_group)$" ; then
            chgrp "${exp_group%%|*}" "$file" 2>/dev/null
        fi
    else
        if [ "$curr_group" != "$exp_group" ]; then
            chgrp "$exp_group" "$file" 2>/dev/null
        fi
    fi
}

while IFS= read -r -d '' file; do
    bname=$(basename "$file")
    case "$bname" in
        wtmp|btmp|lastlog) file_test_fix "$file" "0640" "root" "root|utmp" ;;
        secure|auth.log|syslog|messages) file_test_fix "$file" "0640" "root|syslog" "root|adm" ;;
        *sssd*) file_test_fix "$file" "0640" "root|sssd" "root|sssd" ;;
        *.journal) file_test_fix "$file" "0640" "root" "root|systemd-journal" ;;
        *)
            curr_uid=$(stat -c "%u" "$file" 2>/dev/null)
            curr_user=$(stat -c "%U" "$file" 2>/dev/null)
            if [ -n "$curr_uid" ] && [ "$curr_uid" -lt "$UID_MIN" ] && [ "$curr_user" != "root" ]; then
                target_user="$curr_user"
            else
                target_user="root"
            fi
            file_test_fix "$file" "0640" "$target_user" "root|adm"
            ;;
    esac
done < <(find /var/log -maxdepth 1 -type f -print0)
