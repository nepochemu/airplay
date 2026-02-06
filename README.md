# airplay-cli

Provides a human‑friendly CLI to route AirPlay audio over Wi‑Fi to devices on PipeWire or PulseAudio. Existing tools
  are too complex and unreliable for casual use, so this is a simpler, more stable alternative.

## Requirements

- PipeWire: `pipewire` (for `pw-dump`) and `wireplumber` (for `wpctl`)
- PulseAudio: `pulseaudio` (for `pactl`)
- `pulseaudio` is also used on PipeWire to move existing streams and load RAOP discovery
- Avahi running so RAOP devices are discoverable

## Usage

```bash
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

## Nix Setup

See `NIX_README.md` for Nix installation, Home Manager autostart, and NixOS setup.

## Help

```bash
./airplay --help
./airplay list --help
./airplay connect --help
```

## Notes

- `connect` sets the default sink via `wpctl`. Existing streams move automatically only if `pactl` is available.
- Saved default now follows the sink name (stable) instead of numeric id.
- `ensure-raop` loads `module-raop-discover`, which exposes AirPlay devices as sinks.
- `selftest` checks for required tools and basic PipeWire/WirePlumber connectivity.
- `diagnose` prints detailed service and RAOP discovery info.

