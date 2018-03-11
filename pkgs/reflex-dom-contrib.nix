{ mkDerivation, aeson, base, base64-bytestring, bifunctors, bytestring
, containers, data-default, exception-transformers, ghcjs-dom, http-types
, jsaddle, lens, mtl, random, readable, ref-tf, reflex, reflex-dom-core, safe
, stm, string-conv, text, time, transformers, uri-bytestring
, fetchFromGitHub, stdenv
}:
mkDerivation {
  pname = "reflex-dom-contrib";
  version = "0.5.1.0";
  src = fetchFromGitHub {
    owner = "reflex-frp";
    repo = "reflex-dom-contrib";
    rev = "d3c837705ce91c0f08801c28b2355e6cf131d40e";
    sha256 = "152cr0gnfqyhflpf7mc79jihsm02xydy913hr99qvjp67b917x50";
  };
  
  libraryHaskellDepends = [
    aeson base base64-bytestring
    bifunctors bytestring containers data-default
    exception-transformers ghcjs-dom http-types jsaddle lens
    mtl random readable ref-tf reflex reflex-dom-core safe stm
    string-conv text time transformers uri-bytestring
  ];
            
  license = stdenv.lib.licenses.bsd3;
}
