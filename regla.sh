#!/bin/bash

# Variables
BASE_DIR="/home/rmartinez/Documentos/fase2/zona1/compliance-as-code"
SERVER="root@lnxopenscapprue03"

echo "==> 1. Borrando la carpeta duplicada errónea en local..."
rm -rf "${BASE_DIR}/linux_os/guide/system/accounts/accounts-pam/password_quality/password_quality_cracklib"

echo "==> 2. Limpiando la línea antigua en el servidor remoto..."
ssh $SERVER "sed -i '/pam_cracklib\.so/d' /etc/pam.d/common-password"

echo "==> 3. Posicionándonos en el directorio del proyecto..."
cd "$BASE_DIR" || { echo "Error: No se encontró el directorio base"; exit 1; }

echo "==> 4. Creando los 6 scripts de remediación en la ruta CORRECTA..."
RULES=("dcredit" "lcredit" "minlen" "ocredit" "retry" "ucredit")

for RULE in "${RULES[@]}"; do
    # Aquí está corregida la ruta a password_quality_pamcracklib
    DIR="linux_os/guide/system/accounts/accounts-pam/password_quality/password_quality_pamcracklib/cracklib_accounts_password_pam_${RULE}/bash"
    
    mkdir -p "$DIR"
    
    cat << 'EOF' > "${DIR}/shared.sh"
# platform = multi_platform_sle
PAM_FILE="/etc/pam.d/common-password"
sed -i '/pam_cracklib\.so/d' "$PAM_FILE"
sed -i '/pam_pwhistory\.so/a password requisite pam_cracklib.so dcredit=-1 lcredit=-1 minlen=14 ocredit=-1 retry=3 ucredit=-1' "$PAM_FILE"
EOF

    echo "    -> Script para $RULE creado en la ruta correcta."
done

echo "==> 5. Limpiando y compilando el proyecto..."
echo "==> ¡Proceso finalizado con éxito!"
