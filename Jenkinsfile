pipeline {
    agent any
    environment {
        IMAGE_NAME = "jenkins-cicd-app"
        GHCR_IMAGE = "ghcr.io/qandeland/jenkins-cicd-app"
        COMPOSE_FILE = "docker-compose.app.yml"
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Run Tests') {
            steps {
                sh 'cd app && pip3 install -r requirements.txt --quiet --break-system-packages && pytest tests/ -v'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        docker run --rm \
                            --network host \
                            -e SONAR_HOST_URL=http://localhost:9000 \
                            -e SONAR_TOKEN=$SONAR_TOKEN \
                            -v ${WORKSPACE}/app:/usr/src \
                            sonarsource/sonar-scanner-cli \
                            -Dsonar.projectKey=jenkins-cicd \
                            -Dsonar.sources=/usr/src \
                            -Dsonar.language=py
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER -t $IMAGE_NAME:latest app/'
            }
        }
        stage('Scan Image') {
            steps {
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL $IMAGE_NAME:$BUILD_NUMBER'
            }
        }
        stage('Push to GHCR') {
            steps {
                withCredentials([string(credentialsId: 'GHCR_TOKEN', variable: 'GHCR_TOKEN')]) {
                    sh 'echo $GHCR_TOKEN | docker login ghcr.io -u qandeland --password-stdin'
                    sh 'docker tag $IMAGE_NAME:$BUILD_NUMBER $GHCR_IMAGE:$BUILD_NUMBER'
                    sh 'docker tag $IMAGE_NAME:latest $GHCR_IMAGE:latest'
                    sh 'docker push $GHCR_IMAGE:$BUILD_NUMBER'
                    sh 'docker push $GHCR_IMAGE:latest'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker rm -f flask-app || true'
                sh 'docker-compose -f $COMPOSE_FILE up -d'
            }
        }
    }
    post {
        success { echo 'Pipeline completed successfully' }
        failure { echo 'Pipeline failed' }
    }
}
