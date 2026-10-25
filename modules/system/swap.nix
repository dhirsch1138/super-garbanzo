{
  config,
  lib,
  pkgs,
  ...
}:

let
  hasSwap = config.swapDevices != [ ];
in
{
  # Use zram if no swap devices exist
  zramSwap.enable = lib.mkDefault (!hasSwap);

  # Use zswap if swap devices already exist
  boot.zswap = {
    enable = lib.mkDefault (hasSwap);
    # And optionally configure further:
    maxPoolPercent = 50;
    shrinkerEnabled = true;
    compressor = "zstd";
    acceptThresholdPercent = 90;
  };
}
