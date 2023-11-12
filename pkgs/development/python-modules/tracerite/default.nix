{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, html5tagger
, python
}:

buildPythonPackage rec {
  pname = "tracerite";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    rev = "refs/tags/v${version}";
    hash = "sha256-rI1MNdYl/P64tUHyB3qV9gfLbGbCVOXnEFoqFTkaqgg=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    html5tagger
  ];

  postInstall = ''
    cp tracerite/style.css $out/${python.sitePackages}/tracerite
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "tracerite"
  ];

  meta = with lib; {
    description = "Tracebacks for Humans (in Jupyter notebooks";
    homepage = "https://github.com/sanic-org/tracerite";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
  };
}
