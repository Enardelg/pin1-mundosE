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

        stage('Construir imagen (Image Building)') {
            steps {
                script {
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}"
                    docker.build(imageName)
                    docker.image(imageName).inside {
                        sh 'npm install' // O cualquier comando necesario
                    }
                }
            }
        }

        stage('Ejecutar pruebas (Run Tests)') {
            steps {
                // No se necesitan cambios aquí, su código actual funciona bien
            }
        }

        stage('Ejecutar imagen mapeada al puerto 3000 (Run Image Mapped to Port 3000)') {
            steps {
                script {
                    def registryUrl = 'https://index.docker.io/v1/'
                    def registryCredential = 'pin1'
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}"
                    docker.withRegistry(registryUrl, registryCredential) {
                        docker.image(imageName).run(
                            ports: [3000: 3000]
                        )
                    }
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub (Deploy Image to Docker Hub)') {
            steps {
                script {
                    def registryUrl = 'https://index.docker.io/v1/'
                    def registryCredential = 'pin1'
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}"
                    docker.withRegistry(registryUrl, registryCredential) {
                        docker.image(imageName).push()
                    }
                }
            }
        }
    }
}

