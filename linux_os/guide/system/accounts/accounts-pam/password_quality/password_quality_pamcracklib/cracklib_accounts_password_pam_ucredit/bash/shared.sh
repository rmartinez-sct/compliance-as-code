# platform = multi_platform_sle
PAM_FILE="/etc/pam.d/common-password"
sed -i '/pam_cracklib\.so/d' "$PAM_FILE"
sed -i '/pam_pwhistory\.so/a password requisite pam_cracklib.so dcredit=-1 lcredit=-1 minlen=14 ocredit=-1 retry=3 ucredit=-1' "$PAM_FILE"
