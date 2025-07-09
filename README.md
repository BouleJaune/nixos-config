# My Nixos configuration files

## Secret management : 
sops-nix
``sops secrets/secret.yaml`` avec la bonne clé privée dans ``~/.config/sops/age/keys.txt`` pour éditer les secrets.


---
# Not in nix conf
- HASS (docker compose)
Pour supervision des logs:
`setfacl -m u:promtail:x /home/xenio/jarvis/homeassistant/home-assistant.log`
- Wireguard conf files
- Adguard mutable conf
- *arrs webui conf

TODO:
- user/group pour natpmp updater, wgui (+env file)
- sops wireguard
- Adguard mutable false
- MediaManager declarative replace arr ou arr declarative
- Sops pas que dans conf.nix
- selfhosted overleaf
- nextcloud => OCIS
- monitoring
- backups /var /bigpool important, wg conf, clé privée sops

## Media
- Jellyfin
- Navidrome
- Partage samba

## *arrs
- Soularr
- Radarr
- Lidarr
- Prowlarr
- Sonarr
- flaresolverr

## Downloads
- Qbitorrent-nox
- Natpmp-qbit port updater
- slskd

## Network
- Wireguard-ui pour wg0
- Tunnel wireguard wg0 pour accès remote sécu
- Tunnel wg-proton avec table de routage séparée pour l'utiliser que sur qbit
- Adguard Home
- Nginx reverse proxy 
- MiniCA self signed certif SSL (intégration auto nixos)

## Divers
- Dolibarr
- Dashy
- Vautwarden
- Kanboard
- Octoprint

## Home
- homeassistant
- donetick

## Cloud
- nextcloud
- onlyoffice community
TODO switch to OCIS

## Monitoring
- Grafana
- Alertmanager
- ntfy.sh
- Alertmanager-ntfy
- Prometheus
- Exporters : node, qbit, zfs, smartctl


TODO:
- exportarr-sonarr/radarr/lidarr
- Ajout last update/reboot/nixos version
- Ajout uptime wiser (ping exporter ?)


Dashboards:
- Nixos server
% FS, RAM, CPU, zpool status, qbit firewalled/connected, services failed, smartctl state
- Smartctl dashboard
- Qbitorrent dashboard
- Node exporter full dashboard

Alertes: 
- HASS logs, wiser uptime
- Uptime services
- Firewalled qbit
- zpool status
- temp > 55
- Warning 80% FS
- Warning RAM 90%
- blackout nuit sur alertes
- nix updates
- services : nix-gc and nixos-upgrade
