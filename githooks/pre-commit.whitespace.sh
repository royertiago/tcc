#!/bin/bash
# Script que detecta espaços em branco desnecessários.

git diff --cached --check
if (( $? != 0 )); then
    error=1
fi
