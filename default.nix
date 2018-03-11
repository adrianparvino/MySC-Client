{ pkgs ? import <nixpkgs> {config = (import ./config.nix) pkgs compiler;}
, compiler ? "ghcjsHEAD", runCompiler ? true
}:
let
in pkgs.haskellPackages.mkDerivation {
  pname = "heroku-comment-server";
  version = "0.1.0.0";
  src = ./.;

  executableHaskellDepends = with pkgs.haskellPackages; [
    reflex reflex-dom safe
  ];

  buildTools = pkgs.stdenv.lib.optional runCompiler [pkgs.closurecompiler];
  
#   postInstall =
#     (if runCompiler
#     then "closure-compiler -O ADVANCED --js $out/bin/CellGame.jsexe/all.js --js_output_file $out/all.min.js"
#     else "cp $out/bin/CellGame.jsexe/all.js $out/all.min.js") + "\n" +
#     ''
#       cp ${./static}/* -r $out
#       echo "<html> <head> <script src=\"all.min.js\"></script> </head> </html>" > $out/index.html
#       rm -r $out/bin
#     '';

  license = pkgs.stdenv.lib.licenses.gpl3;

  isExecutable = true;
}
