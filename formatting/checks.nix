{
  inputs,
  self,
  ...
}: {
  perSystem = {system, ...}: {
    checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = self;
      hooks = {
        alejandra.enable = true;
        statix.enable = true;
        deadnix = {
          enable = true;
          args = ["--no-lambda-pattern-names"];
        };
      };
    };
  };
}
