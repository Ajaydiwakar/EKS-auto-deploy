#!/bin/bash

echo "Enter AWS Region:"
read AWS_REGION

echo "Enter ECR Image Repository Name:"
read IMAGE_REPO_NAME

echo "Enter Image Tag:"
read IMAGE_TAG

echo "Enter EKS Cluster Name:"
read CLUSTER_NAME

echo "Enter Kubernetes Namespace:"
read APP_NAMESPACE

echo "Enter Application Manifest File Path (in CodeBuild environment):"
read APP_MANIFEST_FILE

# Store in SSM Parameter Store
aws ssm put-parameter --name "/codebuild/image-repo-name" --value "$IMAGE_REPO_NAME" --type String --overwrite --region $AWS_REGION
aws ssm put-parameter --name "/codebuild/image-tag" --value "$IMAGE_TAG" --type String --overwrite --region $AWS_REGION
aws ssm put-parameter --name "/codebuild/cluster-name" --value "$CLUSTER_NAME" --type String --overwrite --region $AWS_REGION
aws ssm put-parameter --name "/codebuild/app-namespace" --value "$APP_NAMESPACE" --type String --overwrite --region $AWS_REGION
aws ssm put-parameter --name "/codebuild/app-manifest" --value "$APP_MANIFEST_FILE" --type String --overwrite --region $AWS_REGION

echo "✅ All parameters stored in SSM successfully."
