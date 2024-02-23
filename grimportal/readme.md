This repo is used for initial nixos image creation. Run this on gce, modify the configuration.nix there, then create a specific image from that vm to support new use cases.


to do:

- properly name the bucket, file, and image
- make this repo private


how to run:

- go to repo root
- check out the nixos-unstable branch
- run grimportal/create-image.sh