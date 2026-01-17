{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage {
  pname = "forex-python";
  version = "1.8-unstable-2025-05-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MicroPyramid";
    repo = "forex-python";
    rev = "e64dedc2e33e4710f4ea5f3d744a426ac9171202";
    hash = "sha256-/WtQHhrEwbm4NF0iQcxZGI8NLnTLAOh2TqEVHRgmsS4=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    simplejson
    requests
  ];

  pythonImportsCheck = [
    "forex_python"
  ];

  meta = {
    description = "Foreign exchange rates, Bitcoin price index and currency conversion using ratesapi.io";
    homepage = "http://forex-python.readthedocs.io/en/latest/usage.html";
    downloadPage = "https://github.com/MicroPyramid/forex-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
