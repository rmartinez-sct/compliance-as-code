# platform = multi_platform_all

{{{ bash_instantiate_variables("var_accounts_passwords_pam_tally2_unlock_time") }}}

FILE="/etc/pam.d/login"

# Si la línea de pam_tally2 existe pero no tiene unlock_time, se lo añadimos al final con el valor de la variable
if grep -q "^[[:space:]]*auth.*pam_tally2\.so" "$FILE" && ! grep -q "unlock_time=" "$FILE"; then
    sed -i "s/^\([[:space:]]*auth.*pam_tally2\.so.*\)/\1 unlock_time=$var_accounts_passwords_pam_tally2_unlock_time/" "$FILE"
fi

# Si el parámetro existe pero tiene un valor distinto, lo forzamos al valor de la variable
if grep -q "^[[:space:]]*auth.*pam_tally2\.so.*unlock_time=" "$FILE"; then
    sed -i "s/\(unlock_time=\)[0-9]\+/\1$var_accounts_passwords_pam_tally2_unlock_time/" "$FILE"
fi
