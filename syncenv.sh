#!/usr/bin/env bash
# -*- mode: sh; coding: utf-8; fill-column: 80; -*-
#
# syncenv.sh
# Created by Balakrishnan Chandrasekaran on 2017-12-05 00:33 +0100.
# Copyright (c) 2017 Balakrishnan Chandrasekaran <balakrishnan.c@gmail.com>.
#
# Utility to parse Zsh configuration files and expose the exported environment
#  variables to all applications using `launchctl`.
#
# (Utility is based on https://github.com/ersiner/osx-env-sync)
#

# Evaluate string containing shell variables.
function eval_str() {
    echo $(echo 'echo '$1 | bash)
}

# Retrieve local configuration files.
function get_conf_files() {
    local src="$1"
    local files=()
    local pos=0
    for file in $(grep 'source' $src | grep '/.zsh/' | awk '{print $2}'); do
        files[$pos]=$(eval_str $file)
        let pos=pos+1
    done
    echo ${files[*]}
}

# Retrieve a list of files to search for environment variable exports.
function get_search_list() {
    # List of files.
    local files
    local pos=0

    readonly ZSH_CONF="$HOME/.zshenv"
    # Start with Zsh's configuration file.
    files[pos]="$ZSH_CONF"
    let pos=pos+1

    # Include system-specific configuration.
    readonly SYS=$(get_conf_files ${files[0]})
    files[pos]="$SYS"
    let pos=pos+1

    for file in $(get_conf_files ${files[1]}); do
        files[pos]=$file
        let pos=pos+1
    done

    echo ${files[*]}
}

# Export exported variables to GUI applications using `launchctl`.
function expose_exports() {
    local files="$*"
    for file in $files; do
        grep 'export' $file  | \
            grep -vE '^\s*#' | \
            while IFS=' =' read ignoreexport envvar ignorevalue; do
                launchctl setenv ${envvar} "${!envvar}"
            done
    done
}

expose_exports $(get_search_list)
