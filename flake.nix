{ description = "gbrls's NixOS flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";


  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    nix-alien,
    ...
  } @ inputs: let
  inherit (self) outputs;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  newpkgs = nixpkgs-unstable.legacyPackages.${system};
  in {
# NixOS configuration entrypoint
# Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstablePkgs = import inputs.nixpkgs-unstable {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
        };
        modules = [./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.gbrls = {
              imports = [
                nixvim.homeManagerModules.nixvim
                (import ./neovim.nix { inherit newpkgs; })
              ];
              home.packages = [ ];
              programs.git = {
                enable = true;
                userName = "Gabriel Schneider";
                userEmail = "gabrielschneider100@protonmail.com";
              };
              programs.zsh = {
                enable = true;
                enableAutosuggestions = true;
              };
              programs.fzf = {
                enable = true;
                enableZshIntegration = true;
                tmux.enableShellIntegration = true;
              };
              programs.z-lua.enable = true;
              programs.tmux = {
                enable = true;

                #prefix = "C-a";
                shortcut = "a";
                escapeTime = 0;
                keyMode = "vi";
                terminal = "tmux-256color";
                baseIndex = 1;

                extraConfig = ''
                  bind h select-pane -L
                  bind j select-pane -D
                  bind k select-pane -U
                  bind l select-pane -R
                  bind s split-window -v
                  bind v split-window -h
                  setw -g mouse on
                  '';
              };

              xsession.windowManager.i3 = 
              let 
                mod = "Mod4";
              in {
                enable = true;
                config = {
                  modifier = mod;
                  keybindings = nixpkgs.lib.mkOptionDefault {
                    "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
                    "${mod}+h" = "focus left";
                    "${mod}+j" = "focus down";
                    "${mod}+k" = "focus up";
                    "${mod}+l" = "focus right";

                    "${mod}+Shift+1" = "move container to workspace 1";
                    "${mod}+Shift+3" = "move container to workspace 2";
                    "${mod}+Shift+h" = "move to workspace prev";
                    "${mod}+Shift+l" = "move to workspace next";
                  };
                };
              };

              programs.kitty = {
                enable = true;
                theme = "Everforest Dark Hard";
                font = {
                  name = "Victor Mono";
                  size = 16.0;
                };
                extraConfig = "background_opacity: 0.7";
              };
              home.stateVersion = "23.11";
            };

            home-manager.users.root = {
              imports = [
                nixvim.homeManagerModules.nixvim
                  (import ./vim.nix { inherit pkgs; })
              ];
              programs.git = {
                enable = true;
                userName = "Gabriel Schneider";
                userEmail = "gabrielschneider100@protonmail.com";
              };
              home.packages = [ ];
              programs.bash.enable = true;
              programs.fzf.enable = true;
              home.stateVersion = "23.11";
            };

          }
        ];
      };
    };
  };
}
