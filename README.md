# Node Hello App CI/CD & Terraform Deployment

This repository contains a simple Node.js web server application deployed to AWS ECS using GitHub Actions and Terraform. The app is containerized with Docker, published to GitHub Container Registry (GHCR), and monitored with New Relic. The Terraform state is stored in an AWS S3 bucket with DynamoDB for locking, ensuring safe and collaborative infrastructure management.

## Prerequisites

- **AWS Account**: With permissions to manage the following resources:
  - **ECS, IAM, VPC, CloudWatch, S3, DynamoDB**: Permissions to create and manage resources (e.g., `ecs:*`, `iam:*`, `ec2:*`, `logs:*`, `s3:*`, `dynamodb:*`).
- **GitHub Repository**: With GitHub Actions enabled.
- **GitHub Container Registry**: Access to push/pull images (requires a GitHub personal access token with `write:packages` and `read:packages` scopes).
- **Terraform**: Version >= 1.2 (for local use).
- **Node.js**: Version >= 20 (for local use).
- **Docker**: Version >= 20 (for local use).
- **AWS CLI**: For troubleshooting or manual AWS resource management.

## Setup Steps

### 1. Set GitHub Secrets

Go to your repository `Settings > Secrets and variables > Actions > Secrets` and add the following secrets:

- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `AWS_REGION`: Your AWS region (e.g., `us-east-1`).
- `NEW_RELIC_LICENSE_KEY`: Your New Relic license key.
- `TOKEN`: A GitHub personal access token with `write:packages` and `read:packages` scopes.

### 2. Configure Terraform Backend

The Terraform state is stored in an AWS S3 bucket with DynamoDB for locking, both defined in `terraform/backend.tf`. These resources must exist before Terraform can use the S3 backend. Follow these steps to create them using Terraform:

1. **Comment Out the Backend Block**:

   - In `terraform/backend.tf`, comment out the `backend "s3"` block to use local state temporarily:
     ```hcl
     terraform {
       # backend "s3" {
       #   bucket         = "node-hello-terraform-state-us-east-1"
       #   key            = "terraform.tfstate"
       #   region         = "us-east-1"
       #   dynamodb_table = "node-hello-terraform-locks"
       # }
     }
     ```

2. **Apply Backend Resources**:

   - Navigate to the `terraform/` directory:
     ```sh
     cd terraform
     ```
   - Initialize Terraform:
     ```sh
     terraform init
     ```
   - Check Terraform Plan:
     ```sh
     terraform plan
     ```
   - Apply the configuration to create the S3 bucket and DynamoDB table:
     ```sh
     terraform apply
     ```
     - **Note**: When prompted with the newrelic key, paste your New Relic license key. If the S3 bucket name is already taken, append a unique suffix to `app_name` or modify the bucket name in `backend.tf`.

3. **Uncomment the Backend Block**:

   - Uncomment the `backend "s3"` block in `terraform/backend.tf`.
   - Ensure the `bucket` and `dynamodb_table` names match the resources created (e.g., `node-hello-terraform-state-us-east-1` and `node-hello-terraform-locks`).

4. **Migrate State to S3**:
   - Re-initialize Terraform to migrate the local state to the S3 bucket:
     ```sh
     terraform init
     ```
   - Confirm the migration when prompted (type `yes`).

### 3. Deploy Your Application

Push your code to the `master` branch. The GitHub Actions workflow will:

- **Lint**: Check code style with ESLint.
- **Build**: Build and push the Docker image to `ghcr.io/<your-username>/node-hello:latest`.
- **Deploy**: Validate Terraform configuration, initialize the S3 backend, generate a plan, and apply it to deploy the app to AWS ECS.

### Accessing Your Application

After successful deployment:

- Find your app's public IP:
  ```sh
  aws ecs list-tasks --cluster node-hello --region us-east-1
  aws ecs describe-tasks --cluster node-hello --tasks [TASK-ARN] --region us-east-1
  ```
- Access your app: `http://[PUBLIC_IP]:3000`.

### 4. Workflow Overview

The `.github/workflows/ci-cd.yml` workflow includes the following steps:

- **Lint**: Runs `npm run lint` to ensure code quality.
- **Build and Push**: Builds the Docker image and pushes it to GitHub Container Registry.
- **Deploy**: Executes the following Terraform commands:
  - `terraform validate`: Validates the syntax and consistency of Terraform configuration.
  - `terraform init`: Initializes the S3 backend for state management and locking.
  - `terraform plan`: Generates an execution plan for AWS resources.
  - `terraform apply`: Deploys the app to ECS and provisions other resources.

### 5. Terraform State Backend

The Terraform state is stored in an S3 bucket (e.g., `node-hello-terraform-state-us-east-1`) with locking via a DynamoDB table (e.g., `node-hello-terraform-locks`). The GitHub Actions workflow automatically uses this backend, so you only need to configure it locally if running Terraform manually.

### 6. Environment Variables

The workflow passes the following variables to Terraform via `TF_VAR_*`:

- `TF_VAR_repository_owner`: Your GitHub username (automatically set from the repository).
- `TF_VAR_new_relic_license_key`: New Relic license key (from GitHub Secrets).
- `TF_VAR_aws_region`: AWS region (from GitHub Secrets).

### 7. New Relic Monitoring

The app is configured with New Relic for monitoring. The `NEW_RELIC_LICENSE_KEY` and `NEW_RELIC_APP_NAME` are set in the ECS task definition via the Terraform configuration. Use the `NEW_RELIC_APP_NAME` to set up the newrelic integration.

## Local Development

1. **Install Dependencies**:

   ```sh
   npm ci
   ```

2. **Lint Code**:

   ```sh
   npm run lint
   ```

3. **Run Locally**:

   ```sh
   npm start
   ```

   The app will run on `http://localhost:3000`.

4. **Run Terraform Locally** (optional):
   - Ensure the backend is set up (see “Configure Terraform Backend” above).
   - Navigate to the `terraform/` directory:
     ```sh
     cd terraform
     ```
   - Initialize, plan, and apply:
     ```sh
     terraform init
     terraform plan
     terraform apply
     ```

## Notes

- **Git Ignore**: The `.gitignore` file excludes `terraform.tfstate`, `terraform.tfstate.backup`, `terraform/.terraform/`, `.terraform.lock.hcl`, and `*.tfvars` to prevent committing sensitive state files or temporary Terraform data.
- **Docker Image**: Published to `ghcr.io/<your-username>/node-hello:latest`.
- **Terraform Files**: All infrastructure is managed in the `terraform/` directory.
