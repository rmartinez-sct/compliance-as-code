# platform = multi_platform_sle
# reboot = false
# strategy = restrict
# complexity = low
# disruption = medium

# Fix: local file systems, without crossing mount points.
# Transient errors (files that vanish while find walks the tree) are ignored;
# success is decided by the verification below, not by the exit code of find/chown.
df --local --output=target | tail -n +2 | while IFS= read -r mount_point; do
    find "$mount_point" -xdev \( -nouser -o -nogroup \) -exec chown -h root:root {} + 2>/dev/null
done

remaining=$(df --local --output=target | tail -n +2 | while IFS= read -r mount_point; do
    find "$mount_point" -xdev \( -nouser -o -nogroup \) 2>/dev/null
done)

[ -z "$remaining" ]
