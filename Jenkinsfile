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
                        // Agregar la ruta de npm al PATH
                        sh 'export PATH=$PATH:/usr/bin && apk add --no-cache nodejs npm'
                        sh '/usr/bin/npm install'
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").withRun('-p 8083:8080') {
                        // Agregar la ruta de npm al PATH
                        sh 'export PATH=$PATH:/usr/bin && /usr/bin/npm test'
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

