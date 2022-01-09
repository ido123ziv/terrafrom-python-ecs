#!/bin/bash
REGION=$(aws configure get region)
echo Region: $REGION
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo Account: $ACCOUNT_ID
REPO=$1
echo Repo: $REPO
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
echo Tagging!
docker tag python-app $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
echo Pushing!
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest