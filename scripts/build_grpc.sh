#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

GRPC_ROOT=${PROJECT_DIR}/grpc
BUILD_DIR=${GRPC_ROOT}/build

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -Dprotobuf_BUILD_PROTOC_BINARIES=OFF \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/grpc" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/grpc"
make install/strip
git clean -fd 2> /dev/null || true

popd
