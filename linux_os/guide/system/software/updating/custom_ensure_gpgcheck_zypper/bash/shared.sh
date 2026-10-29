# platform = multi_platform_sle

function replace_all_gpgcheck {
    sed -i 's/gpgcheck\s*=.*/gpgcheck=1/g' /etc/zypp/repos.d/*.repo 2>/dev/null
}

function add_gpgcheck_where_missing {
    for repofile in /etc/zypp/repos.d/*.repo ; do
        [ -e "$repofile" ] || continue
        
        declare -a sections_without_gpgcheck
        section="false"
        section_has_gpgcheck="false"
        section_name=""
        while IFS= read -r line; do
            if grep -qP '^\[.*\]$' <( echo "$line" ) ; then
                if [[ "$section" == "true" ]] && [[ "$section_has_gpgcheck" == "false" ]] ; then
                    sections_without_gpgcheck+=("$section_name")
                    section="false"
                fi
                section="true"
                section_has_gpgcheck="false"
                section_name=$(echo "$line" | sed -n 's/^\[\(.*\)\]$/\1/p')
            fi
            if grep -qP '^\s*gpgcheck\s*=\s*' <( echo "$line" ) ; then
                section_has_gpgcheck="true"
            fi
        done < "$repofile"
        if [[ "$section" == "true" ]] && [[ "$section_has_gpgcheck" == "false" ]] ; then
            sections_without_gpgcheck+=("$section_name")
            section="false"
        fi

        for x in "${sections_without_gpgcheck[@]}" ; do
            sed -i "s/^\[$x\]/&\ngpgcheck=1/" "$repofile"
        done
    done
}

replace_all_gpgcheck
add_gpgcheck_where_missing
