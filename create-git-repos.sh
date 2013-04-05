#!/usr/bin/env bash

set -e

# The first part of the file we're creating.
first_part () {
    cat <<EOF
Morning comes too early
And nighttime falls too late

Sometimes all I want to do is wait
The shadow I've been hiding in
Has fled from me today

I know it's easier
To walk away than look it in the eye
But will raise a shelter to the sky

And here beneath this star tonight I'll lie
She will slowly yield the light
As I awaken from the longest night
EOF
}

# The second part of the file we're creating.
second_part () {
    cat <<EOF

Dreams are shaking
Set sirens waking up tired eyes
With the light the memories
All rush into his head

By a candle stands a mirror
Of his heart and soul she dances
Shewas dancing through the night
Above his bed

And walking to the window
He throws the shutters out
Against the wall

And from an ivory tower hears her call
'Let light surround you'
EOF
}

# Configure the git client
configure_git () {
    git config --global user.email "vagrant@iplantc.org"
    git config --global user.name "Vagrant VM"
}

# Creates the git repositories.
create_repositories () {
    rm -rf local remote
    mkdir local remote
    git init local
    git init --bare --shared=group remote
}

# Populates the git repositories.
populate_repositories () {
    cd local
    git remote add origin ../remote

    # Create the first commit
    echo "$(first_part)" >> surrounded.txt
    git add surrounded.txt
    git commit -m 'FOO-1: added the first part'
    git push -u origin master

    # Create the second commit in the dev branch.
    git checkout -b dev
    echo "$(second_part)" >> surrounded.txt
    git add surrounded.txt
    git commit -m 'FOO-2: added the second part'
    git push -u origin dev
}

mkdir -p ~/git-repos
cd ~/git-repos
configure_git
create_repositories
populate_repositories
