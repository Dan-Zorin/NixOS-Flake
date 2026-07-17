{ pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "11.0";
    platformToolsVersion = "34.0.5";
    buildToolsVersions = [ "34.0.0" ];
    platformVersions = [ "34" ];
    abiVersions = [ "x86_64" ];
    systemImageTypes = [ "google_apis_playstore" ];
    includeSystemImages = true;
    includeEmulator = true;
    includeNDK = false;
    includeSources = false;
    useGoogleAPIs = true;
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
in
{
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.allowUnfree = true;

  virtualisation.libvirtd.enable = true;
  users.users.zorin.extraGroups = [ "kvm" "libvirtd" ];

  environment.systemPackages = [
    androidComposition.androidsdk
    pkgs.vulkan-loader
    pkgs.libGL
  ];
}