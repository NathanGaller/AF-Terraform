@Library('ng-lib') _

pipeline {
  agent any
  
  parameters {
    string(
      name: 'FOLDER',
      defaultValue: 'tf',
      description: 'The folder containing the Terraform configuration files (e.g., .tf files). This folder will be used as the working directory for all Terraform commands executed during the pipeline.'
    )
  }
  
  stages {
    stage('Init') {
      steps {
        script {
          terraform.terraformInit(params.FOLDER)
        }
      }
    }

    stage('TFlint') {
      steps {
        script {
          dir(params.FOLDER) {
            sh "tflint --recursive --error-with-issues"
          }
        }
      }
    }
    
    stage('Plan') {
      steps {
        script {
          terraform.terraformPlan(params.FOLDER)
        }
      }
    }
    
    stage('Apply') {
      steps {
        script {
          terraform.terraformApply(params.FOLDER)
        }
      }
    }
  }
  
  post {
    always {
      cleanWs()
    }
  }
  
  tools {
    terraform 'ng-terraform'
  }
}
