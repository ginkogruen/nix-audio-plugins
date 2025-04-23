{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nix-audio-plugins;
in {
  options.nix-audio-plugins = {
    enable = mkEnableOption "Enable Zebralette3 plugin linking";
  };

  config = mkIf cfg.enable {
    home.activation.nix-audio-plugins-symlinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Linking Zebralette3 to plugin paths..."

      mkdir -p ~/.vst3/u-he
      cp -r ${/*self.packages."x86_64-linux".zebralette3-beta*/}/lib/vst3/u-he/Zebralette3.vst3 ~/.vst3/u-he/Zebralette3.vst3
      chmod -R 775 ~/.vst3/u-he/Zebralette3.vst3

      mkdir -p ~/.clap/u-he
      cp -r ${/*self.packages."x86_64-linux".zebralette3-beta*/}/lib/clap/u-he/Zebralette3.clap ~/.clap/u-he/Zebralette3.clap
      chmod -R 775 ~/.clap/u-he/Zebralette3.clap

      mkdir -p ~/.u-he
      cp -r ${/*self.packages."x86_64-linux".zebralette3-beta*/}/share/Zebralette3 ~/.u-he/Zebralette3
      chmod -R 775 ~/.u-he
    '';
  };
}
