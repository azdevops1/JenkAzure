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
                sh 'sudo cp /home/azureuser/tfinfo/terraform ./JenkAzure/'
		sh 'sudo cp /home/azureuser/tfinfo/terraform.tfvars ./JenkAzure/'
                sh 'sudo cp /home/azureuser/.azure/credentials ./JenkAzure/'
		
            }
        }
      
        stage('terraform init') {
            steps {
                sh 'cd JenkAzure; sudo terraform init'
            }
        }
        stage('terraform plan') {
            steps {
			sh 'ls ./JenkAzure; cd JenkAzure; sudo terraform plan --var-file=terraform.tfvars --out "planfile"'
	    }
        }
        stage('terraform apply') {
            steps {
			sh 'ls ./JenkAzure; cd JenkAzure; sudo terraform apply --var-file=terraform.tfvars --input=false "planfile"'
	    }
        }

        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}