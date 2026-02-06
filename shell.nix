{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    python3
    pipewire
    wireplumber
    pulseaudio
    avahi
  ];
}
