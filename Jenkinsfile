pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        DOCKER_IMAGE_NAME = "testapp" // O el nombre real de tu imagen
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
                    docker.build('enardelg/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}') // Construir con el repositorio destino actualizado
                }
                script {
                    docker.image('enardelg/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}').inside {
                        sh 'npm install'
                    }
                }
            }
        }

        stage('Ejecutar pruebas') {
            steps {
                script {
                    docker.image('enardelg/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}').inside {
                        sh 'npm install && npm test'
                    }
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub') {
            steps {
                script {
                    // Asumiendo que las credenciales están configuradas como 'dockerhub-credentials'
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image('enardelg/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}').push()
                    }
                }
            }
        }
    }
}

