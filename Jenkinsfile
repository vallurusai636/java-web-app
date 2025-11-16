pipeline {
  agent any
  }
  stages {
    stage('Checkout') {
      steps { 
        git branch: 'main', url: 'https://github.com/vallurusai636/java-web-app.git'
    }
    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
  }  
    
