#!/bin/bash
aws s3api create-bucket --bucket ido-terraform-bucket \
    --region eu-west-1 \
    --create-bucket-configuration LocationConstraint=eu-west-1