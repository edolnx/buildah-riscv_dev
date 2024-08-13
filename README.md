# RISC-V Development Container

This repo builds a container for RISC-V Development. It is built using Fedora 40, asdf-vm, and direnv. The use of asdf-vm and direnv are so you are free to duplicate the environment on your local Linux development environment for ease of use across projects. This is primarily built for use with [sail-riscv](https://github.com/riscv/sail-riscv) and [riscof] but can be expanded for use with other projects as well.

## Usage

The containers are designed to be used with podman and are designed to be run rootless. If you are running on MacOS or Windows, you will need [podman desktop](https://podman-desktop.io) installed. Both amd64 (x86_64) and arm64 (Aarch64) builds are provided at [quay.io/edolnx/riscv_dev](https://quay.io/repository/edolnx/riscv_dev). Note that the container is large (around 3G) but includes all the necessary tools and is much faster than building all the tools yourself if you are not making changes to the tooling environment. The easiest way to use the container is to be within something like the sail-riscv repository and run:

`podman run -ti -v $(pwd):/work quay.io/edolnx/riscv_dev:latest /bin/bash -i`

After the container downloads, you will be given a prompt within the container lke `[root@a30692197e9a /]#` from there you can `cd work` and then build the codebase with a simple `make`. The output will be stored on your local disk, and typing `exit` will end the container session.

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

## License

This is provided AS-IS under the terms of the MIT license. Contributions are welcome via pull-requests to this repository.

# How to use on Windows

You will need to download [podman desktop](https://podman-desktop.io) on your Windows machine. When installing podman desktop, you do not need any components other than podman. As the last step of install, podman-desktop will create a podman-machine. During this process, you will be asked three questions. You can turn off "Machine with root privileges" and turn on "User mode networking", while leaving the other options alone. These enhance security and reduce complexity of networking, especially on portable machines. The command given above in the Usage section will work in you Git Bash shell. If you want to use PowerShell instead, the correct command would be:

`podman run -ti -v $(Get-Location):/work quay.io/edolnx/riscv_dev:latest /bin/bash -i`

This would set your current working directory to be the `/work` path inside the container. You can also just use a standard Windows path like `C:\Users\edolnx\work:/work` as well.

# How to use on MacOS

You will need to download [podman desktop](https://podman-desktop.io) on your Windows machine. When installing podman desktop, you do not need any components other than podman. As the last step of install, podman-desktop will create a podman-machine. During this process, you will be asked three questions. You can turn off "Machine with root privileges" and turn on "User mode networking", while leaving the other options alone. These enhance security and reduce complexity of networking, especially on portable machines. MacOS security requires you to specify the full path to any volume you are trying to mount, hence the use of `$(pwd)` in the Usage example above. The default command used in the Usage section executes a `bash` shell by invoking `/bin/bash -i`, but you can substitute a more familar ZSH shell using `/usr/bin/zsh -i` if you choose.