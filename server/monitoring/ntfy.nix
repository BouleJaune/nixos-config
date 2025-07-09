{config, pkgs, ...}:

{
	services.ntfy-sh = {
		enable = true;
		settings = {
			base-url = "https://ntfy.nixos";
			listen-http = ":3126";
		};
	};

# services.grafana-to-ntfy.enable = true;
	dashy.monitoring.entry = [{
		title = "ntfy";
		url = "https://ntfy.nixos/";}];

	services.nginx.virtualHosts."ntfy.nixos" = {
		enableACME = true;
		forceSSL = true;
		locations."/" = {
			proxyPass = "http://127.0.0.1:3126";
			proxyWebsockets = true;
		};
	};

}

