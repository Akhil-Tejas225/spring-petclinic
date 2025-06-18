pipeline {
 agent any
  options {
        timeout(time: 30, unit: 'MINUTES') 
    }
  trigger{
    pollSCM(* * * * *)
  }
  parameters{
    choice(name: 'CHOICES', choices:['package', 'test', 'clean package', 'build'], description: 'Maven Build Lifecycle')
  }
 stages{
    stage(git){
        git url: 'https://github.com/Akhil-Tejas225/spring-petclinic.git',
        branch: 'main'
    }
    stage(Build){
        agent{
            node{
                label: 'java'
            }
        }
        tools{
            maven 'M2_HOME'
        }
        when{
            beforeAgent=true
            beforeOptions=true
            expression {
                ${params.CHOICES}=package || ${params.choices}=build
            }
        }
        steps{
            script{
                def projpath=sh(script: 'find .-name pom.xm', returnStdoutput=true).trim()
                artifactoryMavenBuild pom: $projpath, goals: pacakge
            )
            }
        }


    }
 }
 }