{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libprojectm,
  libGL,
  libX11,
  poco,
  utf8proc,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "projectm-sdl-cpp";
  version = "0-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "frontend-sdl-cpp";
    rev = "85dfdda3dcb139c7e1eb47fd5e4723114e4fb86b";
    hash = "sha256-FHOncC6fhs1CPNMBGtA+QB+NHVn4QlF2Qn9NJb5j3p8=";
    fetchSubmodules = true;
  };

  # Probably an artifact of the vcpkg package
  postPatch = ''
    substituteInPlace ImGui.cmake \
      --replace-fail "SDL2::SDL2main" ""
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "SDL2::SDL2main" ""
  '';

  cmakeFlags = [
    # Doesn't seem to be present in the source tree, so the installation fails if enabled
    (lib.cmakeBool "ENABLE_DESKTOP_ICON" false)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libprojectm
    poco
    utf8proc
    libGL
    libX11
    SDL2
  ];

  # poco 1.14 requires c++17
  NIX_CFLAGS_COMPILE = [ "-std=gnu++17" ];

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Standalone application based on libprojectM and libSDL that turns your desktop audio into awesome visuals";
    homepage = "https://github.com/projectM-visualizer/frontend-sdl-cpp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "projectMSDL";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # TODO build probably needs some fixing
  };
}
