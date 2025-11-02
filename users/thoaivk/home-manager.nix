{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  shellAliases = {
    # Git aliases
    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gcp = "git cherry-pick";
    gdiff = "git diff";
    gl = "git prettylog";
    gp = "git push";
    gs = "git status";
    gt = "git tag";

    # Jujutsu aliases
    jd = "jj desc";
    jf = "jj git fetch";
    jn = "jj new";
    jp = "jj git push";
    js = "jj st";

    # Ruby/Rails aliases
    be = "bundle exec";
    rc = "bundle exec rails console";
    rs = "bundle exec rails server";
    rspec = "bundle exec rspec";

    # Docker aliases
    dc = "docker-compose";
    dcu = "docker-compose up -d";
    dcd = "docker-compose down";
    dps = "docker ps";
    di = "docker images";

    # LazyGit/LazyDocker
    lg = "lazygit";
    ld = "lazydocker";

    # Mise version manager
    mi = "mise install";
    mu = "mise use";
    ml = "mise ls";
    mc = "mise current";
    mup = "mise upgrade";

    # Neovim
    nv = "nvim";

    # Eza (better ls) - with icons and show all files including hidden
    ls = "eza --icons --all --group-directories-first";
    ll = "eza --icons --all --long --group-directories-first --git";
    la = "eza --icons --all --long --group-directories-first --git --header";
    lt = "eza --icons --all --tree --level=2 --group-directories-first";
    llt = "eza --icons --all --long --tree --level=2 --group-directories-first --git";
  } // (if isLinux then {
    pbcopy = "xclip";
    pbpaste = "xclip -o";
  } else {});

  # For our MANPAGER env var
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  # Home-manager state version
  home.stateVersion = "18.09";
  home.enableNixpkgsReleaseCheck = false;
  home.shell.enableNushellIntegration = false;

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = [
    # Core CLI tools
    pkgs._1password-cli
    pkgs.asciinema
    pkgs.bat
    pkgs.chezmoi
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch

    # AI Tools
    pkgs.claude-code
    pkgs.codex

    # Version Managers
    pkgs.mise       # Mise - for Ruby and Node.js (multiple versions)

    # Node.js Package Managers
    pkgs.bun        # Ultra-fast all-in-one JavaScript runtime & package manager
    pkgs.pnpm       # Fast, disk space efficient package manager
    pkgs.yarn-berry # Modern Yarn (v4+) - faster and more features
    pkgs.deno       # Modern JavaScript/TypeScript runtime (alternative to Node.js)
    # npm is included with each Node.js version automatically

    # Python (system Python for tools)
    pkgs.python312
    pkgs.uv  # Fast Python package manager (alternative to pip/poetry)

    # Build Tools (required for mise to compile languages)
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
    pkgs.openssl
    pkgs.zlib
    pkgs.readline
    pkgs.libffi
    pkgs.libyaml
    pkgs.ncurses

    # Rust Development (keep for system tools that need rust)
    pkgs.rustc
    pkgs.cargo
    pkgs.rustfmt
    pkgs.rust-analyzer
    pkgs.clippy

    # Database Tools
    pkgs.postgresql_16
    pkgs.pgcli
    pkgs.mysql80
    pkgs.mycli
    pkgs.redis
    pkgs.sqlite

    # Docker & Container Tools
    pkgs.docker-compose
    pkgs.lazydocker
    pkgs.kubectl
    pkgs.k9s

    # Shell & Terminal Tools
    pkgs.zsh
    pkgs.lazygit
    pkgs.tmux
    pkgs.tree-sitter

    # Developer Fonts - Nerd Fonts (NixOS 25.05 syntax)
    pkgs.nerd-fonts.comic-shanns-mono  # Primary font
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.caskaydia-cove  # CascadiaCode
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.ubuntu-mono
    pkgs.nerd-fonts.victor-mono

    # Additional Popular Fonts
    pkgs.inter
    pkgs.monaspace

    # API Development & Testing
    pkgs.httpie
    pkgs.curl
    pkgs.hurl

    # Code Quality Tools
    pkgs.shellcheck
    pkgs.hadolint
    pkgs.yamllint

    # Other Development Tools
    pkgs.git-lfs
    pkgs.zigpkgs."0.14.0"

    # Clipboard tools (for Neovim clipboard support)
    pkgs.xclip        # X11 clipboard
    pkgs.wl-clipboard # Wayland clipboard

    # LSP Servers (for Neovim NvChad)
    pkgs.clang-tools      # clangd for C/C++
    pkgs.gopls            # Go language server
    pkgs.pyright          # Python language server
    pkgs.nodePackages.typescript-language-server  # TypeScript/JavaScript (works with Node.js 22)
    pkgs.nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
    pkgs.rust-analyzer    # Rust language server (already installed above)
    # Note: solargraph (Ruby LSP) will be installed via gem after Ruby is installed via mise

    # CLI productivity tools
    pkgs.bat             # Better cat
    pkgs.eza             # Better ls
    pkgs.tealdeer        # tldr pages
    pkgs.yazi            # Terminal file manager
    pkgs.btop            # System monitor

  ] ++ (lib.optionals isDarwin [
    pkgs.cachix
    pkgs.tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    pkgs.firefox
    pkgs.valgrind
    pkgs.zathura
  ]);

  #---------------------------------------------------------------------
  # Environment Variables
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";

    # Language-specific environments
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # Mise - Ruby and Node.js (disable GPG verification for ease of use)
    MISE_RUBY_VERIFY = "0";
    MISE_NODE_VERIFY = "0";

    # Build environment for mise
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig:${pkgs.readline.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig:${pkgs.libyaml.dev}/lib/pkgconfig:${pkgs.ncurses.dev}/lib/pkgconfig";
    CFLAGS = "-I${pkgs.openssl.dev}/include -I${pkgs.zlib.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.libyaml.dev}/include -I${pkgs.ncurses.dev}/include";
    LDFLAGS = "-L${pkgs.openssl.out}/lib -L${pkgs.zlib.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.libyaml.out}/lib -L${pkgs.ncurses.out}/lib";

    # Docker
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";

    AMP_API_KEY = "op://Private/Amp_API/credential";
    OPENAI_API_KEY = "op://Private/OpenAPI_Personal/credential";
  } // (if isDarwin then {
    DISPLAY = "nixpkgs-390751";
  } else {});

  #---------------------------------------------------------------------
  # Dotfiles
  #---------------------------------------------------------------------

  home.file = {
    ".gdbinit".source = ./gdbinit;
    ".inputrc".source = ./inputrc;

    "Project/docker-compose" = {
      source = ./docker-compose;
      recursive = true;
    };
  };

  xdg.configFile = {
    # NvChad Neovim configuration
    "nvim" = {
      source = ./nvim;
      recursive = true;
    };
  } // (if isDarwin then {
    "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
  } else {});

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = !isDarwin;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = shellAliases;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = shellAliases;

    initContent = ''
      # Mise version manager integration (Ruby & Node.js)
      eval "$(mise activate zsh)"

      # FZF integration
      eval "$(fzf --zsh)"

      # direnv hook
      eval "$(direnv hook zsh)"

      # Simple prompt
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats '%b '
      setopt PROMPT_SUBST
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{red}''${vcs_info_msg_0_}%f$ '
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    config = {
      whitelist = {
        prefix = [
          "$HOME/code"
          "$HOME/projects"
        ];
        exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" ([
      "source ${inputs.theme-bobthefish}/functions/fish_prompt.fish"
      "source ${inputs.theme-bobthefish}/functions/fish_right_prompt.fish"
      "source ${inputs.theme-bobthefish}/functions/fish_title.fish"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]));

    plugins = map (n: {
      name = n;
      src  = inputs.${n};
    }) [
      "fish-fzf"
      "fish-foreign-env"
      "theme-bobthefish"
    ];
  };

  programs.git = {
    enable = true;
    userName = "thoaivk";
    userEmail = "thoaivk@example.com";
    signing = {
      signByDefault = false;
    };
    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = "";
      credential.helper = "store";
      github.user = "thoaivk";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.lazygit.enable = true;
  programs.jujutsu.enable = true;

  programs.alacritty = {
    enable = !isWSL;
    settings = {
      env.TERM = "xterm-256color";
      key_bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };

  programs.kitty = {
    enable = !isWSL;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.ghostty = {
    enable = !isWSL;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      # Shell
      command = "bash -l -c nu";

      # Font Configuration
      font-family = "ComicShannsMono Nerd Font Mono";
      font-size = 12;
      font-feature = [
        "ss01"
        "ss02"
        "ss03"
        "ss05"
        "cv01"
        "cv02"
      ];

      # Appearance
      background-opacity = 0.95;
      background-blur-radius = 20;
      window-decoration = true;
      window-padding-x = 10;
      window-padding-y = 10;

      # Mouse
      mouse-hide-while-typing = true;

      # Clipboard - Allow access without authorization prompt
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;
      clipboard-paste-bracketed-safe = false;

      # OSC 52 clipboard support (for Neovim)
      clipboard-trim-trailing-spaces = false;

      # Catppuccin Mocha Theme
      background = "1e1e2e";
      foreground = "cdd6f4";

      # Selection colors
      selection-background = "585b70";
      selection-foreground = "cdd6f4";

      # Cursor colors
      cursor-color = "f5e0dc";
      cursor-text = "1e1e2e";

      # Color palette
      palette = [
        "0=#45475a"
        "1=#f38ba8"
        "2=#a6e3a1"
        "3=#f9e2af"
        "4=#89b4fa"
        "5=#f5c2e7"
        "6=#94e2d5"
        "7=#bac2de"
        "8=#585b70"
        "9=#f38ba8"
        "10=#a6e3a1"
        "11=#f9e2af"
        "12=#89b4fa"
        "13=#f5c2e7"
        "14=#94e2d5"
        "15=#a6adc8"
      ];

      # Key bindings
      keybind = [
        # Copy/Paste
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
        "super+shift+c=copy_to_clipboard"
        "super+shift+v=paste_from_clipboard"

        # Font size
        "super+equal=increase_font_size:1"
        "super+minus=decrease_font_size:1"
        "super+zero=reset_font_size"

        # Window management
        "super+q=quit"
        "super+shift+comma=reload_config"
        "super+k=clear_screen"
        "super+n=new_window"
        "super+w=close_surface"
        "super+shift+w=close_window"

        # Tab management
        "super+t=new_tab"
        "super+shift+left_bracket=previous_tab"
        "super+shift+right_bracket=next_tab"

        # Split management
        "super+d=new_split:right"
        "super+shift+d=new_split:down"
        "super+right_bracket=goto_split:next"
        "super+left_bracket=goto_split:previous"
      ];
    };
  };

  programs.atuin.enable = true;

  programs.nushell = {
    enable = true;

    # Mise integration for nushell (Ruby & Node.js)
    extraEnv = ''
      # Mise version manager activation
      mise activate nu | save --force ${config.xdg.configHome}/nushell/mise.nu
    '';

    extraConfig = ''
      # Load mise
      source ${config.xdg.configHome}/nushell/mise.nu
    '';
  };

  programs.oh-my-posh.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";

    extraConfig = builtins.readFile ./tmux.conf;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
