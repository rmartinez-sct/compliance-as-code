documentation_complete: true

title: 'Perfil CIS RSI Personalizado para RHEL 9'

description: |-
    Perfil de bastionado para RHEL 9 que incluye remediaciones personalizadas
    para evitar el uso de authselect en archivos PAM modificados manualmente.

selections:
    # Puntos de montaje
    - mount_option_tmp_nodev
    - mount_option_tmp_nosuid
    - mount_option_tmp_noexec

    # Kernel y red
    - sysctl_kernel_randomize_va_space
    - sysctl_net_ipv4_tcp_syncookies
    - sysctl_net_ipv4_icmp_ignore_bogus_error_responses
    - sysctl_net_ipv4_conf_all_secure_redirects
    - sysctl_net_ipv4_conf_default_secure_redirects
    - sysctl_net_ipv4_conf_default_log_martians
    - sysctl_net_ipv4_conf_all_log_martians

    # SSH y Banners
    #- sshd_use_strong_ciphers
    - custom_sshd_ciphers
    #- harden_sshd_ciphers_openssh_conf_crypto_policy
    #- configure_crypto_policy
    - custom_crypto_policy_no_chacha
    # - var_system_crypto_policy=default
    #- banner_etc_issue_net
    - custom_banner_etc_issue_net
    - file_ownership_sshd_private_key
    #- file_groupownership_sshd_private_key
    - custom_file_groupowner_sshd_private_key
    #- file_permissions_sshd_private_key
    - custom_file_permissions_sshd_private_key

    # Tareas programadas (Cron)
    - file_permissions_crontab
    - file_groupowner_crontab
    - file_owner_crontab
    - file_groupowner_cron_hourly
    - file_owner_cron_hourly
    - file_permissions_cron_hourly
    - file_permissions_cron_weekly
    - file_groupowner_cron_weekly
    - file_owner_cron_weekly
    - file_permissions_cron_monthly
    - file_groupowner_cron_monthly
    - file_owner_cron_monthly

    # Autenticación, contraseñas y PAM (Reglas Personalizadas incluidas)
    - custom_accounts_passwords_pam_faillock_deny
    - var_accounts_passwords_pam_faillock_deny=5
    - custom_accounts_passwords_pam_faillock_unlock_time
    - var_accounts_passwords_pam_faillock_unlock_time=900
    - custom_accounts_password_pam_clean_pwquality_args
    - custom_accounts_password_pam_minlen
    - var_password_pam_minlen=14
    - accounts_password_pam_minclass
    - var_password_pam_minclass=4
    - accounts_password_pam_dcredit
    - var_password_pam_dcredit=1
    - accounts_password_pam_lcredit
    - var_password_pam_lcredit=1
    - accounts_password_pam_ocredit
    - var_password_pam_ocredit=1
    - accounts_password_pam_ucredit
    - var_password_pam_ucredit=1
    - accounts_password_pam_enforce_root
    - accounts_maximum_age_login_defs
    - accounts_password_set_max_life_existing
    - var_accounts_maximum_age_login_defs=90
    - accounts_password_all_shadowed

    # Sesiones y Cuentas de Sistema
    - no_shelllogin_for_systemaccounts
    #- accounts_tmouit
    - custom_accounts_tmout
    - var_accounts_tmout=15_min

    # Logs y Auditoría
    #- rsyslog_logging_configured
    - rsyslog_remote_loghost
    - custom_rsyslog_logging_configured
    #- file_permissions_var_log
    - custom_perms_var_log_login
    - custom_perms_var_log_apps
    - custom_perms_var_log_general
    #- custom_file_owner_var_log_recursive
    #- file_groupowner_var_log
    #- custom_file_groupowner_var_log_recursive
    #- custom_var_log_security_recursive
    - custom_var_log_security_non_recursive

    # Permisos Generales y Directorios Home
    #- no_files_or_dirs_ungroupowned
    #- no_files_or_dirs_unowned_by_user
    - custom_no_files_or_dirs_ungroupowned
    - custom_no_files_or_dirs_unowned
    #- file_ownership_home_directories
    - custom_file_ownership_home_directories
    - custom_file_groupownership_home_directories
    - custom_file_permissions_root_home
    - file_permissions_home_directories
    - accounts_user_interactive_home_directory_exists
    - no_shelllogin_for_systemaccounts
