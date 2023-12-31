pipeline {
    agent {
        // Defining the node with label 'maven'
        label 'maven'
    }

    stages {
        stage('Build') {
            steps {
                // Executing Maven clean deploy command
                sh 'mvn clean deploy'
            }
        }
    }
}
