#!/bin/bash

# stage1-container-build.sh
# This does the inital configuration of the container
# and is a shell file for simplicity and to perform
# actions that are hard to define in a Containerfile

# This is run during the container creation process
# and then removed from the container. It is not
# needed to be run by container users.

# Get to the HOME directory
cd $HOME

# Compute make -j number
THREADCOUNT=$(grep processor /proc/cpuinfo | wc -l)
# Assume 2-way SMT or a pair of clusters (so consumer class hardware)
JCOUNT=$((THREADCOUNT/2))
# Check we're not below 1
if [ 1 -gt "$JCOUNT" ]; then
	JCOUNT=1
fi
echo Threads: $THREADCOUNT
echo Cores Estimate: $JCOUNT

# Add ToolTrains...eventually
# We'll use the Fedora cross-compilers for now

# Download, Build, Install, and Cleanup the SPIKE model
cd $HOME
git clone https://github.com/riscv/riscv-isa-sim.git -b master --depth=1
cd riscv-isa-sim
mkdir build
cd build
../configure --prefix=/opt/spike
make -j${JCOUNT}
make install
cd $HOME
rm -r riscv-isa-sim
echo '#Add RISC-V spike model to path' >> $HOME/.bashrc
echo 'export PATH=$PATH:/opt/spike/bin' >> $HOME/.bashrc
