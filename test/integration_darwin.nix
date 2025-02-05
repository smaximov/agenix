{
  config,
  pkgs,
  options,
  ...
}: let
  secret = "hello";
  testScript = pkgs.writeShellApplication {
    name = "agenix-integration";
    text = ''
      grep ${secret} ${config.age.secrets.secret1.path}
    '';
  };
in {
  imports = [
    ./install_ssh_host_keys_darwin.nix
    ../modules/age.nix
  ];

  services.nix-daemon.enable = true;

  age.identityPaths = options.age.identityPaths.default ++ ["/etc/ssh/this_key_wont_exist"];

  age.secrets.secret1.file = ../example/secret1.age;

  environment.systemPackages = [testScript];
}
