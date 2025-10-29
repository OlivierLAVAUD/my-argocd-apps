# My ArgoCD Apps

## Applications
- simple-webapp: Nginx deployment with service

Kubernetes manifests managed by ArgoCD.
![](/img/argo.png).
![](/img/kubernetes.png).


## Prerequisite
    - Docker (https://www.docker.com/)
    - Minikube (https://minikube.sigs.k8s.io/docs/) # for Development Tests
    - Kubernetes (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) # for Production
    - Argo CD (https://argo-cd.readthedocs.io/en/stable/)
    - gh (https://cli.github.com/)
    - jq (https://doc.ubuntu-fr.org/json_query)


## Structure
```text
├── img
│   ├── argo.png
│   └── kubernetes.png
├── manifests
│   ├── application.yaml
│   ├── deployment.yaml
│   ├── ingress.yaml
│   └── service.yaml
├── README.md
```
## Installation 

### Clone the repo 
```bash
    git clone https://github.com/OlivierLAVAUD/my-argocd-apps.git
    cd my-argocd-apps
```
### Install Minikube for Development Testing, Otherwise install Kubernetes 

```bash
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
    minikube start
```

### Install Argo CD with Kubernetes
```bash
    # create namespace Argo CD
    kubectl create namespace argocd

    # install Argo CD with kubernetes
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    # check install
    kubectl get pods -n argocd --watch

    # get initial password
    argocd_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo $argocd_password

```

### Acces to Argo CD with a localhost Web Interface
```bash

    # Port-forward for access to Local UI :
    kubectl port-forward svc/argocd-server -n argocd 8080:443

    # https://localhost:8080 with admin/password = admin/<$argocd_password>
```

### Access to Argo CD with CLI
```bash
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

# Get connect with Argo CD  CLI
    argocd login localhost:8080 --username admin --password $argocd_password
```

## Deploy Application with Argo CD Manifests
```bash
# Deploy App
kubectl apply -f manifests/application.yaml

# Application Description
kubectl describe deployment simple-webapp
```

# Checking Argo CD Deployment
```bash

kubectl get app -n argocd
kubectl get pods -l app=simple-webapp
kubectl get app simple-webapp -n argocd -w
```

# Cleaning
```bash

argocd app delete simple-webapp
kubectl delete -f /manifests/application.yaml

minikube stop
minikube delete

# Delete in Docke
eval $(minikube docker-env -u)
```