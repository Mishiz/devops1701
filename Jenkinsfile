pipeline {
  agent any
  tools {
    terraform 'terraform-117'
  }
  stages {
    stage('Git Checkout'){
      steps{
        git 'https://github.com/Mishiz/devops1701.git'
      }
    }
    stage('Terraform init'){
      steps{
        sh 'terraform init'
      }
    }
    stage('Terraform Apply'){
      steps{
        sh 'terraform apply --auto-approve \
            -var "do_token=credentialsId: 'eccb1b0a-e729-4277-bf7c-7e4c681be532'" \
            -var "pvt_key=$HOME/.ssh/id_rsa" '
      }
    }
  }
}