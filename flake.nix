{
  description = "Deluge";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

    delugesource.url = "git://deluge-torrent.org/deluge.git?ref=master";
    delugesource.flake = false;
  };

  outputs =
    { self
    , delugesource
    , nixpkgs
    }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      deluge = with pkgs.python3Packages;
        buildPythonPackage rec {
          pname = "deluge";
          version = "2.1.1";

          src = delugesource;

          preBuild = ''
          cat > RELEASE-VERSION <<HERE
          ${version}
          HERE
          '';

          propagatedBuildInputs = [
            chardet #==4.0.0
            distro
            ifaddr #==0.2.0
            libtorrent-rasterbar
            Mako
            pillow
            pyasn1
            pygeoip
            pyopenssl
            pyxdg
            rencode
            service-identity
            setproctitle
            setuptools
            twisted
            zope_interface #>=4.4.2

            pytest
            pytest-twisted
          ];

          doCheck = false;
          # This is needed for the tests, otherwise you get:
          # [Errno 13] Permission denied: '/homeless-shelter'
          preCheck = ''
          export XDG_CONFIG_HOME=$(pwd)
          '';

          postInstall = ''
          cp deluge/scripts/create_plugin.py $out/bin
          sed -i 's|/bin/bash|${pkgs.bash}/bin/bash|' $out/bin/create_plugin.py
          '';

          meta = with pkgs.lib; {
          };
        };

      pythonEnv = pkgs.python39.withPackages (p: with p; [
        deluge
      ]);
    in {
      packages.${system}.default = deluge;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pythonEnv
        ];
      };

      apps.${system} = {
        createplugin =
          let
            create_plugin = pkgs.writeScript "create_plugin" ''
              ${pythonEnv.interpreter} ${deluge}/bin/create_plugin.py "$@"
              '';
          in {
            type = "app";
            program = "${create_plugin}";
          };

        deluge-web = {
          type = "app";
          program = "${deluge}/bin/deluge-web";
        };

        deluged = {
          type = "app";
          program = "${deluge}/bin/deluged";
        };
      };
    };
}
