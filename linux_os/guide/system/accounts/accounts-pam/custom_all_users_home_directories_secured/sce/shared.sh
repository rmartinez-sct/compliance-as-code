#!/usr/bin/env bash
# platform = multi_platform_all

FAIL=0

while IFS=: read -r user pass uid gid info home shell; do
    # 1. Omitir a root
    [ "$uid" -eq 0 ] && continue

    # 2. Filtro de seguridad vital: omitir directorios críticos del SO
    case "$home" in
        /|/bin|/sbin|/usr|/usr/bin|/usr/sbin|/dev*|/nonexistent|/var|/var/empty|/run*|/proc|/sys)
            continue
            ;;
    esac

    # 3. Comprobar existencia
    if [ ! -d "$home" ]; then
        echo "FAIL: El home '$home' para el usuario '$user' no existe."
        FAIL=1
        continue
    fi

    # 4. Comprobar Propietario y Grupo
    curr_uid=$(stat -c "%u" "$home" 2>/dev/null)
    curr_gid=$(stat -c "%g" "$home" 2>/dev/null)
    if [ "$curr_uid" != "$uid" ] || [ "$curr_gid" != "$gid" ]; then
        echo "FAIL: Propietario/Grupo incorrecto en '$home'."
        FAIL=1
    fi

    # 5. Comprobar Permisos (máximo permitido 0750)
    curr_perm=$(stat -c "%a" "$home" 2>/dev/null | grep -o '...$')
    perm_group=$(echo "$curr_perm" | cut -c2)
    perm_other=$(echo "$curr_perm" | cut -c3)
    
    if [ -n "$perm_group" ] && [ -n "$perm_other" ]; then
        if [ "$perm_group" -gt 5 ] || [ "$perm_other" -gt 0 ]; then
            echo "FAIL: Permisos demasiado abiertos ($curr_perm) en '$home'."
            FAIL=1
        fi
    fi

done < /etc/passwd

# Retornar estado oficial para OpenSCAP
if [ "$FAIL" -eq 0 ]; then
    exit "${XCCDF_RESULT_PASS:-0}"
else
    exit "${XCCDF_RESULT_FAIL:-1}"
fi
