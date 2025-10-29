#!/bin/bash

# Variables - À MODIFIER !
GITHUB_USER="votre_username"
REPO_NAME="my-argocd-apps"

# Créer le dépôt avec GitHub CLI
echo "📦 Création du dépôt GitHub..."
gh repo create $REPO_NAME --public --description "Kubernetes manifests for ArgoCD" --confirm

# Cloner
echo "📥 Clonage du dépôt..."
gh repo clone $GITHUB_USER/$REPO_NAME
cd $REPO_NAME

# Créer la structure
echo "📁 Création de la structure..."
mkdir manifests

cat > manifests/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-webapp
  labels:
    app: simple-webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: simple-webapp
  template:
    metadata:
      labels:
        app: simple-webapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF

cat > manifests/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: simple-webapp
spec:
  selector:
    app: simple-webapp
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF

cat > application.yaml << EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: simple-webapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/$GITHUB_USER/$REPO_NAME.git
    targetRevision: main
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

# Pousser vers GitHub
echo "🚀 Pousser vers GitHub..."
git add .
git commit -m "Initial commit: ArgoCD application"
git push

# Déployer avec Argo CD
echo "🎯 Déploiement Argo CD..."
kubectl apply -f manifests/application.yaml

echo "✅ Terminé ! Vérifiez l'application dans Argo CD:"
echo "kubectl get applications -n argocd"