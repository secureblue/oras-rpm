#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2026 The Secureblue Authors
#
# SPDX-License-Identifier: Apache-2.0

# Package dependencies for this script:
# git-core go2rpm go-vendor-tools python3-specfile rpmautospec rpmdevtools

set -eux

build_dir=$(pwd)
version=$(awk '$1 == "Version:" { print $2; exit }' oras-rpm/oras.spec)
(
    cd oras-rpm
    cp go-vendor-tools.toml "${build_dir}"
    rpmautospec process-distgit oras.spec "${build_dir}/oras.spec"
)
mkdir -p generate_vendor
cp go-vendor-tools.toml generate_vendor
(
    cd generate_vendor
    go2rpm --name oras --profile vendor --version "${version}" https://github.com/oras-project/oras
    mv "oras-${version}.tar.gz" "oras-${version}-vendor.tar.bz2" "${build_dir}"
)
rm -rf oras-rpm generate_vendor
