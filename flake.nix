{
  description = "A very basic flake";
  inputs.nixpkgs.url = "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [ruby_3_3 rubyPackages.solargraph];
    };
  };
}
