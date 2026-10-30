# platform = multi_platform_sle

# 1. Insertamos apparmor=1 si no existe en GRUB_CMDLINE_LINUX_DEFAULT
if ! grep -q 'apparmor=1' /etc/default/grub; then
    sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 apparmor=1"/' /etc/default/grub
fi

# 2. Insertamos security=apparmor si no existe en GRUB_CMDLINE_LINUX_DEFAULT
if ! grep -q 'security=apparmor' /etc/default/grub; then
    sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 security=apparmor"/' /etc/default/grub
fi

# 3. Regeneramos la configuración del grub
grub2-mkconfig -o /boot/grub2/grub.cfg
