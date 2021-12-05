{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let 
  op-get-test-failures = writeShellScriptBin "op-get-test-failures" ''
    exec ${curl}/bin/curl "$$1" | grep 'rspec \.\/' | cut -f3 -d' ' | paste -s -d ' '
  '';

  gems = bundlerEnv {
    name = "proyeksiapp-dev";
    inherit ruby;
    gemdir = ./.;
  };
in
  mkShell {
    nativeBuildInputs = [
      buildPackages.ruby_2_7
      postgresql
      nodejs
      tightvnc
      bundix
      docker-compose
      google-chrome

      gems

      op-get-test-failures
      nodePackages.webfonts-generator
    ];

    CHROME_BINARY = "${google-chrome}/bin/google-chrome";
    PROYEKSIAPP_TESTING_NO_HEADLESS = "1";
    PROYEKSIAPP_TESTING_AUTO_DEVTOOLS = "1";
}

