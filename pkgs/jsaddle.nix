{ mkDerivation, aeson, attoparsec, base, base64-bytestring
, bytestring, containers, deepseq, filepath, ghc-prim, http-types
, lens, primitive, process, random, ref-tf, scientific, stm, text
, time, transformers, unordered-containers, vector
, ghcjs-base, stdenv
}:

mkDerivation {
  pname = "jsaddle";
  version = "0.9.3.0";
  sha256 = "1c96b2zxa8x4p28rxjnj9nz5999d4f8nfwj38yws0h2c3lwsm740";
  libraryHaskellDepends = [
    aeson attoparsec base base64-bytestring bytestring containers
    deepseq filepath ghc-prim http-types lens primitive process random
    ref-tf scientific stm text time transformers unordered-containers
    vector ghcjs-base
  ];
  description = "Interface for JavaScript that works with GHCJS and GHC";
  license = stdenv.lib.licenses.mit;

  doCheck = false;
}
