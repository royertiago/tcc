#!/bin/bash
# Script that installs every hook in githooks/ it .git/hooks.

installed_hooks=0

for file in githooks/*; do
    file=${file#githooks/}
    if [[ $file == *.* ]]; then
        # Special exception: if file contains a dot, then it is not a hook.
        # This allows us to spread hooks through several .sh files.
        continue
    fi
    if [ -e ".git/hooks/$file" ]; then
        echo Skipping existing hook \""$file"\".
    else
        ln -s "../../githooks/$file" .git/hooks/
        echo Installed hook \""$file"\" using symlink.
        ((installed_hooks++))
    fi
done

if ((installed_hooks == 0)); then
    echo No hook installed.
fi

exit 0
