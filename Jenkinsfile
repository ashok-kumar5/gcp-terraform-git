pipeline {
    agent any

    stages {

        stage('Terraform Init') {
    steps {
        dir('terraform') {   // replace 'terraform' with your actual folder name
            bat '"C:\\Program Files\\Terraform\\terraform.exe" init'
        }
    }
}

stage('Terraform Apply') {
    steps {
        dir('terraform') {
            bat '"C:\\Program Files\\Terraform\\terraform.exe" apply -auto-approve'
        }
    }
}
        stage('Fetch Terraform Outputs') {
    steps {
        dir('terraform') {
            script {
                env.DEV_IP = bat(
                    script: '"C:\\Program Files\\Terraform\\terraform.exe" output -raw dev_ip',
                    returnStdout: true
                ).trim()

                env.PROD_IP = bat(
                    script: '"C:\\Program Files\\Terraform\\terraform.exe" output -raw prod_ip',
                    returnStdout: true
                ).trim()

                env.USERNAME = bat(
                    script: '"C:\\Program Files\\Terraform\\terraform.exe" output -raw username',
                    returnStdout: true
                ).trim()
            }
        }
    }
}

        stage('Deploy to DEV') {
    steps {
        dir('terraform') {
            bat """
            echo Deploying to DEV %DEV_IP%

            scp -o StrictHostKeyChecking=no app/index.html %USERNAME%@%DEV_IP%:/tmp/index.html

            ssh -o StrictHostKeyChecking=no %USERNAME%@%DEV_IP% "sudo cp /tmp/index.html /var/www/html/index.html && sudo systemctl restart apache2"
            """
        }
    }
}

        stage('Deploy to PROD') {
            steps {
                bat """
                echo Deploying to PROD %PROD_IP%

                scp -o StrictHostKeyChecking=no app/index.html %USER%@%PROD_IP%:/tmp/index.html

                ssh -o StrictHostKeyChecking=no %USER%@%PROD_IP% ^
                "sudo cp /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"
                """
            }
        }
    }
}