# CloudWhale - Containerized App + ECR + ECS

A simple Flask application designed to demonstrate containerization, AWS ECR, and ECS Fargate deployment. 

---

## Project Overview
- **Tech Stack:** Python, Flask, Docker, AWS ECR, AWS ECS Fargate  
- **Goal:** Containerize a Flask web application, push the Docker image to AWS ECR, and deploy it on ECS Fargate.  

---

## Local Development

The project includes a Flask app with a single route that returns a welcome message. Dependencies are managed through a requirements file. Docker is used to containerize the application, exposing port 5000. Locally, the container can be built and run to verify the Flask app works before pushing to AWS.

**Key Commands:**

- Build Docker image locally: `docker build -t <project-name> .`  
- Run Docker container locally: `docker run -it -p 5050:5000 <project-name>`  
- Stop running containers: `docker ps` and `docker stop <container-id>`

-  This allows local testing at [http://localhost:5050](http://localhost:5050) before deployment.
---

## Dockerization

Docker provides an isolated environment for the Flask application. The Dockerfile specifies a lightweight Python base image, copies the application files, installs dependencies from `requirements.txt`, exposes port 5000, and sets the command to run the Flask app. Docker allows testing the application in an environment similar to production.

---

## AWS ECR (Elastic Container Registry)

AWS ECR is used to store the Docker image in the cloud. First, an ECR repository is created in the desired AWS region. Docker is then authenticated with AWS, and the local Docker image is tagged and pushed to ECR.  

**Key Commands:**

- Create ECR repository:  
  `aws ecr create-repository --repository-name <name> --region <region>`  

- Authenticate Docker to ECR:  
  `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<region>.amazonaws.com`  

- Tag Docker image for ECR:  
  `docker tag <project-name>:latest <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest`  

- Push Docker image to ECR:  
  `docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest`  

---

## ECS Fargate Deployment

ECS Fargate provides serverless container orchestration. A cluster is created, along with a task definition that specifies task-level CPU and memory, container-level CPU and memory limits, and port mappings. A Fargate service runs the task and provides a public IP to access the app.

**Steps & Commands:**

1. **Create ECS Cluster**  
   Navigate to ECS → Clusters → Create Cluster → Networking only (Fargate), name it `cloudwhale-flask-cluster`.

2. **Create Task Definition**  
   - Launch type: Fargate  
   - Task CPU: (Set based on your app’s needs)_
   - Task Memory: (Set based on your app’s needs)_
   - Container CPU: (Set based on your app’s needs)_
   - Container Memory soft: (Soft/Hard limits within task memory)_ 
   - Port mapping: 5000
   - Image URI: `<account-id>.dkr.ecr.<region>.amazonaws.com/cloudwhale-flask:latest`  

3. **Run ECS Service**  
   Navigate to ECS → Cluster → Services → Create → Fargate  
   - Task Definition: `cloudwhale-flask-task`  
   - Number of tasks: 1  
   - Enable Public IP  
   - Security Group: allow inbound TCP 5000  

4. **Check running task & logs**  
   - View task status: ECS Console → Cluster → Tasks
   - Once the task is running, the app will be available at: `http://<public-ip>:5000`
   - View logs: CloudWatch Logs → Container logs  

---

## Notes and Considerations

- **Architecture:** On ARM-based Macs, Docker images must be built for x86_64 to run on ECS Fargate.  
- **Memory & CPU:** Container memory and CPU must not exceed task-level resources.  
- **Local Development:** Use a virtual environment (`venv`) locally for dependency management, but it’s not required inside Docker containers.  
- **Error Handling:** ECS Deployment Circuit Breaker triggers if tasks repeatedly fail. CloudWatch logs help diagnose issues like port conflicts, crashes, or architecture mismatches.

---

## Outcome

Once deployed successfully, the Flask application runs on ECS Fargate, accessible via a public IP. This project demonstrates practical DevOps skills including containerization, cloud container registry usage, serverless container orchestration, and deployment troubleshooting. 
