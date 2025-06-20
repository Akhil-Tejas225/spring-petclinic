pipeline {
    agent any
    options {
        timeout(time: 1, unit: 'HOURS') 
    }
    triggers {
        pollSCM('H */4 * * 1-5')
    }
    parameters {
          choice(name: 'GOALS', choices: ['clean package', 'package', 'build','test'], description: 'Maven Goals')
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
                    params.GOALS == 'clean package' || params.GOALS == 'package'
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
                sh "mvn ${params.GOALS} org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -D sonar.organization=spring-petclinic225 -D sonar.projectKey=701811083fc0264e739307ac7ba6f6c668c16521"
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
                          body: "congrats! ${BUILD_ID} is failure"

                }
                
            }
    }  
        
}
}