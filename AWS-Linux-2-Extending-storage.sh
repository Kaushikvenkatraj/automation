#! /bin/bash

# This is for only the nitro instances

sudo growpart /dev/nvme0n1 1
sudo xfs_growfs -d /
sudo resize2fs /dev/nvme0n1p1
