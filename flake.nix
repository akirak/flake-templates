{
  description = "A collection of project templates";

  outputs = { ... }:
    {
      templates = {
        minimal = {
          path = ./minimal;
          description = "Minimal boilerplate with flake-utils";
        };
        pre-commit = {
          path = ./pre-commit;
          description = "Basic flake with pre-commit check";
        };
        elixir-phoenix = {
          path = ./elixir-phoenix;
          description = "Elixir Phoenix project where you use Mix";
        };
      };
    };
}
