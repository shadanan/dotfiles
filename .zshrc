source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle pip
antigen bundle vagrant

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Git super status
antigen bundle shadanan/zsh-git-prompt

# Load the theme.
antigen theme shadanan/oh-my-zsh-themes shad

# Tell antigen that you're done.
antigen apply
