with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [ zlib gcc49 ];
}
