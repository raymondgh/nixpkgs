#!/usr/bin/env nix-shell
#! nix-shell -i bash -p google-cloud-sdk

# Unique file or directory in the root of your repo
UNIQUE_FILE=".git"

# Check if the unique file/directory exists in the current working directory
if [ ! -e "$UNIQUE_FILE" ]; then
    echo "Error: This script must be run from the root of the repo."
    echo "Exiting..."
    exit 1
fi

set -euo pipefail

BUCKET_NAME="nixos-base-image"
TIMESTAMP="$(date +%Y%m%d%H%M)"
export TIMESTAMP

nix-build '<nixpkgs/nixos/lib/eval-config.nix>' \
   -A config.system.build.googleComputeImage \
   --arg modules "[ <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix> ./grimportal/standard.nix]" \
   --argstr system x86_64-linux \
   -o gce \
   -j 10

img_path=$(echo gce/*.tar.gz)
img_name=${IMAGE_NAME:-$(basename "$img_path")}
echo "img_name:"
echo "$img_name"

img_id=$(echo "$img_name" | sed 's|.raw.tar.gz$||;s|\.|-|g;s|_|-|g')
img_family=$(echo "$img_id" | cut -d - -f1-4)

if ! gsutil ls "gs://${BUCKET_NAME}/$img_name"; then
  echo "line 1"
  gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"
  echo "line 2"
  # gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/$img_name"
  echo "line 3"
  gcloud compute images create \
    "$img_id" \
    --source-uri "gs://${BUCKET_NAME}/$img_name" \
    --guest-os-features=GVNIC
  echo "line 4"
  gcloud compute images add-iam-policy-binding \
    "$img_id" \
    --member='allAuthenticatedUsers' \
    --role='roles/compute.imageUser'
  echo "line 5"
fi