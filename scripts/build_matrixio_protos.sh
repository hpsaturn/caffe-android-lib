#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

MATRIXIO_PROTOS_DIR=matrixio_protos
MATRIXIO_PROTOS=${PROJECT_DIR}/${MATRIXIO_PROTOS_DIR}
MATRIXIO_PROTOS_BUILD_DIR=${MATRIXIO_PROTOS}/build
MATRIXIO_PROTOS_HOME=${INSTALL_DIR}/${MATRIXIO_PROTOS_DIR}
PROTOBUF_DIR=${INSTALL_DIR}/protobuf

rm -rf "${MATRIXIO_PROTOS_BUILD_DIR}"
mkdir -p "${MATRIXIO_PROTOS_BUILD_DIR}"
pushd "${MATRIXIO_PROTOS_BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DPROTOBUF_INCLUDE_DIR=${PROTOBUF_DIR}/include \
      -DPROTOBUF_LIBRARY=${PROTOBUF_DIR}/lib \
      -DPROTOC=${INSTALL_DIR}/protobuf_host/bin/protoc \
      -DProtoHeaders=${PROTOBUF_DIR}/include \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${MATRIXIO_PROTOS_DIR}" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/${MATRIXIO_PROTOS_DIR}"
make install/strip

popd
