documentation_complete: true

title: 'Perfil CIS / RSI Personalizado (SUSE 15)'

description: |-
    Perfil a medida para SUSE Linux Enterprise 15 con reglas de bastionado 
    nativas y reglas personalizadas (Custom SCE/Bash).

selections:
    # --- VARIABLES OBLIGATORIAS (Valores estándar CIS para evitar errores de compilación) ---
    - var_accounts_tmout=15_min
    - var_sshd_set_keepalive=3
    - sshd_idle_timeout_value=5_minutes
    - var_sshd_set_login_grace_time=60
    - var_password_pam_remember=5
    - var_password_pam_minlen=14
    - var_password_pam_dcredit=1
    - var_password_pam_ucredit=1
    - var_password_pam_ocredit=1
    - var_password_pam_lcredit=1
    - var_password_pam_retry=3
    - var_accounts_maximum_age_login_defs=90
    - var_accounts_minimum_age_login_defs=7
    - var_password_pam_tally2=5
    - var_accounts_passwords_pam_tally2_unlock_time=900

    # --- REGLAS NATIVAS DE SISTEMA Y RED ---
    - mount_option_tmp_nodev
    - mount_option_tmp_noexec
    - mount_option_tmp_nosuid
    - ensure_gpgcheck_globally_activated
    #- enable_gpgcheck_for_all_repositories 
    - custom_ensure_gpgcheck_zypper
    - sysctl_fs_suid_dumpable
    #- service_systemd-coredump_disabled
    - sshd_disable_rhosts_rsa
    - disable_users_coredumps
    - coredump_disable_storage
    - coredump_disable_backtraces
    - bios_enable_execution_restrictions
    #- grub2_enable_apparmor
    - custom_grub2_enable_apparmor
    #- banner_etc_issue
    - custom_banner_etc_issue_rsi
    - custom_banner_etc_issue_net
    - file_owner_etc_issue_net
    - file_groupowner_etc_issue_net
    - file_permissions_etc_issue_net
    
    # --- REGLAS NATIVAS DE PAQUETES ELIMINADOS ---
    - package_vsftpd_removed
    - package_httpd_removed
    - package_samba_removed
    - package_net-snmp_removed
    #- package_xorg-x11-server-Xwayland_removed
    #- package_xorg-x11-server-common_removed
    - custom_xorg_x11_server_removed
    - package_dhcp_removed
    - package_ypbind_removed
    
    # --- REGLAS NATIVAS DE RED Y FIREWALL (SYSCTL) ---
    - sysctl_net_ipv4_conf_default_send_redirects
    - sysctl_net_ipv4_conf_all_send_redirects
    - sysctl_net_ipv4_conf_default_secure_redirects
    - sysctl_net_ipv4_conf_all_secure_redirects
    - sysctl_net_ipv4_conf_all_log_martians
    - sysctl_net_ipv4_conf_default_log_martians
    - sysctl_net_ipv4_conf_all_rp_filter
    - sysctl_net_ipv4_conf_default_rp_filter
    #- firewalld_loopback_traffic_trusted
    - rsyslog_remote_loghost
    
    # --- REGLAS NATIVAS DE TAREAS PROGRAMADAS (CRON) ---
    - file_groupowner_cron_hourly
    - file_owner_cron_hourly
    - file_permissions_cron_hourly
    - file_permissions_cron_weekly
    - file_groupowner_cron_weekly
    - file_owner_cron_weekly
    - file_permissions_cron_monthly
    - file_groupowner_cron_monthly
    - file_owner_cron_monthly
    #- file_permissions_cron_allow
    #- custom_cron_allow_exists_and_perms
    #- file_groupowner_cron_allow
    #- file_owner_cron_allow
    #- custom_cron_allow_exists_and_owne
    #- file_cron_allow_exists
    - file_cron_deny_not_exist
    - custom_cron_allow_strict_suse
    
    # --- REGLAS NATIVAS DE SSH Y CONTRASEÑAS ---
    - file_permissions_sshd_config
    - file_groupowner_sshd_config
    - file_owner_sshd_config
    - sshd_use_strong_ciphers
    #- sshd_use_strong_kex
    - custom_sshd_use_strong_kex
    - sshd_set_idle_timeout
    - custom_sshd_set_keepalive_max
    - sshd_set_login_grace_time
    #- sshd_limit_user_access
    - cracklib_accounts_password_pam_dcredit
    - cracklib_accounts_password_pam_lcredit
    - cracklib_accounts_password_pam_minlen
    - cracklib_accounts_password_pam_ocredit
    - cracklib_accounts_password_pam_retry
    - cracklib_accounts_password_pam_ucredit
    
    # --- REGLAS NATIVAS DE CUENTAS DE USUARIO (PAM Y SHADOW) ---
    #- accounts_passwords_pam_tally2
    - custom_accounts_passwords_pam_tally2_suse
    #- accounts_passwords_pam_tally2_unlock_time
    - custom_pam_tally2_unlock_time_suse
    #- accounts_passwords_pam_tally2_deny_root
    - custom_accounts_passwords_pam_tally2_deny_users
    - custom_pam_login_tally2
    - custom_pam_common_account_tally2
    - accounts_password_pam_pwhistory_enabled
    - accounts_password_pam_pwhistory_remember
    - accounts_maximum_age_login_defs
    - accounts_password_set_max_life_existing
    - accounts_minimum_age_login_defs
    - accounts_password_all_shadowed
    - no_password_auth_for_systemaccounts
    #- no_duplicate_uids
    - custom_no_duplicate_uids_suse
    - ensure_shadow_group_empty
    - accounts_no_uid_except_zero
    #- accounts_user_dot_no_world_writable_programs
    - custom_user_dot_files_no_group_other_write

    # --- REGLAS CUSTOM (Las que hemos creado desde cero) ---
    - custom_perms_var_log_login
    #- custom_perms_var_log_apps
    - custom_perms_var_log_apps_suse
    - custom_perms_var_log_general
    #- custom_var_log_security_recursive
    - custom_var_log_security_recursive_suse
    - custom_accounts_tmout
    #- custom_no_files_or_dirs_ungroupowned
    - custom_no_files_or_dirs_ungroupowned_suse
    #- custom_no_files_or_dirs_unowned
    - custom_no_files_or_dirs_unowned_suse
    #- custom_all_users_home_directories_secured
    #-  custom_all_users_home_directories_secured_suse
    - custom_home_directory_exists_suse
    - custom_file_permissions_home_directories_750_suse
    - custom_file_ownership_home_directories_suse
    - custom_sshd_disable_rsa_authentication
