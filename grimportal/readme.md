This repo is used for initial nixos image creation. Run this on gce, modify the configuration.nix there, then create a specific image from that vm to support new use cases.


all the custom stuff is in the root grimportal directory. nothing else gets messed with


to do:

- test out the reverse proxy flow
- test with a bigger save file and multiple players (last implementation risk)
- start working on the auto-run scripts

how to run:

- go to repo root
- check out the nixos-unstable branch
- run grimportal/create-image.sh