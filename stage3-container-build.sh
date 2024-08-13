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

# Install mise for future use
curl https://mise.run | bash
~/.local/bin/mise --version
echo ^^^^ mise version

# Make a default zshrc so zsh will start silently
cat <<EOF > $HOME/.zshrc
source $HOME/.bashrc
EOF

# Set sane defaults for asdf
cat <<EOF > ~/.asdfrc
legacy_version_file = no
use_release_candidates = no
always_keep_download = no
plugin_repository_last_check_duration = 60
disable_plugin_short_name_repository = no
concurrency = auto
EOF

# Install and enable asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
source "$HOME/.asdf/asdf.sh"
echo 'source "$HOME/.asdf/asdf.sh"' >> $HOME/.bashrc

# Install and enable direnv
curl -sfL https://direnv.net/install.sh | bash
direnv version
echo ^^^^ direnv version
mkdir -p $HOME/.config/direnv
cat <<EOF > $HOME/.config/direnv/direnv.toml
[whitelist]
prefix = [ "/work" ]
EOF
eval "$(direnv hook bash)"
echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc

# Add various ASDF language plugins
asdf plugin add python
asdf plugin add ruby
asdf plugin add ocaml
asdf plugin add opam

# Install various ASDF managed runtimes at specific versions
asdf install opam 2.2.0 || exit 1
asdf install ocaml 4.13.1 || exit 2
asdf install python 3.10.14 || exit 3
asdf install ruby 3.2.3 || exit 4

# Install OPAM components
echo "Activating asdf environments"
asdf shell ocaml 4.13.1 
asdf shell opam 2.2.0
asdf shell python 3.10.14
echo "Initialize opam"
opam init --disable-sandboxing #Sanboxing doesn't work within the conatiner
echo "Configure opam environment"
eval $(opam config env)
export OPAMCLI=2.0
echo 'eval $(opam config env)' >> $HOME/.bashrc
echo 'export OPAMCLI=2.0' >> $HOME/.bashrc
echo "opam install lem"
opam install "lem=2022-12-10" -y
echo "opam install sail"
opam install "sail=0.18" -y
opam install hardtools7 -y

# Build and install Golden Model from source
cd $HOME
git clone https://github.com/rems-project/sail-riscv.git
cd sail-riscv
make ocaml_emulator/riscv_ocaml_sim_RV64
make c_emulator/riscv_sim_RV64
ARCH=RV32 make ocaml_emulator/riscv_ocaml_sim_RV32
ARCH=RV32 make c_emulator/riscv_sim_RV32
mkdir -p /act/sail/bin
mv ./c_emulator/riscv_sim_* /act/sail/bin
mv ./ocaml_emulator/riscv_ocaml_sim_* /act/sail/bin
cd $HOME
rm -rf sail-riscv 
echo '#Add RISC-V SAIL model to path' >> $HOME/.bashrc
echo 'export PATH=$PATH:/act/sail/bin' >> $HOME/.bashrc


# Install Python Dependencies for RISCOF 
pip3 install -U pip
pip3 install pexpect \
        PyYAML \
        numpy \
        pytest \
        prettytable \
        colorlog \
        GitPython \
        click \
        Jinja2 \
        pytz \
        riscof \
        riscv-config \
        riscv-isac \
        riscv-ctg 

# Install Ruby and Ruby Deps for unified-db
asdf shell ruby 3.2.3
gem install asciidoctor-diagram -v '~> 2.2'
gem install asciidoctor-multipage
gem install base64
gem install bigdecimal
gem install json_schemer -v '~> 1.0'
gem install rake -v '~> 13.0'
gem install slim -v '~> 5.1'
gem install treetop -v '1.6.12'
gem install webrick
gem install yard
gem install solargraph