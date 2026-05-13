pipeline {
    agent {
        kubernetes {
            label 'go-custom-agent'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: go
    image: ghcr.io/vldmrhlushko/go-agent:1.0
    command: ['cat']
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


        stage('Test') {
            steps {
                container('go') {
                    sh 'make test'
                }
            }
        }

        stage('Build') {
            steps {
                container('go') {
                    sh "make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}"
                }
            }
        }

        stage("image") {
            steps {
                echo 'Building Docker image...'
                sh 'make image'
            }
        }

        stage("push") {
            steps {
                script {
                    docker.withRegistry( '', 'ghcr' ) {
                        sh 'make push'
                    }
                }
                echo 'Pushing Docker image...'
                sh 'make push'
            }
        }   



  }     
    
}