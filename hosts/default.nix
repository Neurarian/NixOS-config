{self, ...}: {
  flake.nixosConfigurations = let
    inherit (self.lib) mkSystem;
  in {
    Loki = mkSystem "Loki" {};
    Medion = mkSystem "Medion" {};
    Fujitsu = mkSystem "Fujitsu" {};
    Wsl = mkSystem "Wsl" {};
  };
}
