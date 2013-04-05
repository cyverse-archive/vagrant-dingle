#!/usr/bin/env bash

set -e

# The relative paths to each RPM repository.
rpm_path_suffix='CentOS/5/iplant/x86_64'
dev_path="dev/$rpm_path_suffix"
qa_path="qa/$rpm_path_suffix"

# The base URL for the dev repository on projects.
dev_base_url="http://projects.iplantcollaborative.org/rpms/$dev_path"

# Populates a repository.
populate_repo () {
    pushd $1 && shift
    for file in $@; do
        wget -q "$dev_base_url/$file"
    done
    createrepo .
    popd
}

# Files that appear in both repositories.
common_files=(
    buggalo-0.0.1-1.x86_64.rpm
    conrad-0.1.0-1.noarch.rpm
    donkey-1.3.1-68.noarch.rpm
    facepalm-1.1.4-21.noarch.rpm
    metadactyl-1.2.0-38.noarch.rpm
)

# Files that only appear in the dev repository.
dev_only_files=(
    buggalo-0.0.1-2.x86_64.rpm
    conrad-0.1.0-2.noarch.rpm
    donkey-1.3.1-69.noarch.rpm
    facepalm-1.1.6-27.noarch.rpm
    metadactyl-1.2.0-39.noarch.rpm
)

# Create the base directory.
mkdir -p ~/yum-repos
cd ~/yum-repos

# Delete and re-create the directories for the repos.
rm -rf $dev_path $qa_path
mkdir -p $dev_path $qa_path

# Create the dev repository.
populate_repo $dev_path ${common_files[@]} ${dev_only_files[@]}
populate_repo $qa_path ${common_files[@]}
