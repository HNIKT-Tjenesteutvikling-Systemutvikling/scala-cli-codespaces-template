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
          overlays = [
            (f: p: {
              scala-cli = p.scala-cli.override { jre = p.graalvm-ce; };
            })
          ];

          inherit system;
        };

        jdk = pkgs.graalvm-ce;

        # For future selenium tests 

        jvmInputs = with pkgs; [
          jdk
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

