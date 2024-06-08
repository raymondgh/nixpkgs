{ lib
, copyDesktopItems
, fetchFromGitHub
, makeDesktopItem
, python3
, libsForQt5
}:

python3.pkgs.buildPythonApplication rec {
  pname = "onthespot";
  version = "0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "onthespot";
    rev = "refs/tags/v${version}";
    hash = "sha256-VaJBNsT7uNOGY43GnzhUqDQNiPoFZcc2UaIfOKgkufg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    copyDesktopItems
    pythonRelaxDepsHook
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    charset-normalizer
    defusedxml
    librespot
    music-tag
    packaging
    pillow
    protobuf
    pyqt5
    pyqt5-sip
    pyxdg
    requests
    setuptools
    show-in-file-manager
    urllib3
    zeroconf
  ];

  pythonRemoveDeps = [
    "PyQt5-Qt5"
    "PyQt5-stubs"
    # Doesn't seem to be used in the sources and causes
    # build issues
    "PyOgg"
  ];

  pythonRelaxDeps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = " QT based Spotify music downloader written in Python";
    homepage = "https://github.com/casualsnek/onthespot";
    changelog = "https://github.com/casualsnek/onthespot/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
