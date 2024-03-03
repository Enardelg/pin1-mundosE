pipeline {
  // Define cualquier agente para ejecutar el pipeline
  agent any

  // Define un tiempo máximo de ejecución de 2 minutos
  options {
    timeout(time: 2, unit: 'MINUTES')
  }

  // Define variables de entorno
  environment {
    DOCKER_IMAGE_NAME = "testapp"
    DOCKER_IMAGE_VERSION = "1.0.0" // Opcional
  }

  // Define las etapas del pipeline
  stages {
    // Etapa 1: Obtener el código fuente del SCM (ej. Git)
    stage('Checkout SCM') {
      steps {
        // Ejecutar el comando "checkout scm" para obtener el código fuente
        checkout scm
      }
    }

    // Etapa 2: Construir la imagen de Docker
    stage('Construcción de la imagen') {
      steps {
        // Construir la imagen con la etiqueta especificada
        script {
          docker.build("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}")
        }

        // Entrar al contenedor e instalar dependencias (ej. npm install)
        script {
          docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
            sh 'npm install' // O cualquier comando necesario
          }
        }
      }
    }

    // Etapa 3: Ejecutar pruebas
    stage('Ejecutar pruebas') {
      steps {
        // Entrar al contenedor, instalar dependencias y ejecutar pruebas
        script {
          docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
            sh 'npm install && npm test' // O tu comando de pruebas
          }
        }
      }
    }

    // Etapa 4: Desplegar la imagen en Docker Hub
    stage('Desplegar la imagen en Docker Hub') {
      steps {
        // Autenticarse en Docker Hub e insertar la imagen
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
            docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
          }
        }
      }
    }
  }
}

// correr este comando, para mepear el puerto 3000 del host local:     docker run -p 3000:3000 -t -d enardelg/testapp:1.0.0

