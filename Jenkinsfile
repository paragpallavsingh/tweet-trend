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
                echo "___build started____"
                sh 'mvn clean deploy -Dmaven.test.skip=true' 
                #in the build stage dont execute the unit test
                echo "___build completed____"
            }
        }
        stage('test'){
            steps{
                echo "___unit test started____"
                sh 'mvn surefire-report:report'
                echo "___unit test done____"
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
