{config, pkgs, ...}:


let 
grafConf = config.services.grafana.settings.server;
in
{

	# TODO: smartctl_exporter, systemd_exporter, dash complet, alerte zpool status
	services.grafana = {
		# Si besoin de plugins:
		# declarativePlugins = with pkgs.grafanaPlugins; [ ... ];
		enable = true;
		settings.server = {
			http_port = 3451;
			domain = "grafana.nixos";
		};

		provision = {
			enable = true;

			# sed le datasource en "prome" dans les json
			dashboards.settings.providers = [{
				name = "Dashboards";
				options.path = "/etc/grafana/dashboards";
			}];

			datasources.settings.datasources = [
			{
				name = "Prometheus";
				type = "prometheus";
				url = "http://127.0.0.1:${toString config.services.prometheus.port}";
				uid = "prome";
				jsonData.tlsSkipVerify = true;
			}
			{
				name = "Loki";
				type = "loki";
				uid = "loki";
				url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
				jsonData.tlsSkipVerify = true;
			}
			];
		};
	};

	environment.etc."grafana/dashboards/qbitorrent.json" = {
			source = ./. + "/grafana-dashboards/qbitorrent.json";
			group = "grafana";
			user = "grafana";
		};

	environment.etc."grafana/dashboards/nixos-server.json" = {
			source = ./. + "/grafana-dashboards/nixos-server.json";
			group = "grafana";
			user = "grafana";
		};

	services.nginx.virtualHosts."grafana.nixos" = {
		forceSSL = true;
		enableACME = true;
		locations."/" = {
			proxyPass = "http://${toString grafConf.http_addr}:${toString grafConf.http_port}";
			proxyWebsockets = true;
			recommendedProxySettings = true;
		};
	};

	dashy.monitoring.entry = [
	{ title = "Grafana";
		url = "https://grafana.nixos/";}
	];

}
