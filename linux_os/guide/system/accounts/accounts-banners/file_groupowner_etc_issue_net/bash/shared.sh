# platform = multi_platform_all

if [ ! -f /etc/issue.net ]; then
    touch /etc/issue.net
fi

chgrp root /etc/issue.net
chmod 0644 /etc/issue.net
