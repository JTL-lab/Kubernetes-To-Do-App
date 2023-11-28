# Kubernetes-To-Do-App
Assignment 3 (Kubernetes/Docker) for Big Data and Cloud Computing course at Columbia University.

**Commands**
---
**Docker Commands**
docker version

**Docker Image CMD**
docker build -t [image] .
docker scout quickview
docker scout cves [image]
docker scout recommendations [image]
docker images
docker rmi [image]
docker ps -a
docker run [image] --name [name] -p [port] --hostname [hostname]
docker run -p 5000:5000 [image]
docker start [container]
docker stop [container]
docker rm [container] -f
docker compose up
docker compose down
docker volume inspect [volume-name]
docker volume rm [volume-name]

**Docker Hub CMD**
docker push [image]:[tag]
docker pull [image]:[tag]
docker logs [container]
docker stats
docker tag your-local-image-name:tag yourdockerhubusername/your-image-name:tag
**Community images**
docker pull mongo
---

**Minikube Commands** - To setup local K8 cluster
minikube start
kubectl get po -A