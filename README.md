# My Nixos configuration files

## Secret management : 
sops-nix
``sops secrets/secret.yaml`` avec la bonne clé privée dans ``~/.config/sops/age/keys.txt`` pour éditer les secrets.


---

TODO:
- modularisation 
- user/group pour natpmp updater, wgui (+env file)
- sops wireguard
- Adguard mutable false
- MediaManager declarative replace arr ou arr declarative

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

Logs: 
- HASS
