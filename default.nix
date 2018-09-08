#
# This file is just a script to setup the environment using Nix and is not needed
# unless you are using Nix in some capacity; For more information see https://nixos.org/nix/ and
# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.md
#
#
# To use, run `nix-shell` from this directory, or `nix-shell default.nix`.
#

with import <nixpkgs> {};
with pkgs.python36Packages;
stdenv.mkDerivation {
  name = "impurePythonEnv";

  buildInputs = [
    glibcLocales # for character support (unicode etc)
    glfw
    portaudio
    zlib

    (python36.buildEnv.override {  
      #
      # these packages are required for virtualenv and pip to work:
      #
      extraLibs = [    
	python36Full
	python36Packages.cffi
	python36Packages.sounddevice
	python36Packages.pip
	python36Packages.pillow
	python36Packages.pyopengl
	python36Packages.virtualenv
      ];
    })
  ];
  shellHook = ''
    # set SOURCE_DATE_EPOCH so that we can use python wheels
    SOURCE_DATE_EPOCH=$(date +%s)
    export LANG=en_US.UTF-8
    virtualenv venv
    source venv/bin/activate
    export LD_LIBRARY_PATH=${glfw}/lib:${portaudio}/lib:$LD_LIBRARY_PATH
    pip install glfw
    python setup.py develop
    export PATH=$PWD/venv/bin:$PATH
    export PYTHONPATH=$PWD
  '';
}


