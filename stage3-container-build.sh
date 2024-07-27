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
prefix = [ "/root/work" ]
EOF
eval "$(direnv hook bash)"
echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc

# Add various ASDF language plugins
asdf plugin add python
asdf plugin add ruby
asdf plugin add ocaml
asdf plugin add opam

# Install various ASDF managed runtimes at specific versions
asdf install ocaml 4.13.1
asdf install opam  2.1.5
asdf install python 3.6.15

# Install OPAM components
echo "Activating asdf environments"
asdf shell ocaml 4.13.1
asdf shell opam 2.1.5
asdf shell python 3.6.15
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
opam install "sail=0.17.1" -y
