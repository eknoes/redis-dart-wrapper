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
                                    sh 'pub get'
                                    sh 'pub global activate junitreport'
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
                        linter: {
                            echo 'Check Health'
                            sh 'dartanalyzer --options analysis_options.yaml .'
                        }
                )
            }
        }

    }
}
