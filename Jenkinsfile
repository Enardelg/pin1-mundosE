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
                    // Construir la imagen y ejecutar pruebas
                    docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
                        sh 'npm install && npm test'
                    }

                    // Mapear el puerto 3000 del host al puerto 3000 del contenedor
                    sh 'docker run -p 3000:3000 -d enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}'
                }
            }
        }

        stage('Desplegar la imagen en Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }

   post {
    always {
        script {
            // Detener y eliminar el contenedor después de ejecutar las pruebas
            sh 'docker stop $(docker ps -q --filter ancestor=enardelg/testapp:1.0.0)'
            sh 'docker rm $(docker ps -a -q --filter ancestor=enardelg/testapp:1.0.0)'
        }
      }
    }
} 

