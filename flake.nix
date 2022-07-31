# adapted from https://gitlab.com/scvalex/sixty-two/-/blob/flake-blogpost/flake.nix
{
  inputs = {
    naersk.url = "github:nmattia/naersk/master";
    # This must be the stable nixpkgs if you're running the app on a
    # stable NixOS install.  Mixing EGL library versions doesn't work.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    naersk,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      naersk-lib = pkgs.callPackage naersk {};
    in {
      devShell = with pkgs;
        mkShell {
          buildInputs = [
            elmPackages.elm
            elmPackages.elm-format
            elmPackages.elm-language-server

            # For Tauri
            pkgconfig
            openssl
            sass
            glib
            cairo
            pango
            atk
            gdk-pixbuf
            libsoup
            gtk3
            dbus
            webkitgtk
            librsvg
            patchelf
          ];
        };
    });
}
