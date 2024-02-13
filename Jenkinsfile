pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        // Reemplaza con el nombre real de tu imagen
        DOCKER_IMAGE_NAME = "testapp"
        // Reemplaza con la versión deseada (opcional)
        DOCKER_IMAGE_VERSION = ""
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Construcción de la imagen') {
            steps {
                // Construye la imagen, usando la versión si está definida
                script {
                    docker.build("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}")
                }
                // Ejecuta comandos dentro del contenedor (opcional)
                script {
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
                        sh 'npm install' // O cualquier comando necesario
                    }
                }
            }
        }

        stage('Ejecutar pruebas') {
            steps {
                // Ejecuta tests dentro del contenedor (opcional)
                script {
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
                        sh 'npm install && npm test' // O tu comando de pruebas
                    }
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub') {
            steps {
                // Asegúrate de tener credenciales configuradas como 'dockerhub-credentials'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}
