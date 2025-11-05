pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
        IMAGE_NAME = "kunj22/nginx-demo"
        GIT_CREDENTIALS = credentials('github-token')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kunjbhuva7/argocd-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh """
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push $IMAGE_NAME:$BUILD_NUMBER
                """
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                sh """
                sed -i 's|image: .*$|image: $IMAGE_NAME:$BUILD_NUMBER|' app/deployment.yaml
                git config user.email "jenkins@kunjbhuva7.com"
                git config user.name "Jenkins"
                git add app/deployment.yaml
                git commit -m "Updated image tag to $BUILD_NUMBER"
                git push https://$GIT_CREDENTIALS_USR:$GIT_CREDENTIALS_PSW@github.com/kunjbhuva7/argocd-demo.git HEAD:main
                """
            }
        }
    }
}

