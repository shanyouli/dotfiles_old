{
  pkgs,
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.my; let
  cfg = config.my.modules.nginx;
in {
  options.my.modules.nginx = {
    enable = mkBoolOpt false;
    workDir = mkStrOpt "/etc/nginx";
    sScript = mkStrOpt "";
    uScript = mkStrOpt "";
  };

  config = mkIf cfg.enable {
    my.user.packages = [pkgs.stable.nginx];
    my.modules.nginx = {
      sScript = ''
        [[ -d ${cfg.workDir} ]] || {
           mkdir -p ${cfg.workDir}
           chown -R ${config.my.username} ${cfg.workDir}
        }
      '';
      uScript = ''
        for i in "conf" "logs" "www" "conf.d" ; do
          [[ -d ${cfg.workDir}/$i ]] || mkdir -p ${cfg.workDir}/$i
        done
        ln -sf ${pkgs.stable.nginx.out}/conf/mime.types ${cfg.workDir}/conf
        [[ -f ${configDir}/nginx/nginx.conf ]] && {
          if [[ -e ${cfg.workDir}/conf/nginx.conf ]] && [[ ! -h ${cfg.workDir}/conf/nginx.conf ]]; then
            mv ${cfg.workDir}/conf/nginx.conf ${cfg.workDir}/conf/nginx.conf.backup
          fi
          ln -sf ${configDir}/nginx/nginx.conf ${cfg.workDir}/conf/nginx.conf
        }
      '';
    };
    my.modules.zsh.aliases.nginx = "nginx -p ${cfg.workDir} -e logs/error.log -c conf/nginx.conf";
  };
}