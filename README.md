# My ArgoCD Apps

This project illustrates a concrete implementation of the GitOps methodology for automated application deployment on Kubernetes. Using Argo CD as the synchronization engine, it demonstrates how to maintain a fully declarative, versioned, and self-patching cloud-native environment.

The deployed application is a simple Nginx webapp, but the architecture presented applies to any containerized application. All infrastructure configuration is managed as code, enabling complete traceability and reproducible deployments.

## Applications
- simple-webapp: Nginx deployment with service on Kubernetes


![](/img/kubernetes.png).

- Kubernetes manifests managed by ArgoCD.

![](/img/argo.png).



## Prerequisite
- [Docker | Containerization platform](https://www.docker.com/)
- [Kubernetes(K8S) | Container orchestration](https://kubernetes.io/releases/download/) - for Production Usage
- [Minikube | Local Kubernetes cluster](https://minikube.sigs.k8s.io/docs/) - for Development Usage
- [Argo CD | GitOps continuous delivery ](https://argo-cd.readthedocs.io/en/stable/)
- [gh (GitHub CLI) | GitHub command line interface](https://cli.github.com/)
- [jq | JSON processor](https://doc.ubuntu-fr.org/json_query)


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

### Install Argo CD on Kubernetes
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

## Deploy Application
### with Argo CD Manifests
```bash
# Deploy App
kubectl apply -f manifests/application.yaml

# Application Description
kubectl describe deployment simple-webapp
```

### Checking Argo CD Deployment
```bash

kubectl get app -n argocd
kubectl get pods -l app=simple-webapp
kubectl get app simple-webapp -n argocd -w
```

## Clean & Uninstall
### Delete Application
```bash
argocd app delete simple-webapp
kubectl delete -f /manifests/application.yaml
```

### Uninstall Argo CD

```bash
# Delete Argo CD from Kubernetes
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Delete Namespace
kubectl delete namespace argocd
```

### Stop and Clean Minikube
```bash
minikube stop
minikube delete
```

### Delete in Docker
```bash
eval $(minikube docker-env -u)
```


## Note: Application Deployment Methodology (demo-app sample)

### Create a Namespace in Kuberneretes to host Application 
```bash
kubectl create namespace demo-app
```


### Use Argo CD Web Interface (https://localhost:8080) 
```bash
    # 1. Access to web interface (https://localhost:8080) 
    # 2. Create new Application and complete the following form 
    # NEW APP
    #     Application Name: my-first-app
    #     Project: default
    #     Sync Policy: Manual
    # SOURCE
    #   Repository URL: https://github.com/argoproj/argocd-example-apps.git
    #   Revision: HEAD
    #   Path: guestbook
    #
    # DESTINATION:
    #   Cluster URL: https://kubernetes.default.svc
    #   Namespace: demo-app
    # 3. Click on CREATE
    # 4. Acces to your Github with authentification
    # 5. Click on SYNC 
    # select all the ressources
    # 6. Click on SYNCHRONIZE

```
### Using yaml Deployment Manifest 
```bash
kubectl apply -f app-deploy.yaml
```

### Using Argo CD CLI
```bash
argocd app create nginx-app \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace demo-app \
  --sync-policy automated \
  --auto-prune \
  --self-heal

# check app
argocd app list
argocd app get nginx-app
argocd app diff nginx-app
argocd app history nginx-app
```

### Using Advanced Application deployment
```bash
# create a local repository
mkdir my-argocd-demo && cd my-argocd-demo
git init

# create Kubernetes manifests
mkdir manifests

argocd app create custom-app \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace demo-app \
  --sync-policy automated
```

## Cleaning
### Delete Applications

```bash
argocd app delete my-first-app
argocd app delete nginx-app
argocd app delete custom-app
```
### Delete Namespace
```bash
kubectl delete namespace demo-app
```

### Uninstall Argo CD

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```
