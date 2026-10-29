# platform = multi_platform_all

if command -v zypper >/dev/null 2>&1; then
    zypper remove -y "xorg-x11-server*"
elif command -v dnf >/dev/null 2>&1; then
    dnf remove -y "xorg-x11-server*"
elif command -v yum >/dev/null 2>&1; then
    yum remove -y "xorg-x11-server*"
fi
