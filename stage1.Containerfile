FROM fedora:40
ARG TARGETARCH
MAINTAINER "Carl Perry <caperry@edolnx.net>"

RUN dnf update
# Deps for RISC-V GNU Toolchain: https://github.com/riscv-collab/riscv-gnu-toolchain
RUN dnf install -y autoconf automake python3 libmpc-devel mpfr-devel gmp-devel
RUN dnf install -y gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel
RUN dnf install -y expat-devel libslirp-devel diffutils binutils-gold mold
# Deps for SAIL
RUN dnf install -y z3 git zsh
# Deps for Python: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN dnf install -y make gcc patch zlib-devel bzip2 bzip2-devel readline-devel
RUN dnf install -y sqlite sqlite-devel openssl-devel tk-devel libffi-devel 
RUN dnf install -y xz-devel libuuid-devel gdbm-libs libnsl2
# Deps for Ruby: https://github.com/rbenv/ruby-build/wiki
RUN dnf install -y autoconf gcc rust patch make bzip2 openssl-devel 
RUN dnf install -y libyaml-devel libffi-devel readline-devel zlib-devel
RUN dnf install -y gdbm-devel ncurses-devel
# Deps for OCAML: https://github.com/asdf-community/asdf-ocaml
RUN dnf install -y file unzip diffutils
# Deps for OPAM
RUN dnf install -y bubblewrap darcs hg rsync

# Useful tools
RUN dnf install -y zsh

# Cleanup dnf
RUN dnf clean all
