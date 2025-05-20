FROM fedora:40
ARG TARGETARCH
MAINTAINER "Carl Perry <caperry@edolnx.net>"

RUN dnf update
# Deps for RISC-V GNU Toolchain: https://github.com/riscv-collab/riscv-gnu-toolchain
RUN dnf install -y autoconf automake python3 libmpc-devel mpfr-devel gmp-devel
RUN dnf install -y gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel dtc
RUN dnf install -y expat-devel libslirp-devel diffutils binutils-gold mold 
# RISCOF "Essential Tools"
RUN dnf install -y wget vim gperf telnet bc zip unzip texinfo 
# RISCOF "Network tools"
RUN dnf install -y iputils net-tools netcat
# RISCOF qemu
RUN dnf install -y qemu
# Deps for SAIL
RUN dnf install -y z3 git zsh cmake gcc-c++ libstdc++-devel libstdc++-static
# Deps for Python: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN dnf install -y make gcc patch zlib-devel bzip2 bzip2-devel readline-devel
RUN dnf install -y sqlite sqlite-devel openssl-devel tk-devel libffi-devel 
RUN dnf install -y xz-devel libuuid-devel gdbm-libs libnsl2
# Deps for Ruby: https://github.com/rbenv/ruby-build/wiki
RUN dnf install -y autoconf gcc rust patch make bzip2 openssl-devel 
RUN dnf install -y libyaml-devel libffi-devel readline-devel zlib-devel
RUN dnf install -y gdbm-devel ncurses-devel
# Deps for asciidoc
RUN dnf install -y cmake texlive-atkinson fira-code-fonts pango pango-devel
RUN dnf install -y gdk-pixbuf2-devel cairo-gobject cairo-gobject-devel
RUN dnf install -y liblerc-devel jbigkit-devel
# Deps for OCAML: https://github.com/asdf-community/asdf-ocaml
RUN dnf install -y file unzip diffutils
# Deps for OPAM
RUN dnf install -y bubblewrap darcs hg rsync
# LLVM18 from Fedora
RUN dnf install -y llvm18 clang18 lld18 llvm18-cmake-utils llvm18-static
# GCC14 RISC-V Cross Compiler from Fedora
RUN dnf install -y gcc-riscv32-linux-gnu gcc-riscv64-linux-gnu 
RUN dnf install -y gcc-c++-riscv32-linux-gnu gcc-c++-riscv64-linux-gnu
# renode from their package, doesn't work with dotnet-9
#RUN dnf install -y https://github.com/renode/renode/releases/download/v1.15.3/renode-1.15.3-1.x86_64.rpm
# Useful tools
RUN dnf install -y zsh

# Cleanup dnf
RUN dnf clean all
