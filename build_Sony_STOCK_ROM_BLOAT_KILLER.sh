#!/bin/sh

function set_variables() {
    current_dir=$(pwd)
    current_dir_build_cache=${current_dir}/buildCache
    current_dir_template=${current_dir}/template
    current_dir_out=${current_dir}/out
}

function test_create_folders() {
    echo "####Test if every folder exist or creates it START####"
    if [[ ! -d ${current_dir_build_cache} ]]
    then
        mkdir ${current_dir_build_cache}
    fi
    if [[ ! -d ${current_dir_out} ]]
    then
        mkdir ${current_dir_out}
    fi
    echo "####Test if every folder exist or creates it END####"
}

function test_repo_up_to_date() {
    echo "####Test if git repo is up-to-date START####"
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [[ ${LOCAL} = ${REMOTE} ]]; then
        echo "Git repo is up-to-date!"
    elif [[ ${LOCAL} = ${BASE} ]]; then
        echo "Git repo not up to date!"
        read -n1 -r -p "Press space to continue..."
    elif [[ ${REMOTE} = ${BASE} ]]; then
        echo "Git repo as uncommited changes"
    read -n1 -r -p "Press space to continue..."
    else
        echo "Git repo is in a weird state."
        echo "Try 'git reset --hard'."
        read -n1 -r -p "Press space to continue..."
    fi
    echo "####Test if git repo is up-to-date END####"
}

function build_zip() {
    echo "####zip START####"
    zip_name=$(date +%Y-%m-%d_%H-%M-%S)_sony_stock_bloat_killer.zip
    rm -rf ${current_dir_build_cache}/*

    cp -r ${current_dir_template}/installer-zip ${current_dir_build_cache}/

    cd ${current_dir_build_cache}/installer-zip/
    zip ${zip_name} -r * -x ${zip_name}

    cp ${current_dir_build_cache}/installer-zip/${zip_name} ${current_dir_out}/
    echo "####zip END####"
}

echo "Are the template files up-to-date?"
echo "IS THIS SHELL IN THE REPOSITORY? Or did you modify the current_dir variable?"
read -n1 -r -p "Press space to continue..."

set_variables;

test_create_folders;

test_repo_up_to_date;

build_zip;

echo "Output ${current_dir_out}"
# echo "Upload to androidfilehost.com !"
read -n1 -r -p "Press space to continue..."

exit 0;
