#!/usr/bin/env bash
#
aws ec2 import-key-pair --key-name "bcitkey" --public-key-material fileb://~/bcitkey.pub

