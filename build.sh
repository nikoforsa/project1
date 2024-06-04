#!/bin/bash
git config --global http.sslVerify "false"

cd ${HOME_DIRECTORY}/${NAME_PROJECT}
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
fi
cd ${HOME_DIRECTORY}/bld-helpers

chmod +x ./conan_set.sh && ./conan_set.sh

cd ${HOME_DIRECTORY}/${NAME_PROJECT}

conan create .

if [[ "${PUBLISH}" == true ]]; then
    cd ${HOME_DIRECTORY}/bld-helpers
    chmod +x ./bld-smb.sh && ./bld-smb.sh
fi
