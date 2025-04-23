{
  config,
  lib,
  plugin,
  ...
}: {
  options.audio-plugins.zebralette3-beta = {
    enable = lib.mkEnableOption "Enable Zebralette3 plugin linking";
  };

  config = lib.mkIf config.programs.zebralette.enable {
    home.activation.zebralette3-beta-symlinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Linking Zebralette3 to plugin paths..."

      mkdir -p ~/.vst3/u-he
      ln -sf ${plugin.zebralette3-beta}/lib/vst3/u-he/Zebralette3.vst3 ~/.vst3/u-he/Zebralette3.vst3

      mkdir -p ~/.clap/u-he
      ln -sf ${plugin.zebralette3-beta}/lib/clap/u-he/Zebralette3.64.clap ~/.clap/u-he/Zebralette3.64.clap

      mkdir -p ~/.u-he
      ln -sf ${plugin.zebralette3-beta}/share/Zebralette3 ~/.u-he/Zebralette3
    '';
  };
}
