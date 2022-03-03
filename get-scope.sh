#!/bin/bash

[[ -z $1 ]] && echo "./get-scope.sh [domain_name]" && exit

grep host $1 | awk -F '\"' -F '^' '{ print $2 }' | cut -d "$" -f 1
