FROM fedora:39

ARG USER=andreasvoss

RUN dnf update && dnf upgrade -y

RUN dnf install 'dnf-command(config-manager)' -y

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm

RUN dnf config-manager --add-repo \
        https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/Fedora_36/shells:zsh-users:zsh-completions.repo
RUN dnf copr -y enable atim/starship

RUN dnf install docker neovim perl openssl git rust zsh passwd nodejs fuse dotnet-sdk-7.0 dotnet-sdk-8.0 podman jq \
        zsh-completions starship stow bat azure-cli lm_sensors libgtop2-devel ripgrep tree-sitter-cli libstdc++-static\
        libstdc++ gcc-c++ cargo -y

RUN cargo install --locked zellij

COPY ./resources/wsl.conf /etc/wsl.conf

RUN useradd -ms /bin/zsh $USER
RUN usermod -aG docker $USER
USER $USER
WORKDIR /home/$USER

RUN echo 'ZDOTDIR=$HOME/.config/zsh' > $HOME/.zshenv
RUN mkdir -p repos
RUN git clone https://github.com/andreasuvoss/dotfiles.git repos/dotfiles
RUN stow -d /home/$USER/repos/dotfiles git idea nvim starship task zellij zsh -t /home/$USER
RUN nvim --headless "+Lazy! sync" +qa
RUN nvim --headless "+TSInstallSync! all" +qa
