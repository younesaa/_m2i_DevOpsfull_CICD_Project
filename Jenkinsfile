pipeline {
    agent any
 
    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven3"
    }

    environment {
        DOCKER_CREDENTIALS_ID = "docker-credentials"
        DOCKER_REGISTRY = "ioannismac"
        DOCKER_IMAGE_NAME = "projet_m2i_app"
        DOCKER_IMAGE_TAG = "latest"
    }
 
    stages {
        stage('Checkout Code') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main' , url: 'https://github.com/ioannis-mac/proje_m2i.git', credentialsId: 'ioannis-mac-projet-fil-rouge'
            }
        }
        stage('Maven clean test') {
            steps {
                sh "mvn clean"
                sh "docker-compose -f docker-compose-test.yml up -d --build"
                sh "mvn test"
                script{
                    sh 'docker stop $(docker ps -a -q) || true'
                    sh 'docker container prune -f'
                }
            }
        }
        stage('Build Maven') {
            steps {
                sh "mvn -DskipTests clean package"
               }
        }
        stage('Archive Artifacts') {
            steps {
                // Archive the artifacts
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }
        stage('SonarQube Analysis') {
            steps {
                // Execute SonarQube analysis
                script {
                    withSonarQubeEnv('sonar_server') {
                        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
                    }
                }
            }
        }
        
        stage('Docker Login Build Push Clean') {
            steps {
                script {
                    // Login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                        sh "docker-compose build"
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                        sh "docker rmi ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} || true"
                    }
                }
            }
        }
        stage('Terraform'){
            steps{
                script{
                    sh '''
                        az login --username machaliotis.ioannis@m2iFormation1.onmicrosoft.com --password Passazure1!
                        az account set --subscription 9a86476e-b022-4aa8-9372-dab324cf625d
                    '''
                    sh "terraform init"
                    sh "terraform plan -out=planfile "
                    sh "terraform apply -auto-approve planfile"
                    sh "terraform refresh"
                }
            }
        }
        stage('Ansible'){
            steps{
                script{
                    sh 'ansible-playbook -i hosts docker_app_setup.yml '
                    sh 'curl http://$(terraform output -raw public_ip):8081'
                }
            }
           
        }
    }
}