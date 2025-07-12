# Node Hello World

Simple node.js app that servers "hello world"

Great for testing simple deployments to the cloud

## Features

- Node.js Express web server
- Dockerized application with custom Dockerfile
- Terraform-based deployment using the Docker provider
- GitHub Actions for CI/CD (build, lint, push image)
- Optional: Integrates with monitoring/logging tools (e.g., New Relic)

---


### Prerequisites

Ensure you have the following tools installed:

- [Docker](https://www.docker.com/)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/) 

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/node-hello.git
cd node-hello
```

### Run locally with Docker

```
docker build -t node-hello .
docker run -p 3000:3000 node-hello

```

### Deploy with Terraform

```
terraform init
terraform plan
terraform apply
```

visit 
``` 
http"//localhost:3000
```
## Run It

`npm start`
