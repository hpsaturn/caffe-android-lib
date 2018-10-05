#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

ZEROMQ_DIR=libzmq
ZEROMQ=${PROJECT_DIR}/${ZEROMQ_DIR}
ZEROMQ_BUILD_DIR=${ZEROMQ}/build
ZEROMQ_HOME=${INSTALL_DIR}/${ZEROMQ_DIR}

rm -rf "${ZEROMQ_BUILD_DIR}"
mkdir -p "${ZEROMQ_BUILD_DIR}"
pushd "${ZEROMQ_BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${ZEROMQ_DIR}" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/${ZEROMQ_DIR}"
make install/strip

popd
