pipeline {
	agent any
	environment {
        imageName = "angularapp"
        registryCredentials = "nexus"
        registry = "172.17.16.1:8085"
        dockerImage = ''
    }

	  
    stages {	
          
         // Sonarqube Analyse 
         stage('Sonarqube Analyse ') { 
		      environment {SCANNER_HOME = tool 'SonarQube_Scanner'}
          steps {
			      script {
             withSonarQubeEnv(credentialsId:'jenkins-sonar' , installationName:'sonar',envOnly :true){		    
				        sh ''' $SCANNER_HOME/bin/sonar-scanner \
				               -Dsonar.host.url=http://192.168.56.1:9000  \
						           -Dsonar.exclusions=**/node_modules/** \
                       -Dsonar.projectKey=EcommerceStore \
                       -Dsonar.projectName=EcommerceStore \
                       -Dsonar.sources=src/	'''
			        }
			       }
            }
         }
		
				
				
	       // Building Docker images
		     stage('Building image') {
			    steps{
			     script {
				    dockerImage = docker.build imageName
				  }
			   }
			  }
   

         // Uploading Docker images into Nexus Registry
         stage('Uploading to Nexus') {
          steps{  
           script{   
		         docker.withRegistry( 'http://'+registry, registryCredentials ) {
             dockerImage.push('latest')
            }
           }
          }
        }
		
		
        //Apply Kubernetes File
        stage('Apply Kubernetes File') {
          steps {
            withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'testkub', namespace: 'default', serverUrl: 'https://172.23.226.154:6443']]) 
            {
                  sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'
                  sh 'chmod u+x ./kubectl'
                  sh './kubectl apply -f appangular.yml'

            }
          }
        }

    }

}


