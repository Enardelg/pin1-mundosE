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
                    def containerId = docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").run('-p 8081:8080', detach: true)
                    sleep 10 // Asegúrate de que la aplicación dentro del contenedor esté completamente iniciada
                    try {
                        sh "docker exec ${containerId} npm test"
                    } finally {
                        docker.stop(containerId)
                        docker.remove(containerId)
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

