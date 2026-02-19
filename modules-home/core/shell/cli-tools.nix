{pkgs, ...}: {
  home.packages = with pkgs; [
    # Modern replacements for classic tools
    fd # modern find
    sd # modern sed
    dust # modern du
    duf # modern df (disk usage)
    procs # modern ps
    bottom # modern top (alternative to btop)

    # HTTP/API tools
    xh # httpie in rust
    oha # HTTP load generator

    # JSON/YAML/data manipulation
    jq # JSON processor
    fx # interactive JSON viewer
    yq-go # jq for YAML

    # Git enhancements
    tig # git TUI browser
    gitleaks # scan for secrets
    gh-dash # GitHub dashboard in terminal

    # Container/Docker tools
    dive # explore docker image layers
    ctop # container top

    # Network tools
    bandwhich # network bandwidth monitor
    gping # ping with graph
    dog # modern dig
    trippy # modern traceroute

    # File management
    yazi # terminal file manager

    # Development productivity
    just # command runner
    watchexec # run commands when files change
    tokei # code statistics (lines of code)
    cheat # cheatsheets for commands
    hyperfine # command benchmarking

    # System information
    fastfetch # system info
    nvtopPackages.amd # GPU process monitor (AMD)
  ];
}
