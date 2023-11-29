{
  description = "kvalreg-etl-rapporteket";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (f: p: {
              sbt = p.sbt.override { jre = p.jdk17_headless; };
            })
          ];
        };
        jdk = pkgs.jdk17_headless;

        # For future selenium tests 

        jvmInputs = with pkgs; [
          jdk
          coursier
          sbt
          scalafmt
          scala-cli
        ];

        
        jvmHook = ''
          JAVA_HOME="${jdk}"
        '';


      in
      {
        devShells.default = pkgs.mkShell {
          name = "kvalreg-etl-rapporteket-dev-shell";
          buildInputs = jvmInputs;
          shellHook = jvmHook;
        };
      }
    );

}

