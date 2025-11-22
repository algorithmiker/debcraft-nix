# debcraft-nix

[debcraft](https://salsa.debian.org/debian/debcraft) packaged for [Nix](https://nixos.org).

The derivation is not necessarily up to nixpkgs standards right now, so it is not upstream yet.

## Usage
### Flakes
```nix
# flake.nix
inputs = {
  debcraft-nix.url = "github:algorithmiker/debcraft-nix";
  # the package is trivial to build locally, so don't create a new nixpkgs instance
  debcraft-nix.inputs.nixpkgs.follows = "nixpkgs";
};

# configuration
{ pkgs, lib, ...}:
{
  environment.systemPackages = [ debcraft-nix.packages.${pkgs.system}.debcraft ];
}
```

### Non-flakes
The repo has a package.nix, fetch and build that somehow, either by vendoring or IFD.

## Bonus learning about podman 
- You can delete all stored podman caches with `podman image prune && podman system prune`
