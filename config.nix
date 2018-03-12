nixpkgs: compiler: {
  packageOverrides = pkgs: rec {
    webkitgtk = pkgs.webkitgtk216x;  
    haskellPackages = pkgs.haskell.packages.${compiler}.override {
      overrides = self: super: {
        hlint = self.callPackage ./pkgs/hlint.nix {};
        jsaddle = self.callPackage ./pkgs/jsaddle.nix {};
        text = self.callPackage ./pkgs/text.nix {};
        aeson = self.callPackage ./pkgs/aeson.nix {};
        reflex-dom-contrib = self.callPackage ./pkgs/reflex-dom-contrib.nix {};

        reflex-bulma = self.callPackage /home/myrl/Development/reflex-bulma {};
        reflex = self.callPackage (pkgs.fetchFromGitHub {
          owner = "reflex-frp";
          repo = "reflex";
          rev = "908348b4799caec260e083568bace846d7fe5d80";
          sha256 = "13r7sk0xj0nnzwpmdqgp5ny93pdqq3d3h9w3mj84aiy5xhiakjvm";
        }) {};
      } // (import (pkgs.fetchFromGitHub {
          owner = "reflex-frp";
          repo = "reflex-dom";
          rev = "d7b859bccd0d9c57bd9635de75b3ca9d2ca79568";
          sha256 = "11ljk6hpsqw0as2iaa5m3pbb4qfgz8bzdgs64c2ld1cfp09wyz2s";
      }) self nixpkgs);
    };
  };
}
