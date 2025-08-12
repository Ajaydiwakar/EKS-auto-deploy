# EKS-auto-deploy

Alright — here’s the deployment workflow cheat sheet for all the files I gave you, in the correct order and with where they should live.

1️⃣ CloudFormation Infrastructure Setup
These files set up your private EKS environment + networking + optional components.

File	Purpose	: Where to run it,	When to run it

sg-endpoints.yaml	Creates Security Groups & VPC Endpoints so private EKS and CodeBuild can function without internet.	Run via AWS CLI or Console from your laptop.	First, before anything else.

bastion.yaml	Creates a Bastion Host in a private subnet (with SSM Session Manager access).	Optional — only if you want shell access to private subnets.	After sg-endpoints.yaml.

codebuild.yaml	Creates the CodeBuild Project configured for your EKS deployment pipeline.	Optional — only if using CodeBuild for deploy.	After networking & EKS are ready.

deploy-private-eks.sh	Wrapper script to prompt you which stack to deploy (sg-endpoints, bastion, codebuild).	Run from your local machine, instead of manually deploying the above CFTs.

2️⃣ CodeBuild Project Setup
These files define the pipeline & deployment behavior.

File	Purpose: Where to place it	When to use it

buildspec.yml	  Instructions for CodeBuild — builds image, pushes to ECR, deploys to EKS using parameters from SSM.	Inside the source repo connected to CodeBuild.	Always included in the repo before triggering a build.

k8s/app-template.yaml	Sample app manifest (deployment + service) with placeholders (IMAGE_URI).	Inside the repo in a k8s/ folder.	CodeBuild will apply it during the deploy phase.

set-codebuild-params.sh	Interactive script to store values (image repo, tag, cluster name, namespace, manifest path) in SSM Parameter Store.	Run from your laptop or any AWS CLI-enabled machine.	Before triggering a CodeBuild run.

3️⃣ Optional Extra Files
File	Purpose
codebuild-sample.zip	Contains buildspec.yml + app-template.yaml ready-to-use example.

📜 Recommended Execution Order
Infrastructure

bash
Copy
Edit
./deploy-private-eks.sh
# or deploy sg-endpoints.yaml manually if you want
→ Deploy sg-endpoints.yaml first
→ Deploy bastion.yaml (optional)
→ Deploy codebuild.yaml (optional)

Parameter Setup

bash
Copy
Edit
./set-codebuild-params.sh
→ Stores all runtime values into SSM Parameter Store.

Code & Deployment

Place buildspec.yml & k8s/app-template.yaml in your CodeBuild source repo.

Commit & push to trigger a CodeBuild build.

Verification

From Bastion or your local machine (if EKS API is reachable), check:
bash
Copy
Edit
kubectl get pods -n <namespace>
kubectl get svc -n <namespace>







