#!/bin/bash

set -euo pipefail

# renovate: sha: datasource=git-refs depName=jagex-launcher-linux packageName=https://github.com/USA-RedDragon/jagex-launcher-linux branch=main
JAGEX_LAUNCHER_LINUX_SHA=2af41db52fc465bed75e2998aaa50f6e5a8cd1e7

__PWD=$(pwd)

TMPDIR=$(mktemp -d)
echo "Created temporary directory ${TMPDIR}"
trap "rm -rf ${TMPDIR}" EXIT INT TERM

# If jagex-launcher-linux doesn't exist, clone it
git clone https://github.com/USA-RedDragon/jagex-launcher-linux.git ${TMPDIR}/jagex-launcher-linux
cd ${TMPDIR}/jagex-launcher-linux

git reset --hard HEAD
git fetch --all
git checkout ${JAGEX_LAUNCHER_LINUX_SHA}

JAGEX_LAUNCHER_PATH=${TMPDIR}/jagex-launcher-linux

mkdir ${TMPDIR}/launcher
cd ${TMPDIR}/launcher
python ${JAGEX_LAUNCHER_PATH}/resources/installer.py

wrestool -x --output=icon.ico -t14 JagexLauncher.exe
convert icon.ico icon.png

set -x

if [[ ${__PWD} != */resources/icons ]]; then
    mkdir -p ${__PWD}/resources/icons
    cd ${__PWD}/resources/icons
else
    cd ${__PWD}
fi

cp -v ${TMPDIR}/launcher/icon-0.png $(pwd)/16x16.png
cp -v ${TMPDIR}/launcher/icon-1.png $(pwd)/32x32.png
cp -v ${TMPDIR}/launcher/icon-2.png $(pwd)/48x48.png
cp -v ${TMPDIR}/launcher/icon-3.png $(pwd)/64x64.png
cp -v ${TMPDIR}/launcher/icon-4.png $(pwd)/128x128.png
cp -v ${TMPDIR}/launcher/icon-5.png $(pwd)/256x256.png
