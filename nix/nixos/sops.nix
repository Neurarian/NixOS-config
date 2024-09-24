{
  # imports = [ inputs.sops.nixosModules.sops ];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops =
    {
      defaultSopsFile = ../secrets/pass.yaml;
      # This will automatically import SSH keys as age keys
      age = {

        sshKeyPaths = [ "/home/Liqyid/.ssh/id_ed25519"];
        # This is using an age key that is expected to already be in the filesystem
        keyFile = "/home/Liqyid/.config/sops/age/keys.txt";
        # This will generate a new key if the key specified above does not exist

        # This is the actual specification of the secrets.
      };
       secrets."passwords/wifi/ChArian_Inet" = {};
    };
}
