#!/bin/bash
set -ex

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$HERE"

#export GLUON_BRANCH="${GLUON_BRANCH:-experimental}"
#export GLUON_PRIORITY="${GLUON_PRIORITY:-7}"

eval $(make -s -f helper.mk)

echo -e "COMMIT_DESCRIPTION: ${COMMIT_DESCRIPTION}"
echo -e "GLUON_CHECKOUT: ${GLUON_CHECKOUT}"
echo -e "GLUON_BRANCH: ${GLUON_BRANCH}"
echo -e "GLUON_RELEASE: ${GLUON_RELEASE}"
echo -e "GLUON_PRIORITY: ${GLUON_PRIORITY}"

cd ..

echo "Checking out ${GLUON_CHECKOUT}"
git checkout "${GLUON_CHECKOUT}"
git pull origin "${GLUON_CHECKOUT}"

make update

build() {
	echo "Preparing build..."

	export FORCE_UNSAFE_CONFIGURE=1
	export VERBOSE=V=1

	make show-release $VERBOSE

	for target in ${SELECTED_TARGETS}
	do
	    echo -e "Starting to build target \033[32m${target}\033[0m ..."
	    make GLUON_TARGET=${target} -j4 $VERBOSE
	done
}

manifest() {
	echo "Preparing build..."

	export FORCE_UNSAFE_CONFIGURE=1
	export VERBOSE=V=1

	make show-release $VERBOSE

	echo "Building Manifest"
	make manifest $VERBOSE
}

if [[ $1 =~ ^(build|manifest)$ ]]; then
  "$@"
else
  echo "Invalid subcommand $1" >&2
  exit 1
fi
