#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

ZEROMQ_DIR=libzmq/builds/android
ZEROMQ=${PROJECT_DIR}/${ZEROMQ_DIR}
ZEROMQ_BUILD_DIR=${ZEROMQ}/prefix
ZEROMQ_HOME=${INSTALL_DIR}/zmq

rm -rf "${ZEROMQ_BUILD_DIR}"
mkdir -p "${ZEROMQ_BUILD_DIR}"
pushd "${ZEROMQ_BUILD_DIR}"

cd $ZEROMQ

export ANDROID_NDK_ROOT=/opt/android-ndk/
export TOOLCHAIN_NAME=arm-linux-androideabi-4.9
export TOOLCHAIN_HOST=arm-linux-androideabi
export TOOLCHAIN_PATH=${ANDROID_NDK_ROOT}/toolchains/${TOOLCHAIN_NAME}/prebuilt/linux-x86_64/bin
export TOOLCHAIN_ARCH=arm

./build.sh

rm -rf "${INSTALL_DIR}/zmq"
cp -r ${ZEROMQ_BUILD_DIR}/${TOOLCHAIN_NAME} "${INSTALL_DIR}/zmq"

popd
