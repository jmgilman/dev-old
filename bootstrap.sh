#!/usr/bin/env bash

# Bootstraps a MacBook with Homebrew and all dependencies required for running
# Ansible playbooks locally. The script attempts to be idempotent and should be
# safe to run multiple times.

# Installs the given package name using Homebrew
installWithBrew() {
    echo "Check if $1 is installed..."
    brew list $1 &> /dev/null
    if [[ $? -gt 0 ]]
    then
        echo "Installing $1..."
        brew install $1
    else
        echo "Upgrading $1..."
        brew upgrade $1
    fi
}

# Homebrew requires xcode to be installed
xcode-select --install &> /dev/null

# Only run Homebrew installer if it's not found
echo "Checking if Homebrew is installed..."
command -v brew &> /dev/null
if [[ $? -gt 0 ]]
then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Required dependencies for running Ansible playbooks
DEPENDENCIES=("python3" "ansible")

# Ensure we are using the latest metadata
echo "Updating/upgrading Homebrew..."
brew update

# Install all dependencies
for DEPEND in ${DEPENDENCIES[@]}
do
    installWithBrew ${DEPEND}
done

echo "Done!"