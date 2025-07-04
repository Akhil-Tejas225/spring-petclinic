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
    environment {
          PATH = "/usr/local/bin:$PATH"
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
        stage('Deploytojfrog') {
            agent{
                node{
                    label 'java'
                }                
            }
            environment {
                JFROG_CLI_HOME = "${WORKSPACE}/.jfrog"
                 PATH = "/usr/local/bin:$PATH"
             }
            tools{
                jfrog 'jfcli'
                maven 'M2_HOME'
            }

            steps {
            
                sh '''
               ls -al
               export JFROG_CLI_HOME="$WORKSPACE/.jfrog"
               export JFROG_CLI_CACHE_DIR="$WORKSPACE/.jfrog/cache"
               export JFROG_CLI_TEMP_DIR="$WORKSPACE/.jfrog/temp"
               export MAVEN_USER_HOME="$WORKSPACE/.m2"
               mkdir -p "$JFROG_CLI_HOME" "$JFROG_CLI_CACHE_DIR" "$JFROG_CLI_TEMP_DIR" "$MAVEN_USER_HOME"
               echo "deploying to jfrog.."
               jf mvn-config --server-id-resolve='trialm9czxi' --repo-resolve-releases='at227-libs-release' --repo-resolve-snapshots='at227-libs-deploy' --repo-deploy-releases='at227-libs-release' --repo-deploy-snapshots='at227-libs-snapshot' 
               jf mvn clean deploy --m2-home=usr/share/maven
               '''
            
                
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