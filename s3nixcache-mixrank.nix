{
  nix = {
    settings = {
      substituters = [
        "s3://mr-nixcache?profile=mixrank"
      ];
      trusted-public-keys = [
        "mr-nixcache:/pYWDq35flabWpnX2d/t6NV6IlkTQiP4MRddc1F3WuU="
      ];
    };
  };
}
