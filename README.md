# My Nixos configuration files

## Secret management : 
sops-nix
``sops secrets/secret.yaml`` avec la bonne clé privée dans ``~/.config/sops/age/keys.txt`` pour éditer les secrets.


---
# Not in nix conf
- Wireguard conf files
- Adguard mutable conf
- *arrs webui conf

TODO:
- user/group pour natpmp updater, wgui (+env file)
- sops wireguard
- Adguard mutable false
- MediaManager declarative replace arr ou arr declarative
- selfhosted overleaf
- nextcloud => OCIS
- backups /var /bigpool important, wg conf, clé privée sops
- Fin PR grafana-to-ntfy pour enlever fichier test empty `ntfyBAuthPass = "/etc/nixos/test";`
- Revoir samba
- autoscrub + report grafana + autosnapshot
- vaultwarden backupdir
- searxng


# Services
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

## Backup
- Restic
- SMB share through wireguard tunnel
- Daily incremental
Backed up:
- Home assistant daily sqlite dump + backup whole folder
- `/var/backup`: mysql databases (dolibarr), vautwarden
- `/var/lib` : dolibarr docs, donetick, jellyfin, kanboard, *arrs, qbitorrent
- bigpool: documents

## Monitoring
- Grafana
- Alertmanager
- ntfy.sh
- Alertmanager-ntfy
- Prometheus
- Exporters : node, qbit, zfs, smartctl, restic



Dashboards:
- Nixos server
% FS, RAM, CPU, zpool status, qbit firewalled/connected, services failed, smartctl state
- Smartctl dashboard
- Qbitorrent dashboard
- Node exporter full dashboard
