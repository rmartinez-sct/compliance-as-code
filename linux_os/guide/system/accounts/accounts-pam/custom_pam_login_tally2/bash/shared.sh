# platform = multi_platform_all

FILE="/etc/pam.d/login"
TALLY_LINE="auth required pam_tally2.so deny=5 onerr=fail unlock_time=900"
UNIX_LINE="auth required pam_unix.so nullok try_first_pass"

# Eliminar cualquier línea anterior de pam_tally2 en auth
sed -i '/^[[:space:]]*auth.*pam_tally2\.so/d' "$FILE"

# Insertar pam_tally2 exactamente debajo de pam_env.so
if grep -q "^[[:space:]]*auth[[:space:]]\+required[[:space:]]\+pam_env\.so" "$FILE"; then
    sed -i "/^[[:space:]]*auth[[:space:]]\+required[[:space:]]\+pam_env\.so/a $TALLY_LINE" "$FILE"
else
    echo "$TALLY_LINE" >> "$FILE"
fi

# Forzar que pam_unix.so sea "required" si ya existe con otro valor
sed -i 's/^[[:space:]]*auth[[:space:]]\+sufficient[[:space:]]\+pam_unix\.so.*/auth required pam_unix.so nullok try_first_pass/' "$FILE"
sed -i 's/^[[:space:]]*auth[[:space:]]\+\[success=1.*pam_unix\.so.*/auth required pam_unix.so nullok try_first_pass/' "$FILE"

# Si pam_unix.so no existe en absoluto, lo añadimos
if ! grep -q "^[[:space:]]*auth.*pam_unix\.so" "$FILE"; then
    echo "$UNIX_LINE" >> "$FILE"
fi
