pipeline {
    agent any

    parameters {
        choice(
            name: 'OS',
            choices: ['linux', 'darwin', 'windows'],
            description: 'Target operating system'
        )

        choice(
            name: 'ARCH',
            choices: ['amd64', 'arm64'],
            description: 'Target architecture'
        )

        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip running tests'
        )

        booleanParam(
            name: 'SKIP_LINT',
            defaultValue: false,
            description: 'Skip running linter'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Lint') {
            when {
                expression { !params.SKIP_LINT }
            }
            steps {
                sh 'make lint'
            }
        }

        stage('Test') {
            when {
                expression { !params.SKIP_TESTS }
            }
            steps {
                sh 'make test'
            }
        }

        stage('Build') {
            steps {
                sh """
                    make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}
                """
            }
        }

        stage('Docker Image') {
            steps {
                sh """
                    make image TARGETOS=${params.OS} TARGETARCH=${params.ARCH}
                """
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
                    sh '''
                        echo $CR_PAT | docker login ghcr.io -u vldmrhlushko --password-stdin
                        make push TARGETOS=${OS} TARGETARCH=${ARCH}
                    '''
                }
            }
        }
    }
}