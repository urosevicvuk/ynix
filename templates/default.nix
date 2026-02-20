{...}: {
  flake.templates = {
    go = {
      path = ./go;
      description = "Go CLI/service with devShell, packaging, and container image";
    };
    web = {
      path = ./web;
      description = "Node.js/pnpm web app with devShell, packaging, and container image";
    };
    python = {
      path = ./python;
      description = "Python project with devShell and packaging";
    };
  };
}
