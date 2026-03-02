{...}: {
  # keyd - keyboard remapping daemon
  # Handles all keyboard remapping at system level
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            # Caps Lock acts as Escape when tapped, Control when held
            capslock = "overload(control, esc)";

            # Enter acts as Control when held, Enter when tapped
            enter = "overload(control, enter)";

            leftalt = "leftmeta";
            leftmeta = "leftalt";
          };

          # Tapping both shift keys together activates capslock
          shift = {
            leftshift = "capslock";
            rightshift = "capslock";
          };
        };
      };
    };
  };
}
