#!/usr/bin/env bash

set -e

# The relative paths to each RPM repository.
rpm_path_suffix='CentOS/5/iplant/x86_64'
dev_path="dev/$rpm_path_suffix"
qa_path="qa/$rpm_path_suffix"
stage_path="stage/$rpm_path_suffix"
prod_path="prod/$rpm_path_suffix"

# The base URL for the dev repository on projects.
base_url="http://projects.iplantcollaborative.org/rpms"

get_base_url () {
    echo "$base_url/$1"
}

# Populates a repository.
populate_repo () {
    the_path=$1
    pushd $the_path && shift
    for file in $@; do
        this_base_url=$(get_base_url $the_path)
        wget "$this_base_url/$file"
    done
    createrepo .
    popd
}

# Files that appear in both repositories.
common_files=(
    buggalo-0.0.1-3.x86_64.rpm
    conrad-0.1.0-7.noarch.rpm
    metadactyl-1.2.0-28.noarch.rpm
)

# Files that only appear in the dev repository.
dev_only_files=(
    conrad-1.2.0-50.noarch.rpm
    donkey-1.3.1-69.noarch.rpm
    facepalm-1.1.6-27.noarch.rpm
    metadactyl-1.2.0-39.noarch.rpm
)

# Create the base directory.
mkdir -p ~/yum-repos
cd ~/yum-repos

# Delete and re-create the directories for the repos.
rm -rf $dev_path $qa_path $stage_path $prod_path
mkdir -p $dev_path $qa_path $stage_path $prod_path

# Create the dev repository.
populate_repo $dev_path ${common_files[@]} ${dev_only_files[@]}
populate_repo $qa_path ${common_files[@]}
populate_repo $stage_path ${common_files[@]}
populate_repo $prod_path ${common_files[@]}

