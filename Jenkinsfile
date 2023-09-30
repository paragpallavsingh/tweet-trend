def registry = 'https://paragcloud.jfrog.io'
def imageName = 'paragcloud.jfrog.io/tt-repo-docker-local/ttrend'
def version   = '2.1.2'

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
                //in the build stage dont execute the unit test
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
        
        stage('Quality Gate'){
            steps{
                script{
                    timeout(time: 1, unit: 'HOURS'){
                        def qg = waitForQualityGate()
                        if(qg.status != 'OK'){
                            error "Pipleine aborted due to Quality Gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        
        stage("Jar Publish") {
            steps {
                script {
                    echo '<-------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-token"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<-------------- Jar Publish Ended --------------->'  
                }
            }   
        }

        stage(" Docker Build ") {
            steps {
                script {
                   echo '<--------------- Docker Build Started --------------->'
                   app = docker.build(imageName+":"+version)
                   echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }

        stage (" Docker Publish "){
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'jfrog-token'){
                        app.push()
                    }    
                    echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }
    }
}
