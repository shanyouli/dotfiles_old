{
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.my; let
  cfm = config.modules.app;
  cfg = cfm.editor;
in {
  options.modules.app.editor = {
    default = mkOpt types.str "nvim";
  };
  config = mkIf (cfg.default != null) {
    environment.variables.EDITOR = cfg.default;
    modules.app.editor.nvim.enable = mkDefault (cfg.default == "nvim");
    modules.app.editor.helix.enable = mkDefault (cfg.default == "hx");
  };
}