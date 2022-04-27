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
    # the defer function is to make them load asyncronously for faster builds
    customRC = ''

      luafile /etc/nixos/config/nvim/lua/lsp.lua
      luafile /etc/nixos/config/nvim/lua/settings.lua
      luafile /etc/nixos/config/nvim/lua/treesitter.lua
      luafile /etc/nixos/config/nvim/lua/galaxyline.lua
      luafile /etc/nixos/config/nvim/lua/bufferline.lua

      lua << EOF
      vim.defer_fn(function()
        vim.cmd [[
      NvimTreeToggle
      ]]
      end, 70)
      EOF
      
      source /etc/nixos/config/nvim/colors/dusk.vim
      au FocusLost * :wa
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {

        start = [
            # git related
            # fugitive

            # visual related
            indentLine
            bufferline-nvim
            galaxyline-nvim

            # prettier make things
            nvim-treesitter

            # utils
	        nvim-tree-lua
            nvim-web-devicons

            # LSP
            nvim-lspconfig
            nvim-compe

            # syntax related
            vim-nix
        ];

	opt = [
       
    ];
	# nvim-web-devicons
	# nvim-tree-lua

        # indentLine

      };
  };
}
