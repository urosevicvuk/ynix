{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 4096;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 8192;
      };
    };

    wireplumber = {
      enable = true;
      extraConfig = {
        #no-ucm = {
        #  "monitor.alsa.properties" = {
        #    "alsa.use-ucm" = false;
        #  };
        #};
      };
    };
  };
}
