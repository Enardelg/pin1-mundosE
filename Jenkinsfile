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
                script {
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").inside {
                        // No es necesario agregar la ruta de npm al PATH
                        sh 'npm install'
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                script {
                    docker.run("-p 8083:8080 --rm ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}", "npm install && npm test")
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
