pipeline {

    agent {
        label 'djworker3'
    }

    environment {

        GIT_REPO =
            'https://github.com/tokartheekdevops/Jenkinsandjava.git'

        AWS_REGION =
            'ap-south-1'

        ECR_REGISTRY =
            '931527443397.dkr.ecr.ap-south-1.amazonaws.com'

        ECR_REPOSITORY =
            'javajenkins'

        IMAGE_TAG =
            "${BUILD_NUMBER}"

        IMAGE_URI =
            "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

        EKS_CLUSTER =
            'my-eks-cluster'

        DEPLOYMENT_NAME =
            'java-app'

        SERVICE_NAME =
            'java-app-service'

        DEPLOYMENT_FILE =
            'deploymentjava.yaml'

        SERVICE_FILE =
            'servicelb.yaml'

        KUBECONFIG_FILE =
            "${WORKSPACE}/kubeconfig"
    }


    stages {


        stage('Verify Agent') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "JENKINS AGENT"
                    echo "======================================"

                    echo "Hostname:"
                    hostname

                    echo "Agent:"
                    echo "$NODE_NAME"
                '''
            }
        }


        stage('Verify Tools') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "VERIFYING TOOLS"
                    echo "======================================"

                    echo "===== Java ====="
                    java -version

                    echo "===== Maven ====="
                    mvn -version

                    echo "===== Git ====="
                    git --version

                    echo "===== Docker ====="
                    docker --version

                    echo "===== AWS CLI ====="
                    aws --version

                    echo "===== kubectl ====="
                    kubectl version --client

                    echo ""
                    echo "All required tools are available."
                '''
            }
        }


        stage('Checkout Code') {

            steps {

                deleteDir()

                git(
                    url: "${GIT_REPO}",
                    branch: 'main'
                )
            }
        }


        stage('Verify Source') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "SOURCE FILES"
                    echo "======================================"

                    ls -la

                    echo ""
                    echo "Java source:"
                    find src -type f

                    echo ""
                    echo "Kubernetes files:"
                    ls -lh deploymentjava.yaml servicelb.yaml
                '''
            }
        }


        stage('Verify AWS IAM Identity') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "AWS IAM IDENTITY"
                    echo "======================================"

                    aws sts get-caller-identity
                '''
            }
        }


        stage('JUnit Tests') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "RUNNING JUNIT TESTS"
                    echo "======================================"

                    mvn -B -Denforcer.skip=true test
                '''
            }

            post {

                always {

                    junit(
                        testResults:
                            'target/surefire-reports/*.xml',

                        allowEmptyResults:
                            false
                    )
                }
            }
        }


        stage('Build WAR') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "BUILDING WAR"
                    echo "======================================"

                    mvn clean -B \
                        -Denforcer.skip=true \
                        package \
                        -DskipTests

                    echo ""
                    echo "Generated WAR:"
                    ls -lh target/*.war
                '''
            }
        }


        stage('Login to Private ECR') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "LOGIN TO PRIVATE ECR"
                    echo "======================================"

                    aws ecr get-login-password \
                        --region "${AWS_REGION}" \
                    | docker login \
                        --username AWS \
                        --password-stdin \
                        "${ECR_REGISTRY}"

                    echo "ECR login successful."
                '''
            }
        }


        stage('Build Docker Image') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "BUILDING DOCKER IMAGE"
                    echo "======================================"

                    echo "Image:"
                    echo "${IMAGE_URI}"

                    docker build \
                        -t "${IMAGE_URI}" \
                        .

                    docker images \
                        | grep javajenkins
                '''
            }
        }


        stage('Push Docker Image') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "PUSHING IMAGE TO ECR"
                    echo "======================================"

                    docker push "${IMAGE_URI}"

                    echo ""
                    echo "Image pushed successfully:"
                    echo "${IMAGE_URI}"
                '''
            }
        }


        stage('Configure EKS IAM Access') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "CONFIGURING EKS ACCESS"
                    echo "======================================"

                    rm -f "${KUBECONFIG_FILE}"

                    aws eks update-kubeconfig \
                        --region "${AWS_REGION}" \
                        --name "${EKS_CLUSTER}" \
                        --kubeconfig "${KUBECONFIG_FILE}"

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo ""
                    echo "Current context:"
                    kubectl config current-context

                    echo ""
                    echo "Cluster:"
                    kubectl cluster-info
                '''
            }
        }


        stage('Verify Kubernetes Access') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "KUBERNETES ACCESS"
                    echo "======================================"

                    kubectl get nodes

                    echo ""
                    echo "Kubernetes permissions:"
                    
                    echo -n "get pods: "
                    kubectl auth can-i get pods

                    echo -n "create deployments: "
                    kubectl auth can-i create deployments

                    echo -n "update deployments: "
                    kubectl auth can-i update deployments

                    echo -n "create services: "
                    kubectl auth can-i create services
                '''
            }
        }


        stage('Update Deployment Image') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "UPDATING DEPLOYMENT IMAGE"
                    echo "======================================"

                    echo "Before:"
                    grep "image:" "${DEPLOYMENT_FILE}"

                    sed -i -E \
                    "s|^[[:space:]]*image:.*|          image: ${IMAGE_URI}|" \
                    "${DEPLOYMENT_FILE}"

                    echo ""
                    echo "After:"
                    grep "image:" "${DEPLOYMENT_FILE}"
                '''
            }
        }


        stage('Validate Kubernetes YAML') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "VALIDATING KUBERNETES YAML"
                    echo "======================================"

                    kubectl apply \
                        --dry-run=client \
                        -f "${DEPLOYMENT_FILE}"

                    kubectl apply \
                        --dry-run=client \
                        -f "${SERVICE_FILE}"

                    echo ""
                    echo "YAML validation successful."
                '''
            }
        }


        stage('Deploy to EKS') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "DEPLOYING TO EKS"
                    echo "======================================"

                    kubectl apply \
                        -f "${DEPLOYMENT_FILE}"

                    kubectl apply \
                        -f "${SERVICE_FILE}"
                '''
            }
        }


        stage('Rolling Update') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "ROLLING UPDATE"
                    echo "======================================"

                    kubectl rollout status \
                        deployment/${DEPLOYMENT_NAME} \
                        --timeout=5m
                '''
            }
        }


        stage('Verify Pods') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "PODS"
                    echo "======================================"

                    kubectl get pods -o wide

                    echo ""
                    echo "Deployment:"
                    kubectl get deployment "${DEPLOYMENT_NAME}"

                    echo ""
                    echo "ReplicaSets:"
                    kubectl get rs
                '''
            }
        }


        stage('Verify Service') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "SERVICE"
                    echo "======================================"

                    kubectl get service "${SERVICE_NAME}" -o wide

                    echo ""
                    echo "Service details:"
                    kubectl describe service "${SERVICE_NAME}"
                '''
            }
        }


        stage('Final Verification') {

            steps {

                sh '''
                    set -e

                    export KUBECONFIG="${KUBECONFIG_FILE}"

                    echo "======================================"
                    echo "FINAL VERIFICATION"
                    echo "======================================"

                    echo "Deployment:"
                    kubectl get deployment "${DEPLOYMENT_NAME}"

                    echo ""
                    echo "Pods:"
                    kubectl get pods -o wide

                    echo ""
                    echo "Service:"
                    kubectl get service "${SERVICE_NAME}"

                    echo ""
                    echo "Running image:"
                    kubectl get deployment \
                        "${DEPLOYMENT_NAME}" \
                        -o jsonpath='{.spec.template.spec.containers[0].image}'

                    echo ""
                '''
            }
        }
    }


    post {

        success {

            echo '''
==========================================
 JAVA CI/CD PIPELINE SUCCESS
==========================================

JUnit tests       : PASSED
Maven build       : PASSED
Docker build      : PASSED
ECR push          : PASSED
IAM authentication: PASSED
Kubernetes access : PASSED
Deployment        : PASSED
Rolling update    : PASSED
Pod verification  : PASSED
Service            : PASSED

==========================================
'''
        }


        failure {

            echo '''
==========================================
 JAVA CI/CD PIPELINE FAILED
==========================================

Check the failed stage.

Possible areas:

1. JUnit
2. Maven
3. Docker
4. ECR authentication
5. ECR push
6. IAM
7. EKS authentication
8. Kubernetes RBAC
9. ImagePullBackOff
10. CrashLoopBackOff
11. Readiness probe
12. Liveness probe
13. LoadBalancer

==========================================
'''
        }


        always {

            sh '''
                rm -f "${KUBECONFIG_FILE}" || true
            '''

            echo "Pipeline execution completed."
        }
    }
}
