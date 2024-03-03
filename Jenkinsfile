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
        script {
          // Entrar al contenedor, instalar dependencias y ejecutar pruebas
          docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").inside {
            sh 'npm install && npm test'
          }

          // Mapear el puerto 3000 del host al puerto 3000 del contenedor en segundo plano (-d)
          sh 'docker run -p 3000:3000 -d enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}'
        }
      }
    }

    // Etapa 4: Desplegar la imagen en Docker Hub
    stage('Desplegar la imagen en Docker Hub') {
      steps {
        script {
          // Autenticarse en Docker Hub e insertar la imagen
          docker.withRegistry('https://index.docker.io/v1/', 'pin1') {
            docker.image("enardelg/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION ? DOCKER_IMAGE_VERSION : env.BUILD_NUMBER}").push()
          }
        }
      }
    }
  }

  // Sección posterior a la ejecución del pipeline
  post {
    // Siempre después de cada ejecución
    always {
      script {
        // Detener y eliminar cualquier contenedor en ejecución con la imagen especificada
        if (docker ps -q --filter ancestor=enardelg/testapp:1.0.0) {
          docker stop enardelg/testapp:1.0.0
        }
      }
    }
  }
}

