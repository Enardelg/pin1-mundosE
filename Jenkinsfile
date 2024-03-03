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
          sh """
            docker run -d \
              -p 3000:3000 \
              enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}
          """
        }
      }
    }

    stage('Ejecutar pruebas') {
      steps {
        script {
          sh """
            docker exec -it \
              $(docker ps -lq --filter name=enardelg-${DOCKER_IMAGE_NAME}-${env.BUILD_NUMBER}) \
              npm install && npm test
          """
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
}

