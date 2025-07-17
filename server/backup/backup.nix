{config, inputs, ...}:

{
  users.users.backup = {
    useDefaultShell = false;
    isSystemUser = true; 
    group = "backup";
    uid = 977;
  };
  users.groups.backup = {gid = 967;};
 
  sops.secrets.smb-backup = {};
  sops.secrets.restic-repo = {};

  # /var/backup/mysql
  services.mysqlBackup = {
    enable = true;
    calendar = "04:45:00";
    databases = [ "dolibarr" ];
  };
  
  #  backup vaultwarden, set up auto et 23h:00
  services.vaultwarden.backupDir = "/var/backup/vaultwarden";

  fileSystems."/mnt/backup" = {
    device = "//192.168.1.219/xenio/";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,nofail";
      gid-backup = toString config.users.groups.backup.gid;
      uid-backup = toString config.users.users.backup.uid;
    in ["${automount_opts},credentials=${config.sops.secrets.smb-backup.path},uid=${uid-backup},gid=${gid-backup}"];
  };


  # port 8001
  services.restic.server.prometheus = true;

  # auto clean up old snapshots

  # Daily backup at 4:45
  # Has to be setup in HASS itself
  services.restic.backups.hass = {
    paths = [ 
    "/home/xenio/jarvis" 
    ];
    timerConfig = { 
      OnCalendar = "*-*-* 5:30:00";
      };
    initialize = true;
    repository = "/mnt/backup/jarvis";
    passwordFile = config.sops.secrets.restic-repo.path;
    exclude = [ "*.db" "*.db-shm" "*.db-wal" ];
  };


services.restic.backups.var-lib = {
    paths = [ 
    # Mysql + vaultwarden backups
    "/var/backup/"
    # Mysql + documents
    "/var/lib/dolibarr" 
    # sqlite
    "/var/lib/kanboard/data" # no need to dump
    "/var/lib/donetick" # no need to dump 
    "/var/lib/jellyfin" 
    ];
    timerConfig = { 
      OnCalendar = "*-*-* 5:35:00";
    };
    backupPrepareCommand = ""; # sqls dumps
    initialize = true;
    repository = "/mnt/backup/var-lib";
    passwordFile = config.sops.secrets.restic-repo.path;
  };



# private key sops, wg confs
# nextcloud data

# - var lib : *arrs, qbitorrent (torrent states)
# - bigpool: documents
}
