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
                    docker.build("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}")
                }
                script {
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
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

        stage('Ejecutar imagen mapeada al puerto 3000 (Run Image Mapped to Port 3000)') { // Nueva etapa
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").run(
                            ports: [3000: 3000] // Mapea el puerto 3000 del contenedor al puerto 3000 del host
                        )
                    }
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub (Deploy Image to Docker Hub)') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}
