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

# Set sane defaults for mise
cat <<EOF > ~/.asdfrc
legacy_version_file = no
use_release_candidates = no
always_keep_download = no
plugin_repository_last_check_duration = 60
disable_plugin_short_name_repository = no
concurrency = auto
EOF

# Enable mise
eval "$(~/.local/bin/mise activate bash)"
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

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

# Add various mise language plugins
mise plugin add python
mise plugin add ruby
mise plugin add ocaml
mise plugin add opam

# Install various mise managed runtimes at specific versions
mise install opam 2.2.0 || exit 1
mise install ocaml 4.13.1 || exit 2
mise install python 3.10.14 || exit 3
mise install ruby 3.2.3 || exit 4

# Install OPAM components
echo "Activating mise environments"
mise shell ocaml 4.13.1 
mise shell opam 2.2.0
mise shell python 3.10.14
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
opam install "sail=0.19" -y
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
mise shell ruby 3.2.3
gem install "ttfunk", "1.7" # needed to avoid having asciidoctor-pdf dependencies pulling in a buggy version of ttunk (1.8)
gem install "json_schemer" -v "~> 1.0"
gem install "ruby-progressbar" -v "~> 1.13"
gem install "treetop" -v "1.6.12"
gem install "activesupport"
gem install "asciidoctor-diagram" -v "~> 2.2"
gem install "asciidoctor-pdf"
gem install "base64"
gem install "bigdecimal"
gem install "minitest"
gem install "pygments.rb"
gem install "rake", "~> 13.0"
gem install "rouge"
gem install "webrick"
gem install "yard"
gem install "debug"
gem install "rdbg"
gem install "rubocop-minitest"
gem install "ruby-prof"
gem install "ruby-prof-flamegraph"
gem install "solargraph"

# Ruby deps for isa-manual
gem install 'asciidoctor'
gem install 'asciidoctor-bibtex'
gem install 'asciidoctor-diagram'
gem install 'asciidoctor-lists'
gem install  'mathematical'
gem install 'asciidoctor-mathematical'
gem install 'asciidoctor-pdf'
gem install 'asciidoctor-epub3'
gem install 'citeproc-ruby'
gem install 'coderay'
gem install 'csl-styles'
gem install 'json'
gem install 'pygments.rb'
gem install 'rghost'
gem install 'rouge'
gem install 'ruby_dev'


# TODO: Wavedrom