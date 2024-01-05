def imageName = 'khalil03.jfrog.io/khalil-docker-local/ttrend'
def version = '2.0.2'

def registry = 'https://khalil03.jfrog.io'
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
                withSonarQubeEnv('khalil-sonarqube-server') {
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

        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer(url: registry + "/artifactory", credentialsId: "artifact-cred")
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "mvn001-libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

        stage("Docker Build") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName + ":" + version)
                    echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }

        stage("Docker Publish") {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, 'artifact-cred') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended ----------------->'
                }
            }
        }


        stage("Deploy"){

            steps{
                script {
                    sh './deploy.sh'

                }

            }

        }

    }
}
