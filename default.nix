{ pkgs ? import <nixpkgs> {config = (import ./config.nix);}
, haskellPackages
, runCompiler ? true
}:
let
in haskellPackages.mkDerivation {
  pname = "mysc-client";
  version = "0.1.0.0";
  src = ./.;

  executableHaskellDepends = with haskellPackages; [
    reflex reflex-dom reflex-bulma safe clay ghcjs-dom-jsffi
    mysc-common
  ];

  buildTools = pkgs.stdenv.lib.optional runCompiler [pkgs.closurecompiler];
  
  postInstall =
    (if runCompiler
    then "closure-compiler --jscomp_off=checkVars -O ADVANCED --js $out/bin/mysc-client.jsexe/all.js --js_output_file $out/all.min.js"
    else "cp $out/bin/mysc-client.jsexe/all.js $out/all.min.js") + "\n" +
    ''
      cp ${./static}/. -r $out
      rm -r $out/bin
    '';

  license = pkgs.stdenv.lib.licenses.gpl3;

  isExecutable = true;
}
