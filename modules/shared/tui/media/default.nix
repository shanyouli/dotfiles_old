{
  pkgs,
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.my; let
  cfp = config.modules;
  cfg = cfp.media;
in {
  options.modules.media = {
    enable = mkEnableOption "Whether to use media tools";
    ffmpeg.pkg = mkOpt types.package pkgs.ffmpeg-full;
    stream.enable = mkBoolOpt true;
  };
  config = mkIf cfg.enable {
    user.packages =
      [cfg.ffmpeg.pkg]
      ++ optionals cfg.stream.enable [pkgs.unstable.seam]
      ++ optional (pkgs.stdenvNoCC.isLinux && config.modules.gui.video.mpv.enable) [pkgs.mpvc];
  };
}