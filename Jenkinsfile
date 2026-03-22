pipeline {
    agent any

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Fetch Terraform Outputs') {
            steps {
                script {
                    env.DEV_IP  = sh(script: "terraform output -raw dev_ip", returnStdout: true).trim()
                    env.PROD_IP = sh(script: "terraform output -raw prod_ip", returnStdout: true).trim()
                    env.USER    = sh(script: "terraform output -raw username", returnStdout: true).trim()
                }
            }
        }

        stage('Deploy to DEV') {
            steps {
                sh '''
                echo "Deploying to DEV: $DEV_IP"

                scp -o StrictHostKeyChecking=no app/index.html $USER@$DEV_IP:/tmp/index.html

                ssh -o StrictHostKeyChecking=no $USER@$DEV_IP "
                sudo cp /tmp/index.html /var/www/html/index.html
                sudo systemctl restart nginx
                "
                '''
            }
        }

        stage('Deploy to PROD') {
            steps {
                sh '''
                echo "Deploying to PROD: $PROD_IP"

                scp -o StrictHostKeyChecking=no app/index.html $USER@$PROD_IP:/tmp/index.html

                ssh -o StrictHostKeyChecking=no $USER@$PROD_IP "
                sudo cp /tmp/index.html /var/www/html/index.html
                sudo systemctl restart nginx
                "
                '''
            }
        }
    }
}