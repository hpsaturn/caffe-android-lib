#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

MATRIX_MALOS_LIB_DIR=matrix-malos-lib
MATRIX_MALOS_LIB=${PROJECT_DIR}/${MATRIX_MALOS_LIB_DIR}
MATRIX_MALOS_LIB_BUILD_DIR=${MATRIX_MALOS_LIB}/build
MATRIX_MALOS_LIB_HOME=${INSTALL_DIR}/${MATRIX_MALOS_LIB_DIR}
PROTOBUF_DIR=${INSTALL_DIR}/protobuf

rm -rf "${MATRIX_MALOS_LIB_BUILD_DIR}"
mkdir -p "${MATRIX_MALOS_LIB_BUILD_DIR}"
pushd "${MATRIX_MALOS_LIB_BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${PROJECT_DIR}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DPROTOBUF_INCLUDE_DIR=${PROTOBUF_DIR}/include \
      -DPROTOBUF_LIBRARY=${PROTOBUF_DIR}/lib/libprotobuf.a \
      -DZMQ_LIB=${INSTALL_DIR}/libzmq/lib/libzmq.a \
      -DZMQ_INCLUDE_DIR=${INSTALL_DIR}/libzmq/include \
      -DMATRIX_PROTOS_LIB=${INSTALL_DIR}/matrixio_protos/lib/libmatrixio_protos.a \
      -DMATRIX_PROTOS_INCLUDE_DIR=${INSTALL_DIR}/matrixio_protos/include \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/${MATRIX_MALOS_LIB_DIR}" \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/${MATRIX_MALOS_LIB_DIR}"
make install/strip

popd
