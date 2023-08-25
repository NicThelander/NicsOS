# my config for neovim

{ config, pkgs, ... }:
let
  unstable = import
  (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
  { config = config.nixpkgs.config; };
  


in
{
  enable = true;
  vimAlias = true;
  defaultEditor = true;
  

  # stuff that normally goes in init.vim etc
  # to take advantage of nvim lua stuff, you can do something like create a settings.lua and then add it like:
  # luafile $NIXOS_CONFIG_DIR/config/nvim/settings.lua
  # where NIXOS_CONFIG_DIR is your system variable for the location (mine is currently at ~/config for testing purposes)
  configure = {
    # my nvim settings, for some reason these only work when opening things with vim and vimalias... Weird shit.
    # The FocusLost saves on focus change
    
    # the defer function is to make them load asyncronously for faster builds
    # only have NvimTreeToggle in there for now to launch on start, the
    # auto start feature was having issues.

    # old vals for customrRC:
    # luafile /etc/nixos/config/nvim/lua/bufferline.lua
    # luafile /etc/nixos/config/nvim/lua/galaxyline.lua
    # source /etc/nixos/config/nvim/colors/dusk.vim
    # luafile /etc/nixos/config/nvim/lua/treesitter.lua
  customRC = ''
      luafile /etc/nixos/config/nvim/lua/settings.lua
      luafile /etc/nixos/config/nvim/lua/toggleterm.lua
      luafile /etc/nixos/config/nvim/lua/lsp.lua
      luafile /etc/nixos/config/nvim/lua/lualine.lua
      luafile /etc/nixos/config/nvim/lua/nvim-tree.lua

      lua << EOF
      vim.defer_fn(function()
        vim.cmd [[
          luafile /etc/nixos/config/nvim/lua/telescope.lua
        ]]
      end, 10)
      EOF
      
      colorscheme onehalfdark
      au FocusLost * :wa
    '';
    packages.myVimPackage = with pkgs.unstable.vimPlugins; {

      start = [
        # ALWAYS LOOK FOR LUA AND NVIM OPTIONS FOR SPEED
            # git related
            # fugitive

            # visual related
            # indentLine
            indent-blankline-nvim
            lualine-nvim
              # bufferline-nvim
              # galaxyline-nvim

            # prettier make things
            nvim-treesitter
            onehalf

            # file mangement
            # vim-automkdir

            # utils
            nvim-tree-lua
            nvim-web-devicons
            toggleterm-nvim
            nvim-autopairs

            # LSP
            nvim-lspconfig
            nvim-compe
            # lsp-rooter-nvim # need to work on integrating this

            # syntax related
            vim-nix

            # telescope
            popup-nvim
            plenary-nvim
            telescope-nvim
        ];

	opt = [
       
    ];

      };
  };
}
