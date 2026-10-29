# platform=multi_platform_all

for keyfile in /etc/ssh/*_key; do
    test -f "$keyfile" || continue
    
    # Aplicar estrictamente permisos 0600 (u=rw,g=,o=) sin tocar el propietario/grupo
    chmod 0600 "$keyfile"
done
