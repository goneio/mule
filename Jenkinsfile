pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
    }
    stages {
        stage('Prepare') {
            steps {
                 telegramSend "Pipeline STARTED: `${env.JOB_NAME}`\n\nAuthor: `${env.GIT_AUTHOR_NAME} <${env.GIT_AUTHOR_EMAIL}>`\nBuild Number: ${env.BUILD_NUMBER}\n\n${env.RUN_DISPLAY_URL}"
                 sh 'printenv'
                 sh 'make prepare'
            }
        }
        stage('Build') {
            parallel {
                stage('5.6') {
                    steps {
                         sh 'make build-php5.6'
                    }
                }
                stage('7.0') {
                    steps {
                         sh 'make build-php7.0'
                    }
                }
                stage('7.1') {
                    steps {
                         sh 'make build-php7.1'
                    }
                }
                stage('7.2') {
                    steps {
                         sh 'make build-php7.2'
                    }
                }
                stage('7.3') {
                    steps {
                         sh 'make build-php7.3'
                    }
                }
            }
        }
        stage('Tag') {
            steps {
                 sh 'make tag'
            }
        }
        stage('Push') {
            steps {
                 sh 'make push'
            }
        }
    }
    post {
        success{
            telegramSend "Pipeline SUCCESS: `${env.JOB_NAME}`\n\nAuthor: `${env.GIT_AUTHOR_NAME} <${env.GIT_AUTHOR_EMAIL}>`\nBuild Number: ${env.BUILD_NUMBER}\n\n${env.RUN_DISPLAY_URL}"
        }
        aborted{
            telegramSend "Pipeline ABORTED: `${env.JOB_NAME}`\n\nAuthor: `${env.GIT_AUTHOR_NAME} <${env.GIT_AUTHOR_EMAIL}>`\nBuild Number: ${env.BUILD_NUMBER}\n\n${env.RUN_DISPLAY_URL}"
        }
        failure{
            telegramSend "Pipeline FAIL: `${env.JOB_NAME}`\n\nAuthor: `${env.GIT_AUTHOR_NAME} <${env.GIT_AUTHOR_EMAIL}>`\nBuild Number: ${env.BUILD_NUMBER}\n\n${env.RUN_DISPLAY_URL}"
        }
        cleanup {
            sh 'make cleanup'
            cleanWs()
        }
    }
}
