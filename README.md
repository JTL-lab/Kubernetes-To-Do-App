# Kubernetes-To-Do-App
Assignment 3 (Kubernetes/Docker) for Big Data and Cloud Computing course at Columbia University.

## Commands
---
### Docker Commands
- docker version

### Docker Image Commands
- docker build -t [image] .
- docker scout quickview
- docker scout cves [image]
- docker scout recommendations [image]
- docker images
- docker rmi [image]
- docker ps -a
- docker run [image] --name [name] -p [port] --hostname [hostname]
- docker run -p 5000:5000 [image]
- docker start [container]
- docker stop [container]
- docker rm [container] -f
- docker rm $(docker ps -aq) -f
- docker compose up
- docker compose down
- docker volume inspect [volume-name]
- docker volume rm [volume-name]

### Docker Hub Commands
- docker push [image]:[tag]
- docker pull [image]:[tag]
- docker logs [container]
- docker stats
- docker tag your-local-image-name:tag yourdockerhubusername/your-image-name:tag
- docker pull mongo

---
### Minikube Commands - To setup local K8 cluster
- minikube start
- minikube service flask-app-service --url

---
### Kubectl Commands
- kubectl get po -A
- kubectl apply -f flask-to-do-app-deployment.yml
- kubectl apply -f mongodb-deployment.yml
- kubectl expose -f flask-to-do-app-service.yml
- kubectl expose -f mongodb-service.yml
- kubectl get pod
- kubectl get all
- kubectl get configmap
- kubectl get secret
- kubectl get crd
- kubectl get statefulset
- kubectl describe statefulset prometheus-prometheus-kube-prometheus-prometheus > prom-statefulset.yml
- kubectl get deployment 

#### K8 Dashboard
- kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml


---
## Part 8: Instructions for Alerting
1. First ensure that there are no resources on the pod.
   ```
   kubectl get pod
   ```
2. Install Helm.
3. Install the Kubernetes Prometheus stack (out-of-the-box K8 Monitoring enabled) using Helm.
    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/kube-prometheus-stack
    ```
4. Get the statefulsets' container/image info. (Optional)
   ```
   kubectl get deployment
   kubectl describe statefulset prometheus-prometheus-kube-prometheus-prometheus > prom-statefulset.yml
   kubectl describe statefulset prometheus-prometheus-kube-prometheus-prometheus > smetrics-statefulset.yml
   ```
5. Get the deployment YAML config file
    ```
    kubectl get deployment
    kubectl get deployment prometheus-kube-prometheus-operator -o yaml
    kubectl get deployment flask-app -o yaml
    ```

---
## References
```
- https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#expose
- https://minikube.sigs.k8s.io/docs/handbook/accessing/
- https://helm.sh/docs/helm/helm_install/
- https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
```