
pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        DOCKER_IMAGE_NAME = "testapp"
        DOCKER_REGISTRY = "docker.io"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Building image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run tests') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").withRun('-d -p 8081:8080') {
                        sleep 5 // Asegúrate de que la aplicación dentro del contenedor esté completamente iniciada
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Deploy Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", 'pin1') {
                        docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}

