pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "yourdockerhub/java-web-app"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
          sh '''
            docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
            echo $PWD | docker login -u $USER --password-stdin
            docker push $DOCKER_IMAGE:$BUILD_NUMBER
          '''
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl -n default set image deployment/java-web-app java-web-app=$DOCKER_IMAGE:$BUILD_NUMBER --record || true
          kubectl apply -f k8s/
        '''
      }
    }
  }
}
