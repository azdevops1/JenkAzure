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
                sh "sudo cp /home/azureuser/tfinfo/terraform ./JenkAzure/${params.typeofdeployment}"
	    sh "sudo cp /home/azureuser/.azure/credentials ./JenkAzure/${params.typeofdeployment}"
	    sh "sudo cp /home/azureuser/tfinfo/terraform.tfvars ./JenkAzure/${params.typeofdeployment}"
		
            }
        }
      
        stage('terraform init') {
            steps {
                sh "cd JenkAzure/${params.typeofdeployment}; sudo terraform init"
            }
        }
        stage('terraform plan') {
            steps {
		sh "ls ./JenkAzure/${params.typeofdeployment}; cd JenkAzure/${params.typeofdeployment}; sudo terraform plan -var \"location=${params.azurelocation}\" -var \"resourcegroupname=${params.azurergname}\""
		        
	    }
	
        }

	

        stage('terraform apply') {
            steps {
			// Input Step
			timeout(time: 15, unit: "MINUTES") {
	                input message: 'Review the output of plan and apply if approved?', ok: 'Yes'
		        }
			sh "ls ./JenkAzure/${params.typeofdeployment}; cd JenkAzure/${params.typeofdeployment}; sudo terraform apply -var \"location=${params.azurelocation}\" -var \"resourcegroupname=${params.azurergname}\" -auto-approve"
	    }
        }

        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}