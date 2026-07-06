virtualisation.oci-containers.containers.playit = {
  image = "ghcr.io/playit-cloud/playit-agent:0.17";
  environmentFiles = [ "/etc/playit/secret.env" ];
  extraOptions = [ "--network=host" ];
  autoStart = true;
};