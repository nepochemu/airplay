{
  description = "airplay-cli";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          airplay = pkgs.stdenvNoCC.mkDerivation {
            pname = "airplay-cli";
            version = "0.1.1";
            src = self;
            nativeBuildInputs = [ pkgs.makeWrapper ];
            dontBuild = true;
            installPhase = ''
              mkdir -p $out/bin
              install -m755 $src/airplay $out/bin/airplay
              wrapProgram $out/bin/airplay \
                --prefix PATH : ${pkgs.python3}/bin \
                --prefix PATH : ${pkgs.pipewire}/bin \
                --prefix PATH : ${pkgs.wireplumber}/bin \
                --prefix PATH : ${pkgs.pulseaudio}/bin \
                --prefix PATH : ${pkgs.avahi}/bin
            '';
          };
          default = self.packages.${system}.airplay;
        });

      apps = forAllSystems (system: {
        airplay = {
          type = "app";
          program = "${self.packages.${system}.airplay}/bin/airplay";
        };
        default = self.apps.${system}.airplay;
      });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              pipewire
              wireplumber
              pulseaudio
              avahi
            ];
          };
        });
    };
}
