pipeline {
    agent any

    environment {
        IMAGE_NAME = "jenkins-cicd-app"
        COMPOSE_FILE = "docker-compose.app.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    docker run --rm \
                        -v $(pwd)/app:/app \
                        -w /app \
                        python:3.11-slim \
                        sh -c "pip install -r requirements.txt --quiet && pytest tests/ -v"
                '''
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER app/'
            }
        }

        stage('Scan Image') {
            steps {
                sh 'docker run --rm aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL $IMAGE_NAME:$BUILD_NUMBER'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose -f $COMPOSE_FILE up -d'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
