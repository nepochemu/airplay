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
./airplay list                    # List AirPlay sinks
./airplay list --ensure           # Load RAOP discovery then list
./airplay list --all              # List AirPlay + non-AirPlay sinks
./airplay connect "Living Room"   # Connect by name
./airplay connect 52              # Connect by id
./airplay connect                 # Connect saved default
./airplay status                  # Show current default sink
./airplay disconnect              # Switch back to non-AirPlay sink
./airplay ensure-raop             # Load module-raop-discover
./airplay selftest                # Check dependencies/connectivity
./airplay diagnose                # Detailed diagnostics
./airplay check                   # Test TCP reachability to sinks
./airplay version                 # Show version and git rev
./airplay install-autostart       # Install autoconnect user service
./airplay uninstall-autostart     # Remove autoconnect user service
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
