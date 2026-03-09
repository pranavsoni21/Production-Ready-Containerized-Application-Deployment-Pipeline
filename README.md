# Production-Ready-Containerized-Application-Deployment-Pipeline
This is a project I built for my understanding and learning about devops practices and how the workflow is being created in an actual organization from building to deployment phase.


## Project Goal
For the last 1 month I was learning and practicing devops tools, so after having good understanding about AWS(cloud), Terrraform, CI/CD automation, containerization(docker), deployments(ECS & EC2), etc. I was eager to apply this knowledge somewhere and built something out of it, that's why I built this project. This project clearly demonstrates my understanding about:
Containerization
CI/CD automation
AWS container deployment
Multi-architecture image builds
Zero downtime deployment

## Architecture Overview
Image

```
Developer pushes code
↓
GitHub Actions pipeline triggers
↓
Docker Buildx builds multi-architecture image
↓
Image pushed to AWS ECR
↓
ECS service pulls new image
↓
ALB distributes traffic 
```

Developer pushes code: whenever one of the developer from our team pushed code to main branch of our repository, our CI/CD pipeline will get trigger using github actions workflow.

Github Actions pipeline triggers: It will get trigger on every push to the main branch. In the workflow file first of all it describes name of workflow, on which runner to run, which jobs to do and what are the steps inside it to complete.

Docker buildx builds multi-architecture image: As soon as our pipeline triggers, it will first check out the code, configure AWS credentials and then It will start to build multi-architecture image using docker buildx, so that it can be run on any architecture machine on deployment. I also used commit based image tagging, so that rolling back will be seamless and not confusing in future.

Image pushed to AWS ECR: After building that image , pipeline will push it to AWS ECR repository where it will get stored safely in our ECR repo.

ECS service pulls new image: As our ECS infrastucture is already configured, so whenever a new image is being pushed to ECR, our pipeline will extract task definiton from ECR, render it and deploy the new task in form of containers.

ALB distributes traffic: While creating AWS ECS service, I configured it to use Application load balancer for rolling deployments, zero-downtime, and distributed traffic across the containers.


## Technologies Used

```
Technologies Used

Application
- Python
- Flask
- Gunicorn

Containerization
- Docker
- Multi-stage builds
- Docker Buildx

CI/CD
- GitHub Actions

Cloud Infrastructure
- AWS ECR
- AWS ECS
- Application Load Balancer
```

## Why Section
``
Why I use multi-stage builds?
While creating docker image file multi-stage build process breaks builds into stages. First stage(builder stage) handles building and compiling the application along with heavy dependencies. Second stage uses very minimal base image like (alpine, debian-slim) and just copy that compiled artifacts from builder stage while excluding source-code, building tools, dependencies etc. Since docker uses last stage to built the final image, which will eventually decreases image size and security concerns. That's why I used multi-stage build to create dockerfile. 
``

``
Why I used gunicorn instead of flask server?
Flask server is not designed for production use, it's just a development server, that's why it's not stable, effecient and secure enough to handle production traffic. While Gunicorn is a produciton level WSGI server which provides essential features like security, stability and scalability. 
``


## How to run locally

```
# Clone the repo
git clone https://github.com/pranavsoni21/Production-Ready-Pipeline.git

# change the directory
cd Production-Ready-Pipeline

# Build docker image
docker build -t app:latest .

# Run that image in a container
docker run -it --name app -p 8000:8000 app:latest
```

## Future Improvements
 - Terraform for infrastructure provisioning
 - Container vulnerability scanning
 - Monitoring
 - Autoscaling
 - Database integration

## Lessons Learned
 - Docker multi-architecture builds
 - ECS deployment workflow
 - CI/CD automation
 - ALB based zero downtime deployments
