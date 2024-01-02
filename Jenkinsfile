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
                echo "----------------------- build started -----------"
                // Your build steps go here
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------------------- build completed -----------"
            }
        }
        stage('Test') {
            steps {
                echo "----------------------- unit test started -----------"
                sh 'mvn surefire-report:report'
                echo "----------------------- unit test completed -----------"
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
        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}
