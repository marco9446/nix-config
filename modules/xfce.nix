{ ... }: {

  services = {

    xserver = {
      enable = true;
      # Enable the XFCE Desktop Environment.
      desktopManager.xfce.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:backspace";
      };
      displayManager.lightdm.enable = true;
      monitorSection = "DisplaySize 344 215";
    };

  };

  programs = {
    xfconf.enable = true;
  };

}
