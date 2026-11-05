{config,pkgs,...}:
{
  home.username= "ivy";
  home.homeDirectory = "/home/ivy";
  home.packages = with pkgs; [
      emacs
      libtool
      git
      emacsPackages.vterm
     tree
     xdotool
     discord
     putty
     ocaml-ng.ocamlPackages.ocaml
     ocaml-ng.ocamlPackages.dune_3
     ocaml-ng.ocamlPackages.ocaml-lsp
     ocaml-ng.ocamlPackages.ocamlformat
     opam
     nautilus
     qemu
     espeak
     fasm
     prismlauncher
     discount
     (prismlauncher.override {
     # Add binary required by some mod
     additionalPrograms = [ ffmpeg ];
     # Change Java runtimes available to Prism Launcher
     jdks = [
      graalvmPackages.graalvm-ce
      zulu8
      zulu17
      zulu
      ];
     })
  ];
  programs.home-manager.enable=true;
  home.stateVersion= "26.05";
  
}
