#!/bin/bash

# Function to ask for confirmation
ask() {
  while true; do
    read -p "👉 $1 (y/n): " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) echo "⏭️ Skipping..."; return 1;;
      * ) echo "❌ Please answer yes or no.";;
    esac
  done
}

# Function to prompt for input (optional)
prompt_input() {
  read -p "✏️  $1: " input
  echo "$input"
}

echo "🚀 Starting setup... 🚀"

# Detect the current shell
current_shell=$(ps -p $$ -o comm=)

# Step 1: Update & Upgrade
if ask "Do you want to update and upgrade your system?"; then
  echo "🔄 Updating and upgrading system..."
  sudo apt-get update && sudo apt-get upgrade -y
  echo "✅ System updated!"
fi

# Step 2: Install ZSH (Only if not already in Zsh)
if [[ "$current_shell" != "zsh" ]]; then
  if ask "Do you want to install ZSH?"; then
    echo "🖥️ Installing ZSH..."
    sudo apt-get install -y zsh
    echo "✅ ZSH installed!"

    # Step 3: Set Zsh as default shell and switch immediately
    if ask "Do you want to switch to Zsh now?"; then
      echo "⚙️ Switching to Zsh..."
      exec zsh -c "source ~/.zshrc && exec zsh"
    fi
  else
    echo "❌ ZSH is required for this setup. Exiting script..."
    exit 1
  fi
else
  echo "✅ Already running in Zsh, skipping Zsh installation."
fi

# Step 4: Install Oh My Zsh
if ask "Do you want to install Oh My Zsh?"; then
  echo "🎩 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installed!"
fi

# Step 5: Configure automatic ZSH switch (Only modify Bash if running in Bash)
if [[ "$current_shell" != "zsh" ]]; then
  if ask "Do you want to configure automatic ZSH switch in Bash?"; then
    echo "⚙️ Configuring ZSH as default shell in Bash..."
    echo "
# === Begin ZSH Configuration ===
if [ -t 1 ]; then
  if command -v zsh >/dev/null 2>&1; then
    exec zsh
  fi
fi
# === End ZSH Configuration ===" >> ~/.bashrc
    echo "✅ ZSH switch configuration added!"
  fi
fi

# Step 6: Backup and configure ZSH
if ask "Do you want to backup and add a custom ZSH configuration?"; then
  echo "🦺 Backing up existing ZSH and Bash configurations..."
  cp -f ~/.zshrc ~/.zshrc.default
  cp -f ~/.bashrc ~/.bashrc.default
  echo "🚀 Applying custom ZSH configuration..."
  cp -f ~/.setup/development/zshrc ~/.zshrc
  echo "✅ ZSH configuration applied!"
fi

# Step 7: Backup and configure Git
if ask "Do you want to backup and add a custom Git configuration?"; then
  echo "🦺 Backing up Git configuration..."
  cp -f ~/.gitconfig ~/.gitconfig.default
  echo "🚀 Applying custom Git configuration..."
  cp -f ~/.setup/development/gitconfig ~/.gitconfig
  echo "✅ Git configuration applied!"
fi

# Step 8: Ask for Git username and email
if ask "Do you want to set your Git username and email?"; then
  git_username=$(prompt_input "Enter your Git username (leave blank to skip)")
  git_email=$(prompt_input "Enter your Git email (leave blank to skip)")

  if [[ ! -z "$git_username" ]]; then
    git config --global user.name "$git_username"
    echo "✅ Git username set to: $git_username"
  else
    echo "⏭️ Skipping Git username setup."
  fi

  if [[ ! -z "$git_email" ]]; then
    git config --global user.email "$git_email"
    echo "✅ Git email set to: $git_email"
  else
    echo "⏭️ Skipping Git email setup."
  fi
fi

# Step 9: Install pyenv
if ask "Do you want to install pyenv?"; then
  echo "🐍 Installing pyenv..."
  curl https://pyenv.run | bash
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  source ~/.zshrc
  echo "✅ pyenv installed!"
fi

# Step 10: Install dependencies
if ask "Do you want to install pyenv development dependencies?"; then
  echo "⚙️ Installing dependencies..."
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
  echo "✅ Dependencies installed!"
fi

echo ""
echo "✨ Setup complete! ✨"
echo "✅ Restart your terminal to apply changes."
