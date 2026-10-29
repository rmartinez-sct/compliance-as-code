# platform = multi_platform_all

FILE="/etc/pam.d/common-account"
LINE="account required pam_tally2.so"

# Eliminar entradas previas de account pam_tally2 para evitar conflictos
sed -i '/^[[:space:]]*account.*pam_tally2\.so/d' "$FILE"

# Añadir la línea configurada
echo "$LINE" >> "$FILE"
