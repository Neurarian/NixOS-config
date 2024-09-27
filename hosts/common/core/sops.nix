{ config, ... }: {

  sops = {
    validateSopsFiles = false;
    defaultSopsFile = ./secrets/pass.yaml;
    age = {
      sshKeyPaths = [ "/etc/sops/.ssh/id_ed25519"];
    };
  };
}
