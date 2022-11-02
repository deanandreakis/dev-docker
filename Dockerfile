FROM ubuntu:latest
LABEL maintainer="Dean Andreakis <dean@deanware.com>"

# Install some basic tools and create a devuser account
RUN apt-get update && \
apt-get install -y git zsh curl sudo build-essential procps file && \
adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser && \
mkdir -p /home/linuxbrew/.linuxbrew && \
chown -R devuser: /home/linuxbrew/.linuxbrew

# Make it so sudo does not require a password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch users
USER devuser

# Install oh-my-zsh
RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.1.3/zsh-in-docker.sh)" -- \
-p git \
-a 'export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"'

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Update PATH
ENV PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Install Editor and CLI tools
RUN brew install ripgrep 
RUN brew install neovim 
RUN brew install tmux 
RUN brew install fzf
