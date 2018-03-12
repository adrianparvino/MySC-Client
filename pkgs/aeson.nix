{ mkDerivation, attoparsec, base, base-compat, base-orphans
, base16-bytestring, bytestring, containers, deepseq, directory
, dlist, filepath, generic-deriving, ghc-prim, hashable
, hashable-time, HUnit, integer-logarithms, QuickCheck
, quickcheck-instances, scientific, stdenv, tagged
, template-haskell, test-framework, test-framework-hunit
, test-framework-quickcheck2, text, time, time-locale-compat
, unordered-containers, uuid-types, vector
}:
mkDerivation {
  pname = "aeson";
  version = "1.1.1.0";
  sha256 = "083791ed61fd5d2ce613ba9d54dd37e598a376fab63c9df0abfaa69e802272d6";
  revision = "2";
  editedCabalFile = "110y578mymc373lh674xdy68h7zq55q1njmpblgyg43rh3w21g0h";
  libraryHaskellDepends = [
    attoparsec base base-compat bytestring containers deepseq dlist
    ghc-prim hashable scientific tagged template-haskell text time
    time-locale-compat unordered-containers uuid-types vector
  ];
  testHaskellDepends = [
    attoparsec base base-compat base-orphans base16-bytestring
    bytestring containers directory dlist filepath generic-deriving
    ghc-prim hashable hashable-time HUnit integer-logarithms QuickCheck
    quickcheck-instances scientific tagged template-haskell
    test-framework test-framework-hunit test-framework-quickcheck2 text
    time time-locale-compat unordered-containers uuid-types vector
  ];
  homepage = "https://github.com/bos/aeson";
  description = "Fast JSON parsing and encoding";
  license = stdenv.lib.licenses.bsd3;
}
