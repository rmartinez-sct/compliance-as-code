# platform = multi_platform_sle
# reboot = false
# strategy = configure
# complexity = low
# disruption = medium

move_pam_before() {
    local file="$1"
    local ptype="$2"
    local mod_regex="$3"
    local anchor_regex="$4"

    [ -f "$file" ] || return 0
    local target
    target=$(readlink -f "$file")

    local mod_line
    mod_line=$(grep -E "^[[:space:]]*${ptype}[[:space:]]+.*${mod_regex}" "$target" | head -n 1)
    [ -n "$mod_line" ] || return 0

    grep -qE "^[[:space:]]*${ptype}[[:space:]]+.*${anchor_regex}" "$target" || return 0

    local tmpfile
    tmpfile=$(mktemp)
    awk -v ptype="$ptype" -v mod="$mod_regex" -v anchor="$anchor_regex" -v line="$mod_line" '
        BEGIN { inserted = 0 }
        $0 ~ "^[[:space:]]*" ptype "[[:space:]]+.*" mod { next }
        !inserted && $0 ~ "^[[:space:]]*" ptype "[[:space:]]+.*" anchor {
            print line
            inserted = 1
        }
        { print }
    ' "$target" > "$tmpfile" && cat "$tmpfile" > "$target"
    rm -f "$tmpfile"
}

# 1. common-password: pam_cracklib.so -> pam_pwhistory.so -> pam_unix.so
move_pam_before "/etc/pam.d/common-password" "password" "pam_cracklib\.so" "pam_unix\.so"
move_pam_before "/etc/pam.d/common-password" "password" "pam_pwhistory\.so" "pam_unix\.so"

# 2. login: pam_tally2.so -> common-auth / pam_unix.so
move_pam_before "/etc/pam.d/login" "auth" "pam_tally2\.so" "(common-auth|pam_unix\.so)"

# 3. common-account: pam_tally2.so -> pam_unix.so
move_pam_before "/etc/pam.d/common-account" "account" "pam_tally2\.so" "pam_unix\.so"

exit 0
