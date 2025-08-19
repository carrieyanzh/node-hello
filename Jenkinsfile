 pipeline {
        agent any
        tools {
            nodejs 'NodeJS' // Replace with the name from Global Tool Configuration
        }
        stages {
            stage('Build') {
                steps {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }
    }
