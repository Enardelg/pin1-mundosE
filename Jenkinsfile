pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        ARTIFACT_ID = "enardelg/testapp:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "enardelg"
        IMAGE_NAME = "testapp"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

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
                script {
                    withCredentials([usernamePassword(credentialsId: 'ID_DE_TUS_CREDENCIALES', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker tag $IMAGE_NAME $DOCKER_REGISTRY/$IMAGE_NAME
                            docker push $DOCKER_REGISTRY/$IMAGE_NAME
                        '''
                    }
                }
            }
        }
    }
}

  

