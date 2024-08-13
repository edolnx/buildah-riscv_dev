#!/bin/bash

# figure out the targetarch
MACHINEARCH=$(uname -m)
if [ "$MACHINEARCH" == "x86_64" ]; then
	echo "amd64"
	TARGETARCH=amd64
elif [ "$MACHINEARCH" == "aarch64" ]; then
	echo "arm64"
	TARGETARCH=arm64
elif [ "$MACHINEARCH" == "riscv64" ]; then
	echo "riscv64"
	TARGETARCH=riscv64
else
	echo "unknown"
fi

buildah build -f stage1.Containerfile -t riscv_dev-${TARGETARCH}:stage1 .
buildah build -f stage2.Containerfile -t riscv_dev-${TARGETARCH}:stage2 .
buildah build -f stage3.Containerfile -t riscv_dev-${TARGETARCH} .
