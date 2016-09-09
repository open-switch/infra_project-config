#!/bin/bash

#Usage: ./create_release_branch <new_branch_name> <SHA of ops-build>

# Create a sandbox directory if it does not exist
if [ ! -d branch_creation ]; then
    echo "Creating a new directory for working"
    mkdir branch_creation
else
    echo "Directory exists. Moving on..."
fi

cd branch_creation

# Clone ops-build if it does not exist already
if [ ! -d ops-build ]; then
    echo "Cloning ops-build and reset to the desired SHA"
    git clone ssh://openswitch-jenkins@review.openswitch.net:29418/openswitch/ops-build
    cd ops-build
else
    echo "ops-build already exists."
    cd ops-build
    git pull --rebase
fi

# Rest ops-build to the SHA that from where we need to branch
git reset --hard $2

if [ ! -d src ]; then
    mkdir src
fi

#Parse the recipe files and clone all the repos and reset each repo to the SHA in the recipe file
for recipe in `find yocto/openswitch/meta-distro-openswitch/recipes-ops/. -name *.bb`
do
    if grep -q SRCREV "$recipe"; then
        sha=$(grep SRCREV $recipe | cut -d'"' -f2)
        if [ $sha = "\${AUTOREV}" ]; then
            sha=HEAD
        fi
    fi

    repo=`echo $recipe | cut -d'/' -f7 | cut -d'.' -f1`
    echo "######################################################"
    echo "######################################################"
    echo Create branch $1 on repo openswitch/$repo based on SHA value $sha from recipe: $recipe
    ssh -p 29418 openswitch-jenkins@review.openswitch.net gerrit create-branch openswitch/$repo $1 $sha
    echo "######################################################"
    echo "######################################################"
done
