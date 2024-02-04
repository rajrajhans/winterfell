#!/bin/bash
############################
# Symlinks all the dotfiles to ~/
############################

declare -a FILES_TO_SYMLINK=(
    'bashrc'
    'gitconfig'
    'gitignore',
    'inputrc'
)

execute() {
    $1 &>/dev/null
    print_result $? "${2:-$1}"
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_result() {
    [ $1 -eq 0 ] &&
        print_success "$2" ||
        print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] &&
        exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

main() {
    local i=''
    local sourceFile=''
    local targetFile=''

    for i in ${FILES_TO_SYMLINK[@]}; do
        sourceFile="$(pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ ! -e "$targetFile" ]; then
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else
            rm -rf "$targetFile"
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        fi

    done

    unset FILES_TO_SYMLINK

}

main
