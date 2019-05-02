#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/config.sh"

pushd "${PROJECT_DIR}"

./scripts/build_grpc.sh

popd

echo "DONE!!"
