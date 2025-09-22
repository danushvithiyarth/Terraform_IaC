pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        // Use Jenkins credentials for AWS authentication
        AWS_ACCESS_KEY_ID     = credentials('Access_Key')   // replace with your Jenkins credential ID
        AWS_SECRET_ACCESS_KEY = credentials('Secret_ID')   // replace with your Jenkins credential ID
    }

    stages {
        stage('Cleanup') {
            steps {
                deleteDir() // clean workspace to avoid old state issues
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
                    sh 'terraform fmt -check'            // format check
                    sh 'terraform plan -out=tfplan'      // generate plan
                    sh 'terraform show -no-color tfplan > tfplan.txt' // save plan
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
                    sh 'head -n 50 terraform/tfplan.txt' // only show preview to avoid freezing Jenkins

                    // Manual approval
                    input message: "Do you want to apply the plan?" // simple Yes/No approval
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

    post {
        always {
            archiveArtifacts artifacts: 'terraform/tfplan.txt', fingerprint: true
            echo "Terraform plan archived for review"
        }
    }
}
