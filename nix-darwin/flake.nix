{
  description = "Khongtrunght Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs,config, ... }: {
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.mkalias
          pkgs.obsidian
          pkgs.starship
          pkgs.nushell
          pkgs.zoxide
          pkgs.carapace
          pkgs.wezterm
          pkgs.bat
          pkgs.yazi
          pkgs.direnv
          inputs.home-manager.packages.${pkgs.system}.default
        ];

      homebrew = {
        enable = true;
        casks = [
          "the-unarchiver"
          "iina"
          "hammerspoon"
          "MonitorControl"
        ];
        brews = [ "neovim" ];
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      users.users.khongtrunght.home = "/Users/khongtrunght";
      home-manager.backupFileExtension = "backup";


      fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      system.activationScripts.postUserActivation.text = ''
        rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
        apps_source="${config.system.build.applications}/Applications"
        moniker="Nix Trampolines"
        app_target_base="$HOME/Applications"
        app_target="$app_target_base/$moniker"
        mkdir -p "$app_target"
        ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
      '';

      system.defaults = {
          dock.persistent-apps = [
            "${pkgs.wezterm}/Applications/WezTerm.app"
            "/Applications/Google Chrome.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Calendar.app"
          ];
        };


      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      security.pam.services.sudo_local.touchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration
          nix-homebrew.darwinModules.nix-homebrew 
          {
            nix-homebrew = {
              enable = true;
               # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "khongtrunght";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.khongtrunght = import ./home.nix;
          }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mini".pkgs;
  };
}
