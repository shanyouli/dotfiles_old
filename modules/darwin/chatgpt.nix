{
  lib,
  config,
  options,
  my,
  ...
}:
with lib;
with my; let
  cfp = config.modules.macos;
  cfg = cfp.chat;
in {
  options.modules.macos.chat = {
    enable = mkEnableOption "Whether to use chatgpt";
    local.enable = mkBoolOpt cfg.enable;
    nextchat.enable = mkBoolOpt cfg.enable;
    snapbox.enable = mkOption {
      type = types.bool;
      default = cfg.enable;
      apply = v:
        if cfg.local.enable
        then true
        else v;
    };
  };
  config = mkIf cfg.enable {
    homebrew.casks =
      ["shanyouli/tap/cherry-studio"]
      ++ optionals cfg.nextchat.enable ["shanyouli/tap/nextchat"]
      ++ optionals cfg.local.enable ["ollama"]
      ++ optionals cfg.snapbox.enable ["shanyouli/tap/snapbox"];
    home.initExtra = optionalString cfg.local.enable (mkOrder 10000 ''
      print $"Please run \"(ansi green_underline)ollama pull lama3.2(ansi reset)\"."
      print $"more modal, see (ansi u)https://ollama.com/library(ansi reset)"
    '');
  };
}