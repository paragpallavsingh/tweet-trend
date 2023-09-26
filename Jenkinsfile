pipeline{
    agent {
        node {
            label 'maven'
        }
    }
    
    stages {
        stage ('Clone Code') {
            steps {
                git url: 'https://github.com/paragpallavsingh/tweet-trend.git', branch: 'main'
            }
        }
    }
}