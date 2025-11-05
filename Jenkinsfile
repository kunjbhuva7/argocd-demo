pipeline {
    agent any

    environment {
        DOCKERHUB_CRED = credentials('dockerhub-token')
        GIT_CRED = credentials('9800007e-a15c-44c7-a832-6dd7d875fadd')
        IMAGE = "kunj22/nginx-demo"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/kunjbhuva7/argocd-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                echo $DOCKERHUB_CRED_PSW | docker login -u $DOCKERHUB_CRED_USR --password-stdin
                docker push $IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                sh '''
                sed -i "s|image: .*|image: $IMAGE:$BUILD_NUMBER|" app/deployment.yaml
                git config user.email "jenkins@kunjbhuva7.com"
                git config user.name "Jenkins"
                git add app/deployment.yaml
                git commit -m "update image to $BUILD_NUMBER"
                git push https://$GIT_CRED_USR:$GIT_CRED_PSW@github.com/kunjbhuva7/argocd-demo.git HEAD:main
                '''
            }
        }
    }
}

