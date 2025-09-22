pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('Access_Key')   
        AWS_SECRET_ACCESS_KEY = credentials('Secret_ID')   
    }

    stages {
        stage('Print Parameter') {
            steps {
                script {
                    echo "autoApprove parameter value: ${params.autoApprove}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                dir('terraform') {
                    git "https://github.com/danushvithiyarth/Terraform_IaC.git"
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -check'
                    sh 'terraform plan -input=false -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    echo "Terraform plan preview (first 50 lines):"
                    sh 'head -n 50 terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?"
                }
            }
        }

        stage('Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}
