# platform = multi_platform_sle

find /var/log -regextype posix-extended -type f -regex '^/var/log/(chrony/.*|cups/.*|httpd/.*|samba/.*|nginx/.*|zypper.*|hawkey.*|tuned/.*|rhsm/.*|qemu-ga/.*)$' -exec chmod 0640 {} + 2>/dev/null
