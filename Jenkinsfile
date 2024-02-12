pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        ARTIFACT_ID = "elbuo8/webapp:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "192.168.0.28:5000/mguazzardo"
        IMAGE_NAME = "testapp"
    }

    stages {
        stage('Building image') {
            steps {
                sh '''
                docker build -t $DOCKER_REGISTRY/$IMAGE_NAME .
                '''
            }
        }

        stage('Run tests') {
            steps {
                sh "docker run $DOCKER_REGISTRY/$IMAGE_NAME npm test"
            }
        }

        stage('Deploy Image') {
            steps {
                sh '''
                docker tag $IMAGE_NAME $DOCKER_REGISTRY/$IMAGE_NAME
                docker push $DOCKER_REGISTRY/$IMAGE_NAME
                '''
            }
        }
    }
}


    
  

