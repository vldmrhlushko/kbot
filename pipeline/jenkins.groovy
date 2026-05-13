pipeline {
    agent {
        kubernetes {
            label 'go-build-agent'

            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: go
    image: golang:1.22
    command:
    - cat
    tty: true
"""
        }
    }

    parameters {
        choice(
            name: 'OS',
            choices: ['linux', 'darwin', 'windows'],
            description: 'Target OS'
        )

        choice(
            name: 'ARCH',
            choices: ['amd64', 'arm64'],
            description: 'Target ARCH'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Go version') {
            steps {
                container('go') {
                    sh 'go version'
                }
            }
        }

        stage('Build Go binary') {
            steps {
                container('go') {
                    sh """
                        echo "Building for ${params.OS}/${params.ARCH}"
                        make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}
                    """
                }
            }
        }
    }
}