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

**4.Créer un compte sur Docker Hub**
-Ajouter un gestionnaire d'informations d'identification aux plugins de pipeline

**5. Pipeline Jenkins**
```consol 

pipeline {
    agent any 
    environment {
        DOCKER_CREDENTIALS = credentials('docker')
    }
    stages {
        stage('Git Clone') {
            steps {
                sh('''
                git clone https://github.com/simplon-choukriraja/Brief8-Raja
                ''')
            }
        }
    }
        stage('Build image') {
            steps {
                sh('''
                    cd Brief8-Raja
                    sudo docker build -t app-vote
                    #pour utiliser sudo, vous devez effectuer les commandes suivantes sur le terminal:  
                    # sudo su 
                    # vi sudo -f/etc/sudoers
                    # ajouter:JENKINS ALL= NOPASSWD:ALL
                ''')
            }
        }
        stage('Login') {
            steps {
                sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u raja-8 $DOCKER_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push image')
            steps { 
                sh ('''
                sudo docker tag app-vote raja-8/app-vote:/044PATCH
                sudo docker push raja-8/app-vote:/044PATCH)
            }
        }
        
        stage('Add -n qal end modify the TAG')
            steps {
                withKubeConfig([credentialsId: 'aks']) {
                    sh('''
                    git clone https://github.com/simplon-choukriraja/brief7-votinapp.git app
                    TAG=\044(curl -sSf https://registry.hub.docker.com/v2/repositories/simplonasa/azure_voting_app/tags |jq '."results"[0]["name"]'| tr -d '"')
                    sed -i "s/TAG/\044{TAG}/" ./app/vote.yml
                    kubectl apply -f ./app
                    kubens qal
                    ''')
                }
            }
        }

    
        post {
          always {
            // Nettoyage de l'espace de travail Jenkins
            step([$class: 'WsCleanup'])
        }
    }
}

'''
