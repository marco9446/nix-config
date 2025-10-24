{ config, lib, ... }:

{
  options = {
    modules.adguard.enable = lib.mkEnableOption "enable adguard home";
  };
  config = lib.mkIf config.modules.adguard.enable {
    # https://search.nixos.org/options?channel=unstable&query=adguard
    services.adguardhome = {
      enable = true;
      # Allow changes made on the AdGuard Home web interface to persist between service restarts.
      mutableSettings = true;
      allowDHCP = false;
      # port for main dashboard
      port = 1000;
      # open firewall for web dashboard not for main dns
      openFirewall = true;
      # All settings liste here https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
      settings = {
        theme = "auto";
        http = {
          # You can select any ip and port, just make sure to open firewalls where needed
          address = "127.0.0.1:1000";
        };
        dns = {
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "quic://unfiltered.adguard-dns.com"
            "[/local/]192.168.0.1:53"
          ];
          bind_hosts = [ "127.0.0.1" ];
          port = 53;
          local_ptr_upstreams = [ "192.168.188.1" ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          parental_enabled = false; # Parental control-based DNS requests filtering.
          safe_search = {
            enabled = false; # Enforcing "Safe search" option for search engines, when possible.
          };
          blocked_services = {
            ids = [
              "activision_blizzard"
              "apple_streaming"
              "battle_net"
              "betano"
              "betfair"
              "betway"
              "bigo_live"
              "bilibili"
              "blaze"
              "blizzard_entertainment"
              "bluesky"
              "canais_globo"
              "claro"
              "deezer"
              "directvgo"
              "discoveryplus"
              "disneyplus"
              "electronic_arts"
              "epic_games"
              "espn"
              "facebook"
              "fifa"
              "hulu"
              "icloud_private_relay"
              "iheartradio"
              "imgur"
              "instagram"
              "iqiyi"
              "kakaotalk"
              "kik"
              "kook"
              "lazada"
              "leagueoflegends"
              "line"
              "lionsgateplus"
              "mail_ru"
              "minecraft"
              "ok"
              "onlyfans"
              "origin"
              "paramountplus"
              "playstation"
              "plenty_of_fish"
              "pluto_tv"
              "qq"
              "rakuten_viki"
              "roblox"
              "rockstar_games"
              "samsung_tv_plus"
              "skype"
              "snapchat"
              "temu"
              "tidal"
              "tiktok"
              "tinder"
              "tumblr"
              "ubisoft"
              "valorant"
              "viber"
              "vk"
              "wechat"
              "weibo"
              "xboxlive"
              "zhihu"
            ];
          };
        };
        # The following notation uses map
        # to not have to manually create {enabled = true; url = "";} for every filter
        # This is, however, fully optional
        filters = map (url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
          "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt"
        ];
      };
    };
  };
}
