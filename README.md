# My ArgoCD Apps

## Applications
- simple-webapp: Nginx deployment with service

Kubernetes manifests managed by ArgoCD.
![](/img/argo.png).
![](/img/kubernetes.png).


## Prerequisite
    - Docker (https://www.docker.com/)
    - Minikube (https://minikube.sigs.k8s.io/docs/) # for Development Testing
    - Kubernetes (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
    - Argo CD (https://argo-cd.readthedocs.io/en/stable/)
    - gh (https://cli.github.com/)
    - jq (https://doc.ubuntu-fr.org/json_query)


## Structure
- `manifests/` - Kubernetes resource files
    - `application.yaml` - ArgoCD Application definition
    - `deployment.yaml` 
    - `ingress.yaml` 
    - `service.yaml`


## Installation 
```bash
# Install gh
sudo apt install gh

# create SSH Token in Github with Development Settings Menu
gh auth login

# set GITHUB env for first access
GITHUB_USER=<>
git config --global user.name $GITHUB_USER

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

# Se connecter via CLI
    argocd login localhost:8080 --username admin --password $argocd_password
```

## Deploy with Argo CD
```bash
# Appliquer l'application Argo CD
kubectl apply -f manifests/application.yaml
```

# Checking Argo CD Deployment
```bash

kubectl get app -n argocd
kubectl get pods -l app=simple-webapp
kubectl get app simple-webapp -n argocd -w
```