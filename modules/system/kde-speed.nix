{ lib, ... }:

# ============================================================================
# KDE Plasma slowness fix (nixpkgs #126590)
#
# NixOS sets XDG_DATA_DIRS to one /nix/store/share dir per KDE dependency
# (~90 unique paths on this machine). KWin/plasmashell stat() every path for
# every theme/resource lookup, causing ~260k failed statx syscalls and the
# visible menu/panel/popup lag vs other distros (which use 1-2 paths).
#
# This overlay (from the linked issue comment) replaces that giant
# XDG_DATA_DIRS in the plasma-workspace Qt wrappers with a SINGLE directory
# that merges all of the individual share dirs, so lookups hit on path #1.
#
# Caveat: overrides plasma-workspace, so it is recompiled from source on
# every nixpkgs update (~10 min).
#   https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
# ============================================================================
{
  nixpkgs.overlays = lib.singleton (final: prev: {
    kdePackages = prev.kdePackages // {
      plasma-workspace = let
        # the package we want to override
        basePkg = prev.kdePackages.plasma-workspace;

        # a helper package that merges all the XDG_DATA_DIRS into a single directory
        xdgdataPkg = final.stdenv.mkDerivation {
          name = "${basePkg.name}-xdgdata";
          buildInputs = [ basePkg ];
          dontUnpack = true;
          dontFixup = true;
          dontWrapQtApps = true;
          installPhase = ''
            mkdir -p $out/share
            ( IFS=:
              for DIR in $XDG_DATA_DIRS; do
                if [[ -d "$DIR" ]]; then
                  cp -r $DIR/. $out/share/
                  chmod -R u+w $out/share
                fi
              done
            )
          '';
        };

        # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
        # script and instead inject the path of the above helper package
        derivedPkg = basePkg.overrideAttrs {
          preFixup = ''
            for index in "''${!qtWrapperArgs[@]}"; do
              if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                unset -v "qtWrapperArgs[$((index+0))]"
                unset -v "qtWrapperArgs[$((index+1))]"
                unset -v "qtWrapperArgs[$((index+2))]"
                unset -v "qtWrapperArgs[$((index+3))]"
              fi
            done
            qtWrapperArgs=("''${qtWrapperArgs[@]}")
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
          '';
        };
      in derivedPkg;
    };
  });
}