pipeline {
    agent any
    options {
        timeout(time: 30, unit: 'MINUTES') 
    }
    triggers {
        pollSCM('* * * * *')
    }
    tools {
        maven 'MAVEN_3.8'
        jdk 'JDK_17' 
    }
    stages {
        stage ('git'){
            steps{
            git branch: 'develop',
                url: 'https://github.com/Akhil-Tejas225/spring-petclinic.git'
            }
        }
        stage('build and package') {
           steps{ 
            rtMavenDeployer (
                id: 'SPC_DEPLOYER',
                serverId: 'JFROG_CLOUD',
                releaseRepo: 'atdevops-libs-snapshot',
                snapshotRepo: 'atdevops-libs-snapshot'
            )
            rtMavenRun (
                tool: 'MAVEN_3.8',
                deployerId: 'SPC_DEPLOYER',
                pom: 'pom.xml',
                goals: 'clean install'
            )
            rtPublishBuildInfo (
                serverId: 'JFROG_CLOUD'
            )
           }
           }
        stage('reporting'){
            steps {
            junit testResults: '**/target/surefire-reports/TEST-*.xml'
        }
        }


        
        }
    }
  