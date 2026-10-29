# platform = multi_platform_all
set -e

CUSTOM_FILE="/etc/rsyslog.d/99-cis-custom-logging.conf"

mkdir -p /etc/rsyslog.d

SELECTORS=(
    "mail.err"
    "local6,local7.*"
    "auth,authpriv.*"
    "local2,local3.*"
    "*.=warning;*.=err"
    "*.emerg"
    "mail.info"
    "mail.*"
    "*.crit"
    "cron.*"
    "mail.warning"
    "*.*;mail.none;news.none"
    "local4,local5.*"
    "local0,local1.*"
)

PATTERN=""
for selector in "${SELECTORS[@]}"; do
    escaped=$(printf '%s' "$selector" | sed 's/[][\\.^$*+?(){}|]/\\&/g')
    if [ -n "$PATTERN" ]; then
        PATTERN="${PATTERN}|"
    fi
    PATTERN="${PATTERN}${escaped}"
done

shopt -s nullglob
FILES=(/etc/rsyslog.conf /etc/rsyslog.d/*.conf)

for file in "${FILES[@]}"; do
    [ "$file" = "$CUSTOM_FILE" ] && continue
    [ -f "$file" ] || continue

    cp -a "$file" "${file}.bak"

    sed -E -i \
        "/^[[:space:]]*(${PATTERN})([[:space:]]|$)/s/^([[:space:]]*)/\1# OpenSCAP: /" \
        "$file"
done

cat > "$CUSTOM_FILE" <<'EOF'
mail.err                                /var/log/mail.err
local6,local7.*                         -/var/log/localmessages
auth,authpriv.*                         /var/log/secure
local2,local3.*                         -/var/log/localmessages
*.=warning;*.=err                       -/var/log/warn
*.emerg                                 :omusrmsg:*
mail.info                               -/var/log/mail.info
mail.*                                  -/var/log/mail
*.crit                                  /var/log/warn
cron.*                                  /var/log/cron
mail.warning                            -/var/log/mail.warn
*.*;mail.none;news.none                 -/var/log/messages
local4,local5.*                         -/var/log/localmessages
local0,local1.*                         -/var/log/localmessages
EOF

rsyslogd -N1

systemctl restart rsyslog
