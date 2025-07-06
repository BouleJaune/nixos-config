{config, pkgs, ...}:

{
	services.promtail = {
		enable = true;
		configuration = {
			server = {
				http_listen_port = 3031;
				grpc_listen_port = 0;
			};
			clients = [{
				url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
			}];
			scrape_configs = [{
				job_name = "apps";
				static_configs = [
					{
					# targets = ["localhost"];
					labels = { 
						job = "service";
						app = "home-assistant";
						__path__ = "/home/xenio/jarvis/homeassistant/home-assistant.log";
					};
					} ];
			}{
				job_name = "journal";
				journal = {
					max_age = "12h";
					labels = {
						job = "systemd-journal";
						host = "nixos";
					};
				};
				relabel_configs = [{
					source_labels = [ "__journal__systemd_unit" ];
					target_label = "unit";
				}];
			}];
		};};

	dashy.monitoring.entry = [{
		title = "Promtail";
		url = "https://promtail.nixos/";}];

	services.nginx.virtualHosts."promtail.nixos" = {
		enableACME = true;
		forceSSL = true;
		locations."/" = {proxyPass = "http://127.0.0.1:3031";};
	};
}
