#!/bin/bash

set -ex

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$HERE"

export GLUON_BRANCH="${GLUON_BRANCH:-experimental}"
export GLUON_PRIORITY="${GLUON_PRIORITY:-1}"

eval $(make -s -f helper.mk)

echo -e "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"
echo -e "GLUON_BRANCH: ${GLUON_BRANCH}"
echo -e "GLUON_RELEASE: ${GLUON_RELEASE}"

cd ..

# Remove old images
rm -vrf images/factory images/sysupgrade

OLD_OPENWRT_RELEASE=$(grep 'RELEASE:=' include/toplevel.mk | sed -e 's/RELEASE:=//')
OLD_TARGETS=$(make 2>/dev/null | grep '^ [*] ' | cut -d' ' -f3)

for target in ${OLD_TARGETS}
do
    make clean GLUON_TARGET=${target} $VERBOSE
done
make dirclean

git checkout "${GLUON_CHECKOUT}"
git pull origin "${GLUON_CHECKOUT}"

NEW_TARGETS="$(make 2>/dev/null | grep '^ [*] ' | cut -d' ' -f3)"
for target in ${NEW_TARGETS}
do
    make clean GLUON_TARGET=${target} $VERBOSE
done

for target in ${NEW_TARGETS}
do
    echo -e "Starting to build target \033[32m${target}\033[0m ..."
    make GLUON_TARGET=${target} -j4 $VERBOSE
done

make manifest $VERBOSE
