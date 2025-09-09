@Library("Shared") _

pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: "FRONTEND_DOCKER_TAG", defaultValue: "", description: "Setting docker image for latest push")
        string(name: "BACKEND_DOCKER_TAG", defaultValue: "", description: "Setting docker image for latest push")
    }

    stages {
        stage("Validate Parameters") {
            steps {
                script {
                    if(params.FRONTEND_DOCKER_TAG == "" || params.BACKEND_DOCKER_TAG == "") {
                        error("FRONTEND_DOCKER_TAG & BACKEND_DOCKER_TAG must be provided")
                    }
                }
            }
        }

        stage("Workspace Cleanup") {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage("Git: Code Checkout") {
            steps {
                 script {
                    code_checkout("https://github.com/ShivamMishra828/idurar-erp-crm.git", "master")
                 }
            }
        }

        stage("Trivy: Filesystem Scan") {
            steps {
                 script {
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency Check") {
            steps {
                script {
                    owasp_dependency()
                }
            }
        }
        
        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "erp-app", "erp-app")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Docker: Build Images") {
            steps {
                script {
                        dir('backend') {
                            docker_build("erp-backend","${params.BACKEND_DOCKER_TAG}","shivammishra828")
                        }
                    
                        dir('frontend') {
                            docker_build("erp-frontend","${params.FRONTEND_DOCKER_TAG}","shivammishra828")
                        }
                }
            }
        }
        
        stage("Docker: Push to DockerHub") {
            steps {
                script {
                    docker_push("erp-backend","${params.BACKEND_DOCKER_TAG}","shivammishra828") 
                    docker_push("erp-frontend","${params.FRONTEND_DOCKER_TAG}","shivammishra828")
                }
            }
        }
    }
    post {
        success {
            build job: "ERP-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
        }
        failure {
            echo "CI Pipeline failed. Check logs for details."
        }
    }
}
