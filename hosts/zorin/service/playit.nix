{ config, pkgs, ... }:

{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.100.0.2/24" ];

    privateKeyFile = "/etc/wireguard/privatekey";

    peers = [
      {
        publicKey = "y0yYMA/8VVnDu6FOiq4HfPyQVEFeupko3QX6GuzjuHg=";
        endpoint = "143.244.151.202:51820";

        allowedIPs = [
          "10.100.0.1/32"
        ];

        persistentKeepalive = 25;
      }
    ];
  };
}