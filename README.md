# My Nixos configuration files

## Secret management : 
sops-nix
``sops secrets/secret.yaml`` avec la bonne clé privée dans ``~/.config/sops/age/keys.txt`` pour éditer les secrets.


---
# Not in nix conf
- HASS (docker compose)
- Wireguard conf files
- Adguard mutable conf
- *arrs webui conf

TODO:
- modularisation 
- user/group pour natpmp updater, wgui (+env file)
- sops wireguard
- Adguard mutable false
- MediaManager declarative replace arr ou arr declarative
- Sops pas que dans conf.nix
- selfhosted overleaf
- nextcloud => OCIS
- monitoring

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
- Loki
- Promtail
- ntfy.sh
- Prometheus
- Exporters : node, qbit, zfs, smartctl

TODO:
- Give promtail user right to read logs
- monitoring update nightly
- grafana / loki analytics stop

Logs: 
- HASS


Main dashboard:
- % FS OK
- % RAM, CPU load OK
- Zpool status OK
- qbit firewalled and connected OK
- services failed OK
- smartctl info OK


- exportarr-sonarr/radarr/lidarr


Dashboard import:
- qbit
- smartctl
- node export
- zfs

Alertes: 
- HASS logs, wizer uptime
- Uptime services
- Firewalled qbit
- zpool status
- temp > 55
- Warning 80% FS
- Warning RAM 90%
- blackout nuit sur alertes
- nix updates
- services : nix-gc and nixos-upgrade
