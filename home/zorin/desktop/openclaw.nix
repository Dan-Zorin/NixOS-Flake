{ ... }:
{
  services.openclaw = {
    enable = true;
    modelProvider = "anthropic";
    modelApiKeyFile = "/home/zorin/.secrets/anthropic-api-key"; # see note below
    gateway.bind = "loopback";
    toolSecurity = "allowlist";
    toolAllowlist = [ "read" "write" "edit" "web_search" "web_fetch" "message" "tts" ];
    telegram.enable = true;
    telegram.tokenFile = "/home/zorin/.secrets/telegram-bot-token";
  };
}