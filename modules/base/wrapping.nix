{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.base.wrapping;
  mkEnableOptionTrue = a: mkEnableOption a // { default = true; };
in {
  options.base.wrapping = {
    enable = mkEnableOption "wrapping configuration";

    wrap = mkEnableOptionTrue "wrapping too long lines";
    smart-moving = mkEnableOptionTrue
      "augmenting j, k, 0 & $ to work intuitively on wrapped lines                                      ";
  };

  config = mkIf cfg.enable {
    output.config_file = ''
      set ${if cfg.wrap then "wrap" else "nowrap"}
      ${optionalString cfg.smart-moving ''
        nnoremap j gj
        nnoremap k gk
        nnoremap 0 g0
        nnoremap $ g$
      ''}
    '';
  };
}