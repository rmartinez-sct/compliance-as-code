# platform = multi_platform_sle
while IFS=: read -r user pass uid gid info home shell; do
    [ "$uid" -eq 0 ] && continue
    case "$home" in
        /|/bin*|/sbin*|/usr*|/dev*|/nonexistent|/var*|/run*|/proc*|/sys*) continue ;;
    esac
    if [ ! -d "$home" ]; then
        mkdir -p "$home" 2>/dev/null
    fi
done < /etc/passwd
