{ proxmoxInfo, ... }:

let
  webUiPort = 80;
  dnsPort = 53;
  containerIP = proxmoxInfo."lxc-adguard".ip;
  gatewayIP = "192.168.188.1";
in
{
  imports = [
    ../../modules/defaultPveLxcConfig.nix
  ];
  networking.hostName = "lxc-adguard";
  # (Firewall) Allow DNS through on both TCP and UDP
  networking.firewall.allowedTCPPorts = [ dnsPort ];
  networking.firewall.allowedUDPPorts = [ dnsPort ];

  # AdGuard options reference: https://search.nixos.org/options?channel=unstable&query=adguard
  services.adguardhome = {
    enable = true;
    # When false, Nix manages the full config (declarative). When true, AdGuard
    # may edit its settings on disk (not recommended for Nix-managed hosts).
    mutableSettings = false;
    allowDHCP = false;
    # Dashboard port (see webUiPort). The `http.address` below binds to loopback
    # so the UI isn't exposed to the LAN unless you change it.
    port = webUiPort;
    # Let the NixOS module open the firewall for the web UI.
    openFirewall = true;
    # All settings liste here https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
    settings = {
      theme = "auto";
      # `users` is a list of {name, passwordHash}. Empty list disables auth.
      users = [
        { name = "user"; password = "$2a$12$9jnM8p2viBoUsD0AXTtknOf8lE8cMmFjLGCAv/nzYifmWzBv/Q1FC"; }
      ];
      http = {
        # Bind UI to loopback by default for safety. Change to containerIP to
        # expose the UI on the LAN (not recommended without auth/firewall).
        address = "127.0.0.1:${webUiPort}";
      };
      dns = {
        upstream_dns = [
          "https://dns.quad9.net/dns-query"
          "tls://dns.quad9.net"
          "[/fritz.box/]192.168.188.1"
        ];
        anonymize_client_ip = false;
        upstream_mode = "parallel"; # query multiple upstreams at once
        bind_hosts = [ "127.0.0.1" containerIP ]; # interfaces AdGuard listens on
        port = dnsPort;
        bootstrap_dns = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
        # Used when resolving local PTRs — forward to your router if needed.
        local_ptr_upstreams = [ gatewayIP ];
        ratelimit = 0;
        edns_client_subnet = { enabled = false; };
        enable_dnssec = true;
      };
      filtering = {
        filters_update_interval = 12; # hours between filter updates
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false; # Parental control features
        safe_search = {
          enabled = false; # Enforce safe search on search engines
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
      # Using `map` wraps each filter URL into {enabled = true; url = ...}
      filters = map (url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_31.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_45.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_54.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt"
        "https://v.firebog.net/hosts/Easyprivacy.txt"
        "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
      ];

      whitelist_filters = map (url: { enabled = true; url = url; }) [
        "https://badblock.celenity.dev/abp/whitelist.txt"
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/whitelist-urlshortener.txt"
      ];

      querylog = { enabled = true; interval = "24h"; };

      # Custom filtering rules.
      user_rules = [
        "||adservice.google.*^$important"
        "||adsterra.com^$important"
        "||amplitude.com^$important"
        "||analytics.edgekey.net^$important"
        "||analytics.twitter.com^$important"
        "||app.adjust.*^$important"
        "||app.*.adjust.com^$important"
        "||app.appsflyer.com^$important"
        "||doubleclick.net^$important"
        "||googleadservices.com^$important"
        "||guce.advertising.com^$important"
        "||metric.gstatic.com^$important"
        "||mmstat.com^$important"
        "||statcounter.com^$important"
      ];
    };
  };

}
