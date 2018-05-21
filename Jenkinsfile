pipeline {
    agent any

    environment {
        GIT_COMMIT_ID =  sh (script: "git rev-parse HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Build') {
            steps {
                // create image and build app
                sh "docker build -t ${params.ECR_URI}:${env.GIT_COMMIT_ID} ."
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Archive') {
            steps {
                // connect to aws elastic container registry
                sh "aws ecr get-login --no-include-email --region ${params.AWS_REGION} | bash"

                // archive and tag image to aws elastic container registry
                sh """
                docker tag ${params.ECR_URI}:${env.GIT_COMMIT_ID} ${params.ECR_URI}:release
                docker push ${params.ECR_URI}:release
                """
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
