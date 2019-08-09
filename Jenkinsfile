pipeline {
    agent {
        docker {
            image 'google/dart'
            //noinspection GroovyAssignabilityCheck
            args '-v /opt/pub-cache:/opt/pub-cache -e PUB_CACHE="/opt/pub-cache" -u root:root'
        }
    }

    options {
        timestamps()
    }

    stages {
        stage('Prepare') {
            steps {
                parallel(
                        install_dependencies:
                                {
                                    echo "Install Dart dependencies"
                                    copyArtifacts filter: '.packages', fingerprintArtifacts: true, projectName: '${JOB_NAME}', optional: true
                                    sh 'pub get'
                                    sh 'pub global activate pana'
                                    sh 'pub global activate --source git https://github.com/eknoes/dart-pana-to-junit.git'
                                    archiveArtifacts artifacts: '.packages', fingerprint: true
                                },

                        setup_redis:
                                {
                                    echo "Install Redis"
                                    sh 'apt-get update'
                                    sh 'apt-get install -y redis-server'
                                    sh 'service redis-server start'
                                }
                )
            }
        }

        stage('Test') {
            steps {
                parallel(
                        /*
                            Currently no tests written
                            run_tests: {
                            echo 'Run Dart tests'
                            sh 'pub run test --reporter json > test.json'
                            sh 'pub global run junitreport:tojunit --input test.json --output report.xml'
                        },*/
                        pana: {
                            echo 'Check Health'
                            sh 'pub global run pana --no-warning --source path . > out.json'
                            sh 'pub global run pana_to_junit:main --input out.json --output pana-report.xml'
                        }
                )
            }
        }

    }

    post {
        always {
            junit '**/pana-report.xml'
        }
    }

}
