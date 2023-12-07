# Kubernetes-To-Do-App
Assignment 3 (Kubernetes/Docker) for Big Data and Cloud Computing course at Columbia University.

---
## Commands
### Part 2: Containerizing the Application using Docker
Link to image on Docker Hub: https://hub.docker.com/r/jtllab/flask-to-do-app

Build the docker image and verify the image was created: 
```
docker build -t to-do-app .
docker images
```

Deploy using Docker compose and verify containers are running: 
```
docker-compose up -d
docker ps
```

Command to rebuild: 
```
docker-compose build
```

Pushing the image to Dockerhub: 
```
docker tag flask-to-do-app jtllab:flask-to-do-app:latest
docker push jtllab/flask-to-do-app:latest
```

---

To delete Docker containers: 
```
docker stop <container_id>
docker rm <container_id> 
```

To delete one image after containers deleted: 
```
docker rmi <image_id>
```

To delete all images after containers deleted:
```
docker rmi $(docker images -q) -f
```
### Part 3: Deploying the Application on Minikube
Start minikube: 
```
minikube start
```

Commands to deploy Flask and MongoDB, plus associated services:
```
kubectl apply -f flask-to-do-app-deployment.yml
kubectl apply -f mongodb-deployment.yml
kubectl apply -f flask-to-do-app-service.yml
kubectl apply -f mongodb-service.yml
```

Verify everything is up: 
```
kubectl get deployments
kubectl get services
```

Get URL of deployed application to verify it is running correctly on Minikube:
```
minikube service flask-app-service --url
```
---
To delete all Kubernetes pods and resources: 
```
kubectl delete services --all --all-namespaces
kubectl delete pods --all --all-namespaces
```
### Part 4: Deploying the Application on AWS EKS
Deploy EKS cluster using AWS CLI: 
```
eksctl create cluster --name to-do-eks-cluster --version 1.24 --region us-east-1 --nodegroup-name my-nodes --node-type t3.small --nodes-min 1 --nodes-max 2 --managed
```

Note: Wait for both Cloudformation stacks (for the EKS cluster and its associated nodes, respectively) to successfully create all resources (cluster, nodes, VPC setup, etc.) before proceeding.

Update Minikube config to ensure it has permission to access the newly created EKS cluster (should be done automatically, but running this command guarantees it):
```
aws eks --region us-east-1 update-kubeconfig --name to-do-eks-cluster
```

Deploy Flask app, MongoDB, and associated services again:
```
kubectl apply -f flask-to-do-app-deployment.yml
kubectl apply -f mongodb-deployment.yml
kubectl apply -f flask-to-do-app-service.yml
kubectl apply -f mongodb-service.yml
```

Verify everything is up: 
```
kubectl get deployments
kubectl get services
```

Get URL for the application running in EKS: 
```
kubectl get service flask-app-service
```

You can use the URL returned with port 5000 in a browser to verify the application is running in the cloud!

### Part 5: Replication controller feature
Set up replication controller: 
```
kubectl apply -f flask-rc.yaml 
```

List pods: 
```
kubectl get pods
```

Verify that replication controller is working by deleting a pod (another will be automatically created to maintain number of replicas afterwards):
```
kubectl delete pod [POD_NAME]
```
### Part 6: Rolling update strategy
- Created another image for the to-do app, ``jtllab/flask-to-do-app:v2``, and uploaded to DockerHub. 
- Redeployed new image with rolling update strategy and confirmed successful update. 

Relevant commands: 
1) To update image to new version (e.g. ``v2``)
```
kubectl set image deployment/flask-app flask-app=jtllab/flask-to-do-app:v2
```
2) Check rollout status
```
kubectl rollout status deployment/flask-app
```
3) Confirm that pod replicas are running correct version
```
kubectl describe pod [POD_NAME]
```
### Part 7: Health monitoring
- Configured a livenessProbe and readinessProb to verify that i) pod is alive and healthy and ii) pod is ready to receive traffic. 
- Added /health and /live endpoints to app.py for probes that return status code 200. 
- Configured Kubernetes to restart the pod if a probe fails. 
- Added /crash endpoint to test pod failure.

Verify probes are returning status code 200 while pod is healthy and live: 
```
kubectl logs [DEPLOYED APP ID]
```

Trigger the /crash endpoint and verify that probes work to restart the pod: 
```
url=$(minikube service flask-app-service --url)
curl "${url}/crash"
```
### Part 8: Prometheus Health Alerting
Set up namespace for monitoring: 
```
kubectl create namespace monitoring
```

Create all Prometheus related resources in monitoring namespace: 
```
kubectl apply -f prometheus/
```

Verify that everything deployed successfully: 
```
kubectl get deployments -n monitoring
kubectl get services -n monitoring
```

Get endpoint url and test application crash to verify that notification sends: 
```
url=$(minikube service flask-app-service --url)
curl "${url}/crash"
```

Check that a pod restarted (may need to wait a few seconds and recheck, sometimes takes a bit to update): 
```
kubectl get pods
```

## Testing Part 8

---
Delete all the Previous Resources
- kubectl get all -n monitoring
- kubectl delete deployment -n monitoring --all
- kubectl delete service -n monitoring --all

Create the new Instances
- kubectl apply -f prometheus/
- kubectl rollout restart deployment prometheus-deployment -n monitoring

Trigger the failure
- kubectl scale deployment flask-app --replicas=0
- kubectl delete deployment flask-app-<id>

Access Prometheus UI [Prometheus UI](http://localhost:9090)
- kubectl port-forward svc/prometheus-service 9090:9090 -n monitoring

Access AlertManager [AlertManager UI](http://localhost:9093)
- kubectl port-forward svc/alertmanager 9093:9093 -n monitoring

---

## General Commands

### Docker Commands
- docker version
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

### Minikube CLI (only used for start/delete local K8 cluster)
[Minikube Documentation](https://minikube.sigs.k8s.io/docs/handbook/controls/)
- minikube start --kubernetes-version=latest
- minikube service flask-app-service --url
- minikube stop
- minikube delete
- minikube delete --all
- minikube dashboard

### Kubectl Commands
- kubectl get po -A
- kubectl apply -f flask-to-do-app-deployment.yml
- kubectl apply -f mongodb-deployment.yml
- kubectl expose -f flask-to-do-app-service.yml
- kubectl expose -f mongodb-service.yml
- kubectl get all
- kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'
- kubectl get services --sort-by=.metadata.name
- kubectl get configmap
- kubectl get secret
- kubectl get crd
- kubectl get statefulset
- kubectl describe statefulset prometheus-prometheus-kube-prometheus-prometheus > prom-statefulset.yml
- kubectl get deployment
- kubectl get deployment prometheus-kube-prometheus-operator -o yaml
- kubectl get deployment prometheus-kube-prometheus-operator > prom-k8-oper.yml
- kubectl get prometheusrules
- kubectl -n monitoring delete pod,svc --all
- kubectl expose deployment prometheus-kube-prometheus-operator --type=NodePort --port=8080
- kubectl apply -f alert-manager-config-map.yml
- kubectl delete pods -l app=alertmanager -n monitoring
- kubectl delete pods --all -n monitoring
- kubectl delete pods --all -A
- kubectl delete all --all -n monitoring
- kubectl delete all --all -A
- kubectl get pods -l app=alertmanager -n monitoring
- kubectl logs <alertmanager-pod-name> -n monitoring

### Debugging, Troubleshooting
- kubectl get deployments -n monitoring
- kubectl get statefulsets -n monitoring
- kubectl get pods -n monitoring --show-labels
- kubectl get all -n monitoring
- kubectl get services -n monitoring
- kubectl get events -n monitoring
- kubectl delete deployment -n monitoring --all
- kubectl delete service -n monitoring --all
- kubectl delete daemonsets -n monitoring --all
- kubectl delete pvc -n monitoring --all
- kubectl rollout restart deployment prometheus-deployment -n monitoring

### Remove Prometheus resources created by prometheus-kube operator (from Helm)
- kubectl delete prometheus --all -n default
- kubectl delete alertmanager --all -n default
- kubectl get servicemonitors -n default
- kubectl get podmonitors -n default
- kubectl delete servicemonitors --all -n default
- kubectl delete podmonitors --all -n default

### Getting the prometheus.yml file
- kubectl get deployment prometheus-deployment -n monitoring -o yaml
- kubectl get configmap prometheus-server-conf -n monitoring -o yaml
- kubectl edit configmap prometheus-server-conf -n monitoring
- kubectl delete configmap prometheus-server-conf -n monitoring
- kubectl apply -f config-map.yml
- kubectl get pods -n monitoring
- kubectl logs prometheus-deployment-69c955b584-kp2wv -n monitoring

### K8 Dashboard
- kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

[kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---
---
## Part 8: Alerting - Setup Instructions

### Part 8: Instructions for Alerting (Cluster Monitoring from all K8 components)
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
    kubectl describe deployment prometheus-kube-prometheus-operator > describe-prom-oper.yml
    kubectl get deployment prometheus-kube-prometheus-operator > prom-k8-oper.yml
    kubectl get deployment flask-app > prom-todoapp.yml
    ```
6. Install [kube-state-metrics](https://kubernetes.github.io/kube-state-metrics/) as a Helm chart. [kube-state-metrics Helm Chart](https://artifacthub.io/packages/helm/bitnami/kube-state-metrics).
7. Signup for a Grafana account. Connect Grafana with Prometheus.
8. Signup for a Slack account. Create a Slack Channel. The Slack Channel will be the output channel to receive alerts from Prometheus based on triggered rules' conditions.

### Part 8: Instructions for Alerting (from TA link)
All files are located in folder: prometheus

Steps
1. Create a RBAC role for Prometheus to call K8 endpoints on the object.
2. Create a Config Map between Prometheus and K8.
3. Get the list of PrometheusRule resources in the cluster.
4. Get further details of the rule.
5. Create a Prometheus deployment file.
6. Check the created deployment.

```
kubectl create -f clusterRole.yml
kubectl create -f config-map.yml
kubectl create -f prometheus-deployment.yml
kubectl apply -f prometheus/

kubectl get prometheusrules
kubectl describe prometheusrule prometheus-kube-prometheus-alertmanager.rules
```

### Connecting to the Prometheus Dashboard
#### Method1: kubectl Port Forwarding (from local machine)
1. Run the CMD: (replace with your <pod name>)
    ```
    kubectl get pods --namespace=monitoring
    kubectl port-forward prometheus-deployment-5549c769cc-wxjlg 8080:9090 -n monitoring
    ```
2. Check the Prometheus Dashboard at: http://localhost:8080

#### Method2: Expose Prometheus as a Kubernetes Service
1. Create the prometheus-service.yml file. It will expose Prometheus on all kubernetes node IP’s on port 30000.
2. Create the service by running:
    ```
    kubectl create -f prometheus-service.yml --namespace=monitoring
    ```
3. Once created, you can access the Prometheus dashboard using any of the Kubernetes node’s IP on port 30000. (ie: http://192.168.49.2:30000)
```
kubectl get nodes -o wide
kubectl get svc prometheus-service -n monitoring
```

Files created:
- clusterRole.yml
- config-map.yml
- prometheus-deployment.yml
- prometheus-service.yml

---
#### Kube State Metrics
Kube State Metrics is a service that talks to the Kubernetes API server to get all the details about all the API objects like deployments, pods, daemonsets, Statefulsets, etc. It provides kubernetes objects & resources metrics that you cannot get directly from native Kubernetes monitoring components.

[Kube State Metrics](https://devopscube.com/setup-kube-state-metrics/)

kubectl get pods -n monitoring -l k8s-app=kube-state-metrics
kubectl get svc -n monitoring kube-state-metrics

#### Grafana
- kubectl port-forward service/grafana 3000:3000 -n monitoring
- kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana -n monitoring
- minikube service grafana --url -n monitoring

Access the dashboard at [local](http://127.0.0.1:51918/?orgId=1)
user: admin
pass: 6998a1

[Grafana step-by-step guide AlertManager with Slack](https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/)
[TA resource - devopscube](https://devopscube.com/alert-manager-kubernetes-guide/)
[Prometheus alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)

---
## Python venv Instructions
Run at the Project root folder.
```
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
pip3 install --upgrade pip
```

To deactivate the venv:
```deactivate```

---
## References
- [kubectl cmds](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [minikube docs](https://minikube.sigs.k8s.io/docs/start/)
- [helm install](https://helm.sh/docs/helm/helm_install/)
- [prometheus k8 stack docs](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [TA link prometheus k8 tutorial](https://devopscube.com/setup-prometheus-monitoring-on-kubernetes/)
- [Kube State Metrics](https://devopscube.com/setup-kube-state-metrics/)
- [Slack - create incoming webhooks for alerts](https://api.slack.com/messaging/webhooks)

---
