# platform = multi_platform_sle

{{{ bash_instantiate_variables("sshd_idle_timeout_value") }}}

if grep -q -i '^[[:space:]]*ClientAliveInterval' /etc/ssh/sshd_config; then
    sed -i "s/^[[:space:]]*ClientAliveInterval.*/ClientAliveInterval $sshd_idle_timeout_value/I" /etc/ssh/sshd_config
else
    echo "ClientAliveInterval $sshd_idle_timeout_value" >> /etc/ssh/sshd_config
fi
