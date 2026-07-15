{ config, lib, pkgs, ... }:
{
  networking.wg-quick.interfaces.wg-ds3os = {
    address = [ "10.100.0.3/24" ];
    privateKeyFile = "/etc/wireguard/nixos-private.key";
    peers = [
      {
        publicKey = "SAZkUaV3C9OKtUCum+jElLUu8zLU7E/s3zYD69vCbW4="; # droplet's existing public key
        endpoint = "143.244.151.202:51820";
        allowedIPs = [ "10.100.0.0/24" ]; # or "0.0.0.0/0" if you want full tunnel
        persistentKeepalive = 25;
      }
    ];
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
}