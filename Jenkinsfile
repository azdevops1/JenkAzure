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
      
        stage('terraform init') {
            steps {
                sh 'sudo /home/azureuser/tfinfo/terraform init ./JenkAzure'
            }
        }
        stage('terraform plan') {
            steps {
		withCredentials([azureServicePrincipal('azDevOps')]) {
	                sh  '''

        	             az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
	
        	            '''

			sh 'ls ./JenkAzure; sudo /home/azureuser/tfinfo/terraform plan ./JenkAzure'
		}
            }
        }
        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}