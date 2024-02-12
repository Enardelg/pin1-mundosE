pipeline {
    agent any

    options {
        timeout(time: 2, unit: 'MINUTES')
    }

    environment {
        ARTIFACT_ID = "enardelg/testapp:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "enardelg"
        IMAGE_NAME = "testapp"
    }

    stages {
        stage('Building image') {
            steps {
                sh '''
                docker build -t $DOCKER_REGISTRY/$IMAGE_NAME .
                '''
            }
        }

        stage('Run tests') {
            steps {
                sh "docker run $DOCKER_REGISTRY/$IMAGE_NAME npm test"
            }
        }

        stage('Deploy Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '52260b70-8643-4fcf-a2ad-187c7cc474bb', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                            docker tag $IMAGE_NAME $DOCKER_REGISTRY/$IMAGE_NAME
                            docker push $DOCKER_REGISTRY/$IMAGE_NAME
                        '''
                    }
                }
            }
        }
    }
}

  

