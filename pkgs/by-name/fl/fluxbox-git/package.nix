{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  freetype,
  fribidi,
  libXext,
  libXft,
  libXpm,
  libXrandr,
  libXrender,
  xorgproto,
  libXinerama,
  imlib2,
}:

stdenv.mkDerivation rec {

  pname = "fluxbox-git";
  version = "20250527";

  src = fetchFromGitHub {
    owner = "fluxbox";
    repo = "fluxbox";
    rev = "78848ebe38e3eec74182bd88e03970ccf588bdcb";
    hash = "sha256-mzEVIq5vHBMnREovxqPbPRD/5AjOuATLgt0okf6Es6Y=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    freetype
    fribidi
    libXext
    libXft
    libXpm
    libXrandr
    libXrender
    xorgproto
    libXinerama
    imlib2
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace util/fluxbox-generate_menu.in \
      --subst-var-by PREFIX "$out"
    automake
  '';

  meta = with lib; {
    description = "Full-featured, light-resource X window manager";
    longDescription = ''
      Fluxbox is a X window manager based on Blackbox 0.61.1 window
      manager sources.  It is very light on resources and easy to
      handle but yet full of features to make an easy, and extremely
      fast, desktop experience. It is written in C++ and licensed
      under MIT license.
    '';
    homepage = "http://fluxbox.org/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
