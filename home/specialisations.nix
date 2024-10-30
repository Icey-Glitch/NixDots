{
  theme = {
    wallpaper = let
      url = "https://drive.usercontent.google.com/download?id=1Kxn8p5jiSO7ihIAG70B_kfyL9HoTYHjB";
      sha256 = "1mfvhkaw07pm5mh05ggbxdc2hp97iybq7iz4yhj8h7xzhzb87ij8";
      ext = "png";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
