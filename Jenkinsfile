pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "prathapreddy14/java-web-app"
    }

    stages {

        stage('Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/vallurusai636/java-web-app.git'
            }
        }

        stage('Build') {
            steps {
                echo "🏗️ Building jar file using Maven..."
                sh 'mvn -B -DskipTests clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        passwordVariable: 'DOCKER_PASS',
                        usernameVariable: 'DOCKER_USER'
                    )
                ]) {

                    sh '''
                        echo "🐳 Building Docker image..."
                        docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .

                        echo "🔐 Logging into DockerHub..."
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                        echo "🏷️ Tagging image as latest..."
                        docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest

                        echo "⬆️ Pushing version tag..."
                        docker push $DOCKER_IMAGE:$BUILD_NUMBER

                        echo "⬆️ Pushing latest tag..."
                        docker push $DOCKER_IMAGE:latest

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 Deploying application to Kubernetes..."

                // Use kubeconfig stored in Jenkins credentials
                withCredentials([file(credentialsId: 'eks-kubeconfig', variable: 'KUBECONFIG_FILE')]) {

                    sh '''
                        export KUBECONFIG=$KUBECONFIG_FILE

                        echo "📌 Applying Deployment YAML..."
                        kubectl apply -f deployment.yaml

                        echo "📌 Applying Service YAML..."
                        kubectl apply -f service.yaml

                        echo "🔄 Updating Deployment image..."
                        kubectl set image deployment/java-web-app \
                        java-web-app=$DOCKER_IMAGE:$BUILD_NUMBER --record

                        echo "⏳ Waiting for rollout to finish..."
                        kubectl rollout status deployment/java-web-app

                        echo "🎉 Deployment to Kubernetes completed!"
                    '''
                }
            }
        }
    }
}
