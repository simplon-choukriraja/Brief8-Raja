# **Brief 8 - Complete CI/CD**

### *Contexte du projet*

- Créer un pipeline qui automatise l'image Docker à chaque mise à jour.
- déployer un pipeline d'intégration et de déploiement continu pour l'application **AZURE VOTING** et sa base de données REDIS.

### *Méthode*

**1. J'ai créé le mv en utilisant les scripts du brief précédent (Brief7) : main.tf, variable.tf et providers.tf.**

Après avoir créé la machine virtuelle j'ai installé java et jenkins (j'ai eu du mal à installer jenkins car j'ai remarqué que la version de jenkins n'est plus compatible avec java 11 ou 17 , donc l'installation de jenkins a pris plus de temps que prévu).

Sur la mv j'ai installer:
* installé Azure Cli 
* Docker 
* jq 
* kubectl 
* Git

Après avoir pu accéder à Jenkins, j'ai installé des plugin: 

- Kubernetes Credential
- kubernetes Cli
- Kubernetes 
- Pipeline 
- Workspace Cleanup
- Docker API
- Docker commons
- Docker pipeline
- Docker plugin 
- Docker build-stcp

**2. J'ai créé un ClusterAKS.**
- Credential AKS -> permet de créer un lien entre les clusters Aks et le pipeline jenkins.
- kubectl create namespace qal
- kubectl create namespace prod.

**3. Récupérez le fichier kube.config et collez-le sur le pipeline.**

**4. Pipeline Jenkins**
