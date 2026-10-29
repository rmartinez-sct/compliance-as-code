# platform = multi_platform_sle

PAM_FILE="/etc/pam.d/common-password"

sed -i '/pam_pwhistory\.so/d' "$PAM_FILE"
sed -i '/password[[:space:]]\+sufficient[[:space:]]\+pam_unix\.so/i password requisite pam_pwhistory.so remember=5 use_authtok enforce_for_root' "$PAM_FILE"
