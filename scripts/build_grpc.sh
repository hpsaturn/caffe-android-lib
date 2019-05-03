#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/../config.sh"

PROTOBUF_ROOT=${PROJECT_DIR}/protobuf
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
      -DHAVE_STD_REGEX=OFF \
      -DHAVE_POSIX_REGEX=OFF \
      -DHAVE_STEADY_CLOCK=OFF \
      -DgRPC_PROTOBUF_PROVIDER=package \
      -Dprotobuf_BUILD_TESTS=OFF \
      -DRPC_PROTOBUF_PACKAGE_TYPE=module \
      -DProtobuf_PROTOC_EXECUTABLE=/usr/local/bin/protoc \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DPROTOBUF_PROTOC_LIBRARY="${PROTOBUF_ROOT}/libprotoc.a" \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -Dprotobuf_BUILD_TESTS=OFF \
      ..

make -j"${N_JOBS}"
rm -rf "${INSTALL_DIR}/grpc"
make install/strip
git clean -fd 2> /dev/null || true

popd
