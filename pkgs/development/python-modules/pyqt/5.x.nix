{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, pkg-config
, dbus
, lndir
, dbus-python
, sip
, pyqt5_sip
, pyqt-builder
, libsForQt5
, withConnectivity ? false
, withMultimedia ? false
, withWebKit ? false
, withWebSockets ? false
, withLocation ? false
}:

buildPythonPackage rec {
  pname = "PyQt5";
  version = "5.15.4";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gp5jz71nmg58zsm1h4vzhcphf36rbz37qgsfnzal76i1mz5js9a";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = with libsForQt5; [
    pkg-config
    qmake
    lndir
    sip
    qtbase
    qtsvg
    qtdeclarative
    qtwebchannel
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withMultimedia qtmultimedia
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation
  ;

  buildInputs = with libsForQt5; [
    dbus
    qtbase
    qtsvg
    qtdeclarative
    pyqt-builder
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation
  ;

  propagatedBuildInputs = [
    dbus-python
    pyqt5_sip
  ];

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    ./pyqt5-fix-dbus-mainloop-support.patch
  ];

  passthru = {
    inherit sip pyqt5_sip;
    multimediaEnabled = withMultimedia;
    webKitEnabled = withWebKit;
    WebSocketsEnabled = withWebSockets;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [
    "PyQt5"
    "PyQt5.QtCore"
    "PyQt5.QtQml"
    "PyQt5.QtWidgets"
    "PyQt5.QtGui"
  ]
    ++ lib.optional withWebSockets "PyQt5.QtWebSockets"
    ++ lib.optional withWebKit "PyQt5.QtWebKit"
    ++ lib.optional withMultimedia "PyQt5.QtMultimedia"
    ++ lib.optional withConnectivity "PyQt5.QtConnectivity"
    ++ lib.optional withLocation "PyQt5.QtPositioning"
  ;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
