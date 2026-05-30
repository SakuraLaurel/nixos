let
  proxyUrl = "http://127.0.0.1:7890";
  proxyEnv = ''http_proxy="${proxyUrl}" https_proxy="${proxyUrl}"'';

  shellAliases = {
    flake-update = "nix flake update --flake $HOME/nixos";

    flatpak-update = "flatpak update";

    nrs = "sudo nixos-rebuild switch --flake $HOME/nixos#laurel";

    ncg = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake $HOME/nixos";

    wget-mmdb = "wget -P $HOME/.config/mihomo/ https://hub.keccak.top/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb";

    proxy-on = "export ${proxyEnv}";

    proxy-off = "unset http_proxy https_proxy";

    proxy-chrome = "${proxyEnv} google-chrome";
};
in
{
  environment.shellAliases = shellAliases;
  programs.bash.interactiveShellInit = ''
    update-mihomo() {
      CONFIG="$HOME/.config/mihomo/config.yaml"
      curl -L "$(cat "$HOME/nixos/clash-subscribe")" -o "$CONFIG"
      sed -i '/^[[:space:]]*external-ui[[:space:]]*:/d; /^[[:space:]]*external-controller[[:space:]]*:/a external-ui: ui' "$CONFIG"
    }

    global-mihomo(){
      curl -X PATCH http://127.0.0.1:9090/configs \
        -H 'Content-Type: application/json' \
        -d '{"mode":"global"}'
    }

    rule-mihomo(){
      curl -X PATCH http://127.0.0.1:9090/configs \
        -H 'Content-Type: application/json' \
        -d '{"mode":"rule"}'
    }
  '';
}
