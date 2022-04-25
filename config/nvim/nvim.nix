# my config for neovim

pkgs:

{
  enable = true;
  vimAlias = true;

  # stuff that normally goes in init.vim etc
  # to take advantage of nvim lua stuff, you can do something like create a settings.lua and then add it like:
  # luafile $NIXOS_CONFIG_DIR/config/nvim/settings.lua
  # where NIXOS_CONFIG_DIR is your system variable for the location (mine is currently at ~/config for testing purposes)

  configure = {
    # my nvim settings, for some reason these only work when opening things with vim and vimalias... Weird shit.
    # The FocusLost saves on focus change
    customRC = ''
      luafile /etc/nixos/config/nvim/lua/settings.lua
      au FocusLost * :wa
    '';
    packages.nix.start = with pkgs.vimPlugins; [
    ];
  };
}
