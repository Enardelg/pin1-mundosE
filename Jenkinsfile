pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        ARTIFACT_ID = "enardelg/testapp:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "docker.io"  // Cambiado a docker.io para DockerHub
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
                    withCredentials([usernamePassword(credentialsId: '52260b70-8643-4fcf-a2ad-187c7cc474bb', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        echo "DOCKER_USERNAME: $DOCKER_USERNAME"
                        echo "DOCKER_PASSWORD: $DOCKER_PASSWORD"
                        echo "DOCKER_REGISTRY: $DOCKER_REGISTRY"
                        
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


