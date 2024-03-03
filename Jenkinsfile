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
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ?: env.BUILD_NUMBER}"
                    docker.build(imageName)
                    docker.image(imageName).inside {
                        sh 'npm install' // O cualquier comando necesario
                    }
                }
            }
        }

        stage('Ejecutar pruebas') {
            steps {
                script {
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ?: env.BUILD_NUMBER}"
                    def containerId = sh(script: "docker run -d -p 3000:3000 ${imageName}", returnStdout: true).trim()
                    sh "docker exec -it ${containerId} npm install && npm test"
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub') {
            steps {
                script {
                    def imageName = "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ?: env.BUILD_NUMBER}"
                    docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
                        docker.image(imageName).push()
                    }
                }
            }
        }
    }
}
