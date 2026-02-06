# Airplay CLI – User Notes

This is the simple, stable workflow for your setup.

## Daily Use

```bash
airplay list
airplay connect HiFiBerry
airplay status
```

The autoconnect service runs on login and does `airplay connect` for your saved default.

## Update the CLI

```bash
cd ~/dev/airplay-cli
git pull
nix profile upgrade airplay
```

## Update the System (NixOS + Home Manager)

```bash
nixswitch
```

## Verify

```bash
airplay version
systemctl --user status airplay-autoconnect.service
```

## Notes

- AirPlay discovery depends on `module-raop-discover`. If sinks disappear after a restart:
  ```bash
  airplay list --ensure
  ```
- If a receiver is AirPlay 2 only, Linux RAOP (AirPlay 1) may not work even if it appears in the list.

