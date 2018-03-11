{ mkDerivation, ansi-terminal, base, cmdargs, containers, cpphs
, directory, extra, filepath, haskell-src-exts, hscolour, process
, refact, stdenv, transformers, uniplate
}:
mkDerivation {
  pname = "hlint";
  version = "1.9.41";
  sha256 = "1d1z14gfls87jgq0bm67aq81xmczhlbzjym60qplpx1ajpvrk4id";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    ansi-terminal base cmdargs containers cpphs directory extra
    filepath haskell-src-exts hscolour process refact transformers
    uniplate
  ];
  executableHaskellDepends = [ base ];
  homepage = "https://github.com/ndmitchell/hlint#readme";
  description = "Source code suggestions";
  license = stdenv.lib.licenses.bsd3;
}
