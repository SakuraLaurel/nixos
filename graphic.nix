{ pkgs, ... }:

# intel
{
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  boot.initrd.kernelModules = [
    "i915"
  ];

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];
}

# amd
# {
#   hardware.graphics = {
#     enable = true;
#   };
#
#   boot.initrd.kernelModules = [
#     "amdgpu"
#   ];
#
#   environment = {
#     variables = {
#       LIBVA_DRIVER_NAME = "radeonsi";
#       VDPAU_DRIVER = "radeonsi";
#     };
#     systemPackages = with pkgs; [
#       amdgpu_top
#     ];
#   };
# }
