# Nix Setup

This file contains all Nix/NixOS/Home Manager setup notes.

## Install (Nix)

```bash
# Run without installing
nix run .#airplay -- list

# Install into your profile
nix profile install .#airplay
airplay list
```

## NixOS quick setup (example)

```nix
{ services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
```

## Home Manager (declarative autostart)

Example using a GitHub input (same style as ytm):

```nix
{
  inputs.airplay.url = "git+ssh://git@github.com/nepochemu/airplay.git";

  outputs = { self, nixpkgs, home-manager, airplay, ... }:
  let
    system = "x86_64-linux";
  in {
    homeConfigurations.airflower = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [{
        home.packages = [ airplay.packages.${system}.airplay ];
        systemd.user.services.airplay-autoconnect = {
          Unit = {
            Description = "AirPlay autoconnect";
            After = [ "pipewire.service" "pipewire-pulse.service" "wireplumber.service" ];
            Wants = [ "pipewire.service" "pipewire-pulse.service" "wireplumber.service" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${airplay.packages.${system}.airplay}/bin/airplay connect";
          };
          Install = { WantedBy = [ "default.target" ]; };
        };
      }];
    };
  };
}
```

## Autostart (imperative alternative)

```bash
./airplay install-autostart
./airplay uninstall-autostart
```

## User Workflow Notes

```bash
airplay list
airplay connect HiFiBerry
airplay status
```

Update CLI:

```bash
cd ~/dev/airplay-cli
git pull
nix profile upgrade airplay
```

Update system:

```bash
nixswitch
```

Verify:

```bash
airplay version
systemctl --user status airplay-autoconnect.service
```

Notes:
- AirPlay discovery depends on `module-raop-discover`. If sinks disappear after a restart:
  ```bash
  airplay list --ensure
  ```
- If a receiver is AirPlay 2 only, Linux RAOP (AirPlay 1) may not work even if it appears in the list.

