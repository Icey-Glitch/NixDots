{ inputs, ... }:
{
  imports = [
    inputs.slippi.homeManagerModules.default
  ];

  slippi-launcher = {
    isoPath = "/mnt/more/downloads/super-smash-bros.-melee-usa-en-ja-v-1.02_202407/Super Smash Bros. Melee (USA) (En,Ja) (v1.02).iso";
    launchMeleeOnPlay = false;
  };
}
