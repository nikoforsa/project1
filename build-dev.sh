#!/bin/bash
git config --global http.sslVerify "false"

SB=""
export NAME_PROJECT=$(basename $(pwd))

chmod 700 ${HOME_DIRECTORY}/.ssh/id_rsa

cd ${HOME_DIRECTORY}
mkdir -p ${PACKAGE_DIRECTORY}
#echo $GITSSHKEY
if [[ -z "${GITSSHKEY}" ]]; then
    git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.com/project1/bld-helpers.git
else
    git config --global core.sshCommand "ssh -i ${HOME_DIRECTORY}/.ssh/id_rsa -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    git clone git@git.com:project1/bld-helpers.git
    #git config credential.$remote.username $username"
fi
cd ${HOME_DIRECTORY}/bld-helpers

chmod +x ./conan_set.sh && ./conan_set.sh

cd ${HOME_DIRECTORY}/workspace/${NAME_PROJECT}
#cd ${HOME_DIRECTORY}/workspace/

if [[ "$1" == "true" ]]; then
    SB="--keep-build"
    #export KEEP_BUILD="true"
else
    SB=${KEEP_BUILD}
fi

if [[ "${KEEP_BUILD}" == "true" ||  "$1" == "true" ]]; then
    echo "use cache - $1 - ${KEEP_BUILD} - ${SB}"
    conan create . ${SB}
else 
    echo "no cache - $1 - ${KEEP_BUILD} - ${SB}"
    #conan create .
    mkdir -p ${HOME_DIRECTORY}/build && cd ${HOME_DIRECTORY}/build
    conan install -of ${HOME_DIRECTORY}/build ${HOME_DIRECTORY}/${NAME_PROJECT}/conanfile.py
    conan build -if ${HOME_DIRECTORY}/build -bf ${HOME_DIRECTORY}/build ${HOME_DIRECTORY}/${NAME_PROJECT}/conanfile.py
fi

if [[ "${PUBLISH}" == true ]]; then
    cd ${HOME_DIRECTORY}/bld-helpers
    chmod +x ./bld-smb.sh && ./bld-smb.sh
fi
