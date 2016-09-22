#!/bin/bash

#Usage: ./tagging_branch <new_tag_name> <SHA of ops-build>

# Create a sandbox directory if it does not exist
if [ ! -d tagging_branch ]; then
    echo "Creating a new directory for working"
    mkdir tagging_branch
else
    echo "Directory exists. Moving on..."
fi

cd tagging_branch

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
    mkdir -p src/$repo
    cd src/$repo
    git clone ssh://openswitch-jenkins@review.openswitch.net:29418/openswitch/$repo .
    git pull --rebase origin
    git reset --hard $sha
    git tag -a $1 -m "Creating a tag on the SHA value"
    echo "######################################################"
    echo "######################################################"
    echo pushing tag on repo $repo
    git push origin --tags
    cd ../..
    echo "######################################################"
    echo "######################################################"
done
