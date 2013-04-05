#!/usr/bin/env bash

set -e

# Enables the EPEL repository.
enable_epel () {
    if ! rpm -qa | grep -q epel; then
        wget -q http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
        rpm --quiet -i epel-release-5-4.noarch.rpm
        rm -f epel-release-5-4.noarch.rpm
    fi
}

# Install dependencies.
yum install -qy wget
enable_epel
yum install -qy git createrepo
