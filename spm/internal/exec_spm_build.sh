#! /bin/sh

# build_config=$1
# package_path="$2"
# build_path="$3"

build_config=$1
shift
package_path="$1"
shift
build_path="$1"
shift

# Execute the SPM build
swift build \
  --manifest-cache none \
  --disable-sandbox \
  --configuration $build_config \
  --package-path "$package_path" \
  --build-path "$build_path"

# Replace the specified files with the provided ones
