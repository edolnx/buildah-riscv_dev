# RISC-V Development Container

This repo builds a container for RISC-V Development. It is built using Fedora 40, asdf-vm, and direnv. The use of asdf-vm and direnv are so you are free to duplicate the environment on your local Linux development environment for ease of use across projects. This is primarily built for use with [sail-riscv](https://github.com/riscv/sail-riscv) and [riscof] but can be expanded for use with other projects as well.

## Usage

The containers are designed to be used with podman and are designed to be run rootless. If you are running on MacOS or Windows, you will need [podman desktop](https://podman-desktop.io) installed. Both amd64 (x86_64) and arm64 (Aarch64) builds are provided at [quay.io/edolnx/riscv_dev](https://quay.io/repository/edolnx/riscv_dev). Note that the container is large (around 3G) but includes all the necessary tools and is much faster than building all the tools yourself if you are not making changes to the tooling environment. The easiest way to use the container is to be within something like the sail-riscv repository and run:

`podman run -ti -v .:/root/work quay.io/edolnx/riscv_dev:latest /bin/bash -i`

After the container downloads, you will be given a prompt within the container lke `[root@a30692197e9a /]#` from there you can `cd /root/work` and then build the codebase with a simple `make`. The output will be stored on your local disk, and typing `exit` will end the container session.

## Notes on security

This container is designed to be run locally as a development environment, and provides no exposed services. Running a security scan will show known vulnerabilities, and we are aware of this and they will not be "fixed". Some of the required tools are old, and thus have known issues. We designed this container to be a convienent way to run command line compiler tools on non-Linux environment as simply as possible. As the target projects move to newer versions, this container will also be updated.

## Building

Should you want to make changes and rebuild this container for yourself there are a few items you should be aware of:

1) This container must be built on a native Linux host and cannot be build within a podman-desktop conatiner. That may change in the future, but the recurison of rootless containers was too much effort for now. The build only requires the `podman` and `buildah` packages from your host OS.
2) The `build-all.sh` script will build all three stages of the container, it's then up to you to publish the container
3) The second stage builds a complete multilib enabled GNU compliler toolchain against newlib. It has a mechanism to guess as the optimal `make -j` count, and that guess is very conservative but works well. This takes about 30min on a Threadripper 2950X or on a GCP t2a-standard-16 instance.
4) The process consumes a lot of disk space, you will need close to 30G available during the build.

### Build Stages

- Stage 1 is just adding packages to the Fedora 40 install. They are all clearly labeled.
- Stage 2 is building the GCC Toolchain in multilib mode (supporting RV32 and RV64) with newlib support.
- Stage 3 is setting up direnv and asdf-vm as well as the runtime environments needed by `sail-riscv`

# License

This is provided AS-IS under the terms of the MIT license. Contributions are welcome for updates.

# Container Information

[![riscv_dev Container Repository on Quay](https://quay.io/repository/edolnx/riscv_dev/status "riscv_dev Repository on Quay")](https://quay.io/repository/edolnx/riscv_dev)
[![riscv_dev-arm64 Repository on Quay](https://quay.io/repository/edolnx/riscv_dev-arm64/status "riscv_dev-arm64 Repository on Quay")](https://quay.io/repository/edolnx/riscv_dev-arm64)
[![riscv_dev-amd64 Repository on Quay](https://quay.io/repository/edolnx/riscv_dev-amd64/status "riscv_dev-amd64 Repository on Quay")](https://quay.io/repository/edolnx/riscv_dev-amd64)
