pipeline {
    agent {
        label 'maven-slave'
    }

    environment {
        // Define your environment variables here
        MAVEN_HOME = '/opt/apache-maven-3.8.8'
        PATH = "${env.PATH}:${env.MAVEN_HOME}/bin"
    }

    stages {
        stage('Build') {
            steps {
                echo "----------------------- build started-----------"
                // Your build steps go here
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------------------- build completed-----------"
            }
        }
        stage ("test") {
            steps{
                echo "----------------------- unit test started-----------"
                sh 'mvn surefire-report:report'
                echo "----------------------- unit test Completed-----------"
            }

        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'khalil-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('khalil-sonarqube-server') { // Specify the name of your SonarQube server
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
