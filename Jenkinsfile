pipeline {
    agent any
    options {
        timeout(time: 1, unit: 'HOURS') 
    }
    triggers {
        pollSCM('H */4 * * 1-5')
    }
    parameters {
          choice(name: 'GOALS', choices: ['clean package', 'package', 'build','test', 'deploy'], description: 'Maven Goals')
    }
    stages {
        stage('git') {
             steps {
                git url: 'https://github.com/Akhil-Tejas225/spring-petclinic.git',
                    branch: 'main'
             }
        }
        stage('build_with_sonar') {
            when {
                beforeAgent true
                beforeOptions true
                expression {
                     params.GOALS == 'clean package' || params.GOALS == 'build'
                }
            }
            tools {
                maven 'M2_HOME'
            }
            agent {
                node {
                    label 'java'
                }
            }
            steps {
                withSonarQubeEnv('SONAR_QUBE') {
                sh "mvn ${params.GOALS} org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.organization=spring-petclinic225 -Dsonar.projectKey=701811083fc0264e739307ac7ba6f6c668c16521"
                junit testResults: '**/surefire-reports/TEST-*.xml'
                archiveArtifacts artifacts: '**/spring-petclinic*.*jar'
                       
            }        
          }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }  
            }
        }
        stage('artifcatory configuration'){
            steps {
                rtServer(
                    id: 'ARTIFACTORY_SERVER',
                    serverid: 'JFROG',
                    credential: 'jfrog',
                )
                rtMavenDeployer(
                    id: 'MAVEN_DEPLOYER',
                    serverid: 'ARTIFACTORY_SERVER',
                    releaseRepo: 'at227-libs-release',
                    snapshotRepo: 'at227-libs-snapshot'

                )
            }
        }
        stage('Maven_build'){
            steps{
                rtMavenRun (
                    tools: 'M2_HOME',
                    pom: 'pom.xml',
                    goals: "mvn clean deploy",
                    deployerId: 'MAVEN_DEPLOYER'
                )
            }
        }

    }  
    post {
       success {
          mail from: "akhilit225", 
               to: "tejas@mahadevelectricals.com", 
               subject: "Build ${BUILD_ID} is successfull", 
               body: "congrats! ${BUILD_ID} is successfull"
            }
       failure {
           mail from: "akhilit225", 
                to: "tejas@mahadevelectricals.com", 
                subject: "Build ${BUILD_ID} is failure", 
                body: " ${BUILD_ID} is failure"
                }
                
            }    
}


//This build will fail as we need to configure http://<jenkins-host>/sonarqube-webhook/ in Sonar qube administration webhooks which is available only in paid version
// we should make sure sonar scanner is installed