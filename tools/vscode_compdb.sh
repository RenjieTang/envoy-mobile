#!/usr/bin/env bash

# Generates a compile_commands.json file for use with the VS Code clangd plugin.
# This is a modification of evnoy/tools/vscode/refresh_compdb.sh which hits
# the correct envoy-mobile Bazel targets.

# Use bazelisk if present, if not use bazel.
bazel_or_isk=bazelisk
command -v bazelisk &> /dev/null || bazel_or_isk=bazel

# Setting TEST_TMPDIR here so the compdb headers won't be overwritten by another bazel run
CC=clang TEST_TMPDIR=${BUILD_DIR:-/tmp}/envoy-mobile-compdb envoy/tools/gen_compilation_database.py --vscode --bazel=$bazel_or_isk //library/cc/... //library/common/... //test/cc/... //test/common/...

# Kill clangd to reload the compilation database
pkill clangd || :
