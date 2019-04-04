pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {

        stage('terraform started') {
            steps {
                sh 'echo "Started...!" '
            }
        }
        stage('git clone') {
            steps {
                sh 'sudo rm -r *;sudo git clone https://github.com/azdevops1/JenkAzure.git'
            }
        }
        stage('tfsvars create'){
            steps {
                sh 'sudo cp /home/azureuser/variables.tf ./JenkAzure/'
            }
        }
        stage('terraform init') {
            steps {
                sh 'sudo /home/azureuser/terraform init ./JenkAzure'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'ls ./JenkAzure; sudo /home/azureuser/terraform plan ./JenkAzure'
            }
        }
        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}