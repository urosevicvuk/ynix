# Modern CLI tools that replace classic GNU utilities
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Modern replacements for classic tools
    # bat - already in zsh.nix
    # eza - already configured in eza.nix
    # fzf - configured in fzf.nix
    # ripgrep - already in zsh.nix
    # zoxide - already configured in zoxide.nix
    #fd # modern find
    #sd # modern sed
    #dust # modern du
    #duf # modern df (disk usage)
    #procs # modern ps
    #bottom # modern top (alternative to btop)

    ## HTTP/API tools
    #httpie # user-friendly curl
    #xh # httpie in rust (faster)
    #curlie # curl with httpie UX
    #grpcurl # curl for gRPC
    #oha # HTTP load generator

    ## JSON/YAML/data manipulation
    #jq # JSON processor
    #fx # interactive JSON viewer
    #yq-go # jq for YAML
    #gron # make JSON greppable
    #dasel # query JSON/YAML/TOML/XML

    ## Git enhancements
    ## delta - configured in git.nix
    #tig # git TUI browser
    #gitleaks # scan for secrets
    #gh-dash # GitHub dashboard in terminal

    ## Container/Docker tools
    #dive # explore docker image layers
    #ctop # container top
    #hadolint # Dockerfile linter

    ## Network tools
    #bandwhich # network bandwidth monitor
    #gping # ping with graph
    #dog # modern dig
    #trippy # modern traceroute
    #toxiproxy # chaos engineering for network

    ## File management
    #yazi # terminal file manager

    ## Development productivity
    #just # command runner
    #entr # run commands when files change
    #watchexec # better alternative to entr
    #tokei # code statistics (lines of code)
    #silicon # code screenshots
    #glow # markdown renderer in terminal
    #cheat # cheatsheets for commands
    #hyperfine # command benchmarking

    ## System information
    #fastfetch # system info (fast)
    #pfetch # system info (minimal)
    #nitch # system info (tiny)
    #nvtopPackages.amd # GPU process monitor (AMD)

    ## Document conversion
    #pandoc # universal document converter
  ];
}
