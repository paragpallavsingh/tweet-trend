pipeline{
    agent {
        node {
            label 'maven'
        }
    }  

    environment {
        PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
    }
    stages {
        stage ('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }

        stage('SonarQube Analysis'){
            environment{
                scannerHome = tool 'tt-sonar-scanner';
            }
            steps{
                withSonarQubeEnv('tt-sonar-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}