pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        DOCKER_IMAGE_NAME = "testapp"
        DOCKER_IMAGE_VERSION = "1.0.0" // Opcional
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Construcción de la imagen') {
            steps {
                script {
                    docker.build("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}")
                }
                script {
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
                        sh 'npm install' // O cualquier comando necesario
                    }
                }
            }
        }

        stage('Ejecutar pruebas') {
            steps {
                script {
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
                        sh 'npm install && npm test' // O tu comando de pruebas
                    }
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}

