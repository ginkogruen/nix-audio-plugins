{
  fetchurl,
  lib,
  pkgs,
  stdenv,
  makeWrapper,
}: let
in
  stdenv.mkDerivation {
    pname = "zebralette-3-beta";
    version = "17567";

    src = fetchurl {
      url = "https://dl.u-he.com/betas/public/zebralette3/Zebralette3_001_public_beta_17567_Linux.tar.xz";
      sha256 = "sha256-vlxk2a9ceaYs4Kjazln4nCkvwn+3zEDK219m0OmSdF4=";
    };

    sourceRoot = "Zebralette3-17567/Zebralette3";

    nativeBuildInputs = [makeWrapper];

    buildInputs = with pkgs; [
      glib
      cairo
      freetype
      zlib
    ];

    installPhase = ''
      # Define plugin name and paths
      product="Zebralette3"

      # Install the .so into a proper VST3 bundle structure
      mkdir -p $out/lib/vst3/u-he/$product.vst3/Contents/x86_64-linux
      cp $product.64.so $out/lib/vst3/u-he/$product.vst3/Contents/x86_64-linux/$product.so

      # Install CLAP plugin
      mkdir -p $out/lib/clap/u-he
      cp $product.64.so $out/lib/clap/u-he/$product.64.clap

      # Install documentation
      mkdir -p $out/share/doc/$product
      cp *.pdf $out/share/doc/$product/

      # Install presets and assets (graphics, themes, etc.)
      mkdir -p $out/share/$product
      cp -r Presets $out/share/$product/
      cp -r Support $out/share/$product/ || true  # optional
      cp -r Images $out/share/$product/ || true   # optional
    '';

    postInstall = ''
    '';

    meta = with lib; {
      description = "U-he Zebralette 3 synth plugin (VST3/CLAP)";
    };

    dontConfigure = true;
    dontBuild = true;
  }
