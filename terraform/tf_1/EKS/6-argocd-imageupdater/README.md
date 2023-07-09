## DOC
https://artifacthub.io/packages/helm/argo/argocd-image-updater

## Deploy
Antes de instalarmos o chart nós precisamos adicionar o repo

```ShellSession
helm repo add argo-cd https://argoproj.github.io/argo-helm

```

### Instalando nosso Argo CD 

```ShellSession
helm upgrade -i  argocd-image-updater argo-cd/argocd-image-updater -f .\values.yaml -n argocd --create-namespace
```

### Deixando o Argo CD se autogerenciar

Uma vez que a aplicação do Argo CD Image updater está sincronizada ela pode se autogerenciar as imagens. 
Para isso precisamos adicionar algumas tags na hora da criação do application:

    argocd-image-updater.argoproj.io/git-branch: main
    argocd-image-updater.argoproj.io/image-list: AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/backoffice:~v*
    argocd-image-updater.argoproj.io/write-back-method: git:secret:argocd/githubsecret

