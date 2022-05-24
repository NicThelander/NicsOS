

self: super: {
  vscode-with-extensions = super.vscode-with-extensions.override {
  # enable = true;
  # package = pkgs.vscode;

    vscodeExtensions = (with super.vscode-extensions; [
      streetsidesoftware.code-spell-checker
      haskell.haskell
      justusadam.language-haskell
      bbenoist.nix
      # albert.TabOut
    ]);
  };
}

 # userSettings = {
 #   editor = {
 #     fontSize = 16;
 #     fontFamily = "JetBrains Mono";
 #     fontLigatures = true;
 #     minimap.enabled = false;
 #     acceptSuggestionOnEnter = "off";
 #   };
#
   # files = {
  #    autoSave = "onFocusChange";
 #   };
#
   # cSpell = {
  #    language = "en-GB";
 #   };
#
 #   windows.zoomLevel = 1;
#  };

