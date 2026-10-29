#!/usr/bin/env bash
# platform = multi_platform_all

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs 2>/dev/null)
[ -z "$UID_MIN" ] && UID_MIN=1000
FAIL=0

check_file() {
    local file="$1"
    local exp_perm="$2"
    local exp_user="$3"
    local exp_group="$4"

    curr_perm=$(stat -c "%a" "$file" 2>/dev/null)
    curr_user=$(stat -c "%U" "$file" 2>/dev/null)
    curr_group=$(stat -c "%G" "$file" 2>/dev/null)

    # 1. Validar Permisos (mínimo 640)
    if [[ "$exp_perm" != *"$curr_perm" ]]; then
        echo "FAIL Permisos: '$file' (Actual: $curr_perm, Esperado: $exp_perm)"
        FAIL=1
    fi

    # 2. Validar Propietario
    if [[ "$exp_user" == *"|"* ]]; then
        if ! echo "$curr_user" | grep -Eq "^($exp_user)$" ; then
            echo "FAIL Usuario: '$file' (Actual: $curr_user, Esperados: $exp_user)"
            FAIL=1
        fi
    else
        if [ "$curr_user" != "$exp_user" ]; then
            echo "FAIL Usuario: '$file' (Actual: $curr_user, Esperado: $exp_user)"
            FAIL=1
        fi
    fi

    # 3. Validar Grupo
    if [[ "$exp_group" == *"|"* ]]; then
        if ! echo "$curr_group" | grep -Eq "^($exp_group)$" ; then
            echo "FAIL Grupo: '$file' (Actual: $curr_group, Esperados: $exp_group)"
            FAIL=1
        fi
    else
        if [ "$curr_group" != "$exp_group" ]; then
            echo "FAIL Grupo: '$file' (Actual: $curr_group, Esperado: $exp_group)"
            FAIL=1
        fi
    fi
}

while IFS= read -r -d '' file; do
    bname=$(basename "$file")
    case "$bname" in
        wtmp|btmp|lastlog) check_file "$file" "640" "root" "root|utmp" ;;
        secure|auth.log|syslog) check_file "$file" "640" "root|syslog" "root|adm" ;;
        *sssd*) check_file "$file" "640" "root|sssd" "root|sssd" ;;
        *.journal) check_file "$file" "640" "root" "root|systemd-journal" ;;
        *)
            curr_uid=$(stat -c "%u" "$file" 2>/dev/null)
            curr_user=$(stat -c "%U" "$file" 2>/dev/null)
            if [ -n "$curr_uid" ] && [ "$curr_uid" -lt "$UID_MIN" ] && [ "$curr_user" != "root" ]; then
                target_user="$curr_user"
            else
                target_user="root"
            fi
            check_file "$file" "640" "$target_user" "root|adm"
            ;;
    esac
done < <(find /var/log -type f -print0)

if [ "$FAIL" -eq 0 ]; then
    exit "${XCCDF_RESULT_PASS:-0}"
else
    exit "${XCCDF_RESULT_FAIL:-1}"
fi
