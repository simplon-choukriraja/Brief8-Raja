```consol

pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                sh('''
                git clone https://github.com/simplon-choukriraja/Brief8-Raja.git
                ''')
            }
        }
        
        
        stage('Build Image') {
            steps {
                sh ('''
                cd Brief8-Raja
                sudo docker build -t vote-app .
                ''')
            }
        }
        
        
        stage('Push') {
            steps {
                sh ('''
                PATCH=$(cat Brief8-Raja/azure-vote/main.py | grep "ver = ".*"" | grep -oE "[0-9]+\\.[0-9]+\\.[0-9]+")
                sudo docker tag vote-app raja8/vote-app:\044PATCH
                sudo docker push raja8/vote-app:\044PATCH
    
                ''')
            }
        }
        
        stage('Clone repository app-vote') {
            steps {
                withKubeConfig([credentialsId: 'aks']) {
                    sh('''
                    git clone https://github.com/simplon-choukriraja/brief7-votinapp.git app
                    TAG=\044(curl -sSf https://registry.hub.docker.com/v2/repositories/raja8/vote-app/tags |jq '."results"[0]["name"]'| tr -d '"')
                    sed -i "s/TAG/\044{TAG}/" ./app/vote.yml
                    kubens qal
                    kubectl apply -f ./app 
                    ''')
                }
            }
        }
        
        stage('Test de charge'){
            steps{
                sh('''
                seq 250 | parallel --max-args 0  --jobs 10 "curl -k -iF 'vote=Pizza' http://vote.simplon-raja.space"
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

