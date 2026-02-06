# airplay-cli

Route system audio to AirPlay (RAOP) devices on PipeWire or PulseAudio (NixOS/Linux).

## Requirements

- PipeWire: `pipewire` (for `pw-dump`) and `wireplumber` (for `wpctl`)
- PulseAudio: `pulseaudio` (for `pactl`)
- `pulseaudio` is also used on PipeWire to move existing streams and load RAOP discovery
- Avahi running (`services.avahi.enable = true;`) so RAOP devices are discoverable
- PipeWire’s PulseAudio server enabled (`services.pipewire.pulse.enable = true;`) if using PipeWire

## Usage

```bash
cd ~/dev/airplay-cli
nix develop
./airplay list
./airplay list --ensure
./airplay list --all
./airplay connect "Living Room"
./airplay connect 52
./airplay connect
./airplay status
./airplay disconnect
./airplay ensure-raop
./airplay selftest
./airplay diagnose
./airplay check
./airplay version
./airplay install-autostart
./airplay uninstall-autostart
```

## Autostart

To auto-connect to your saved default on login:

```bash
./airplay install-autostart
```

To remove it:

```bash
./airplay uninstall-autostart
```

## Home Manager (declarative autostart)

Example using a local checkout so it keeps working even if GitHub is unavailable:

```nix
{
  inputs.airplay.url = "path:/home/airflower/dev/airplay-cli";

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

## Install (Nix)

```bash
# Run without installing
nix run .#airplay -- list

# Install into your profile
nix profile install .#airplay
airplay list
```

## Help

```bash
./airplay --help
./airplay list --help
./airplay connect --help
```

## Notes

- `connect` sets the default sink via `wpctl`. Existing streams move automatically only if `pactl` is available.
- `ensure-raop` loads `module-raop-discover`, which exposes AirPlay devices as sinks.
- `selftest` checks for required tools and basic PipeWire/WirePlumber connectivity.
- `diagnose` prints detailed service and RAOP discovery info.

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
