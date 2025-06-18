pipeline {
 agent any
  options {
        timeout(time: 30, unit: 'MINUTES') 
    }
  triggers{

        pollSCM('* * * * *')

  }
  parameters{
    choice(name: 'CHOICES', choices:['package', 'test', 'clean package', 'build'], description: 'Maven Build Lifecycle')
  }
 stages{
    stage('git'){
        steps{
        git url: 'https://github.com/Akhil-Tejas225/spring-petclinic.git',
        branch: 'main'
        }  
    }
    stage('Build'){
        when {
        // beforeAgent=true
        // beforeOptions=true
            expression {
                params.CHOICES =='package' || params.CHOICES == 'build'
            }
        }
        agent {
            node {
                label 'java'
            }
        }
        tools {
            maven 'M2_HOME'
        }
  
        steps{
            sh "mvn ${params.CHOICES}"
        }


    }
 }
 }