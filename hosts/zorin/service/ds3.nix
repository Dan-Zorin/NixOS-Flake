{ config, lib, pkgs, ... }:
{
  networking.wg-quick.interfaces.wg-ds3os = {
    address = [ "10.100.0.2/24" ];
    privateKeyFile = "/etc/wireguard/privatekey";
    peers = [
      {
        publicKey = "y0yYMA/8VVnDu6FOiq4HfPyQVEFeupko3QX6GuzjuHg="; # droplet's existing public key
        endpoint = "143.244.151.202:51820";
        allowedIPs = [ "10.100.0.0/24" ]; # or "0.0.0.0/0" if you want full tunnel
        persistentKeepalive = 25;
      }
    ];
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
}