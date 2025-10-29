# My ArgoCD Apps

## Installation 

### gh 
```bash
# Install gh
sudo apt install gh
```
### env
```bash
# create SSH Token in Github with Development Settings Menu
gh auth login

# set GITHUB env for first access
GITHUB_USER=<>
git config --global user.name $GITHUB_USER

```
# Push on Github 
```bash
git add .
git commit -m "Initial commit: ArgoCD application and manifests"
git push -u origin main
git log --oneline
```

