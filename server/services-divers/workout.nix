{ ... }:
{

  services.workout = {
    enable     = true;
    nginxVhost = "workout.nixos";
  };
  
}
