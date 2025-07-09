{config, ...}:

{
 #  services.grafana-to-ntfy = {
	# 	enable = true;
	# 	settings.ntfyUrl = "http://127.0.0.1:3126/grafana";
	# 	settings.bauthPass = config.sops.secrets.grafana-to-ntfy.path;
	# };

# 	services.prometheus.alertmanager-ntfy = {
# 		enable = true;
# 		settings = {
# 			http.addr = "127.0.0.1:7898";
# 			ntfy = {
# 				baseurl = "http://127.0.0.1:3126";
# 				notification = {
# 					topic = "alertmanager";
# 			};
# 		};
# 	};
# };
# # yaml ntfy: username: user password: pwd
#
# 	services.prometheus.alertmanager = {
# 		enable = true;
# 		configuration = {
# 			route.receiver = "default";
# 			receivers = [
# 			{
# 				name = "default";
# 				webhook_configs = [
# 				{
# 					url = "https://ntfy.sh/mon-topic";
# 					send_resolved = true;
# 				}
# 				];
# 			}
# 			];
# 		};
# 	};
}
