#!/bin/bash

_prj() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmds="edit help list types"

    case $prev in
        prj | help)
            COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
            return 0
            ;;
        edit | types)
            types=$(prj types)
            COMPREPLY=( $(compgen -W "${types}" -- ${cur}) )
            ;;
        *)
            # Test if we're editing a type
            if [ "${COMP_WORDS[COMP_CWORD-2]}" = 'edit' ]; then
                files=$(prj list ${prev})
                COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
            fi
            ;;
    esac
}
complete -F _prj prj

