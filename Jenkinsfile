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
        stage('Obtener código') {
            steps {
                checkout scm
            }
        }

        stage('Construir imagen') {
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

        stage('Desplegar imagen en Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
                        docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
                    }
                }
            }
        }

        **Nueva etapa: Mapeo del puerto 3000**
        stage('Ejecutar imagen mapeada al puerto 3000') {
            steps {
                script {
                    // Puedes elegir un puerto diferente para el mapeo del contenedor si lo necesitas
                    def puertoContenedor = 3000
                    def puertoHost = 3000 // Ajusta esto si quieres un puerto de host diferente

                    docker.run(
                        image: "enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}",
                        portMappings: [[containerPort: puertoContenedor, hostPort: puertoHost]]
                    )
                }
            }
        }
    }
}
