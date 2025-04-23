{
  stdenv,
  lib,
  fetchurl,
  glib,
  cairo,
  freetype,
  xorg,
  zlib,
  rocmPackages,
  gtk3,
  xdg-user-dirs,
  autoPatchelfHook,
}: let
in
  stdenv.mkDerivation rec {
    pname = "zebralette-3-beta";
    version = "17567";

    src = fetchurl {
      url = "https://dl.u-he.com/betas/public/zebralette3/Zebralette3_001_public_beta_17567_Linux.tar.xz";
      sha256 = "sha256-vlxk2a9ceaYs4Kjazln4nCkvwn+3zEDK219m0OmSdF4=";
    };

    sourceRoot = "Zebralette3-17567/Zebralette3";

    nativeBuildInputs = [autoPatchelfHook];

    buildInputs = [
      glib
      cairo
      freetype
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilkeysyms
      zlib

      rocmPackages.clang
      xorg.libXau
      xorg.libXdmcp
      gtk3
      xdg-user-dirs
    ];

    installPhase = ''
      runHook preInstall

      # Define plugin name and paths
      product="Zebralette3"

      # Patch .so file
      #patchelf --set-rpath $rpath "${lib.makeLibraryPath buildInputs}" $product.64.so

      # Install the .so into a proper VST3 bundle structure
      mkdir -p $out/lib/vst3/u-he/$product.vst3/Contents/x86_64-linux
      cp $product.64.so $out/lib/vst3/u-he/$product.vst3/Contents/x86_64-linux/$product.64.so

      # Install CLAP plugin
      mkdir -p $out/lib/clap/u-he
      cp $product.64.so $out/lib/clap/u-he/$product.clap

      # Install documentation
      mkdir -p $out/share/doc/$product
      cp *.pdf $out/share/doc/$product/

      # Install presets and assets (graphics, themes, etc.)
      mkdir -p $out/share/$product
      cp -r Presets $out/share/$product/
      cp -r Support $out/share/$product/ || true  # optional
      cp -r Data $out/share/$product/ || true   # optional

      # Testing directory (remove later)
      mkdir -p $out/test
      cp $product.64.so $out/test/$product.64.so

      runHook postInstall
    '';

    meta = with lib; {
      description = "U-he Zebralette 3 synth plugin (VST3/CLAP)";
    };

    dontConfigure = true;
    dontBuild = true;
  }
