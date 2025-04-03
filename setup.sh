sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install zsh
sudo apt-get install git

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# add plugins
# fzf
# autojump




# Safely append zsh configuration
echo "
# === Begin ZSH Configuration ===
# Auto switch to zsh if available
if [ -t 1 ]; then
  if command -v zsh >/dev/null 2>&1; then
    exec zsh
  fi
fi
# === End ZSH Configuration ===" >> ~/.bashrc
Configuration for automatic zsh switch has been added to ~/.bashrc

# Dump my zshrc configuration
echo "Backing up default zshrc to ~/.zshrc.default 🦺"
cp -f ~/.zshrc ~/.zshrc.default
echo "Backing up default bashrc to ~/.bashrc.default 🦺"
cp -f ~/.bashrc ~/.bashrc.default

echo "Adding custom zshrc configuration🚀"
cp -f ~/.setup/development/zshrc ~/.zshrc

# Dump git configuration
echo "Backing up default gitconfig to ~/.gitconfig.default 🦺"
cp -f ~/.gitconfig ~/.gitconfig.default
echo "Adding custom gitconfig configuration🚀"
cp -f ~/.setup/development/gitconfig ~/.gitconfig

echo  "Installing pyenv 🐍"
# Install pyenv
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc


# DEPENDENCIES
sudo apt-get install -y \
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  liblzma-dev

echo "\n\n"
echo "✨ Setup complete ✨"
echo "✅ Restart your terminal to apply changes."
