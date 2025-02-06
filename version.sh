#!/bin/bash

function short_version() {
    my_version=$(
        {
            ${1} --version 2> /dev/null || echo "-bash: ${1}: command not found"
        } | head -n 1
    )
    echo $my_version
}

prettyname=$(grep "PRETTY_NAME" /etc/os-release | sed 's/PRETTY_NAME=//')

cat << EOF

Detected operating system: 
    ${prettyname:1: -1}

EOF

for my_command in "$@" ; do
    cat << EOF
$ ${my_command} --version | head -n 1
$(short_version $my_command)

EOF

done
