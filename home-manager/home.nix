{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "azhar";
  home.homeDirectory = "/home/azhar";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    emacs-all-the-icons-fonts

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/azhar/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

programs.git = {
    enable = true;
    userName = "Azhar Ibn Mostafiz";
    userEmail = "theazharul@gmail.com";
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      core.editor = "emacs";
    };
  };

programs.zsh = {
  enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;

  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
    }
  ];

  oh-my-zsh = {
    enable = true;
    theme = "gnzh";
    plugins = [ "git" ];
  };

  shellAliases = {
    ll = "ls -lah";
    gs = "git status";
    gp = "git pull";
  };
};


  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages = epkgs: with epkgs; [
      use-package
      evil
      magit
    evil-mc
    evil-tex
    evil-org
    evil-surround
    evil-markdown
    evil-commentary
    evil-collection
    evil-vimish-fold
    treemacs
    treemacs-projectile
    projectile
    projectile-ripgrep
    projectile-speedbar
    corfu
    vertico
    consult
    embark
    marginalia
    flymake
    flymake-popon
    prettier
    web-mode
    emmet-mode
    nix-mode
    python-mode
dart-mode
php-mode
    vterm
    pdf-tools
    yasnippet
    yasnippet-snippets
    elixir-ts-mode
    elixir-yasnippets
    all-the-icons
    highlight-indent-guides
    doom-themes
    general
    po-mode
    dashboard
    treemacs
    toc-org
      rainbow-delimiters
which-key
dictionary
hydra
editorconfig
expand-region
smartparens
undo-tree

    tree-sitter
    tree-sitter-langs
    ];
  };

services.emacs.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
