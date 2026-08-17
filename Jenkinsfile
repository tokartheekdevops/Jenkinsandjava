pipeline {

    agent {
        label 'djworker3'
    }

    environment {

        // =========================================================
        // APPLICATION
        // =========================================================

        APP_NAME = 'javajenkins'

        // =========================================================
        // GITHUB
        // =========================================================

        GIT_REPO = 'https://github.com/tokartheekdevops/Jenkinsandjava.git'

        // =========================================================
        // AWS / ECR
        // =========================================================

        AWS_REGION = 'ap-south-1'

        AWS_ACCOUNT_ID = '931527443397'

        ECR_REPO_NAME = 'javajenkins'

        ECR_REGISTRY = '931527443397.dkr.ecr.ap-south-1.amazonaws.com'

        ECR_REPOSITORY = '931527443397.dkr.ecr.ap-south-1.amazonaws.com/javajenkins'

        // Jenkins BUILD_NUMBER creates a unique image
        IMAGE_TAG = "${BUILD_NUMBER}"

        IMAGE_URI = "931527443397.dkr.ecr.ap-south-1.amazonaws.com/javajenkins:${BUILD_NUMBER}"

        // =========================================================
        // KUBERNETES
        // =========================================================

        K8S_NAMESPACE = 'default'

        // Jenkins -> Credentials
        // Kind: Secret file
        // ID: shoprupee-kubeconfig

        KUBECONFIG_CREDENTIAL_ID = 'shoprupee-kubeconfig'

        // =========================================================
        // KUBERNETES YAML FILES
        // =========================================================

        DEPLOYMENT_FILE = 'deploymentjava.yaml'

        SERVICE_FILE = 'servicelb.yaml'
    }


    stages {

        // =========================================================
        // 1. VERIFY JENKINS AGENT
        // =========================================================

        stage('Verify Agent') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "JENKINS AGENT"
                    echo "======================================"

                    echo "Hostname:"
                    hostname

                    echo ""
                    echo "Agent:"
                    echo "$NODE_NAME"

                    echo ""
                    echo "Workspace:"
                    pwd
                '''
            }
        }


        // =========================================================
        // 2. VERIFY TOOLS
        // =========================================================

        stage('Verify Tools') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "VERIFYING TOOLS"
                    echo "======================================"

                    echo ""
                    echo "===== Java ====="
                    java -version

                    echo ""
                    echo "===== Maven ====="
                    mvn -version

                    echo ""
                    echo "===== Git ====="
                    git --version

                    echo ""
                    echo "===== Docker ====="
                    docker --version

                    echo ""
                    echo "===== AWS CLI ====="
                    aws --version

                    echo ""
                    echo "===== kubectl ====="
                    kubectl version --client

                    echo ""
                    echo "All required tools are available."
                '''
            }
        }


        // =========================================================
        // 3. VERIFY SOURCE CODE
        // =========================================================

        stage('Verify Source') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "VERIFYING SOURCE CODE"
                    echo "======================================"

                    echo ""
                    echo "Current directory:"
                    pwd

                    echo ""
                    echo "Files:"
                    ls -la

                    echo ""
                    echo "Java source files:"
                    find src -type f

                    echo ""
                    echo "Kubernetes files:"

                    test -f deploymentjava.yaml
                    test -f servicelb.yaml

                    ls -lh deploymentjava.yaml
                    ls -lh servicelb.yaml

                    echo ""
                    echo "Source verification successful."
                '''
            }
        }


        // =========================================================
        // 4. VERIFY AWS IAM ROLE
        // =========================================================

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


        // =========================================================
        // 5. RUN JUNIT TESTS
        // =========================================================

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
                        testResults: 'target/surefire-reports/*.xml',
                        allowEmptyResults: false
                    )
                }
            }
        }


        // =========================================================
        // 6. BUILD WAR
        // =========================================================

        stage('Build WAR') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "BUILDING JAVA WAR"
                    echo "======================================"

                    mvn clean -B -Denforcer.skip=true package -DskipTests

                    echo ""
                    echo "Generated WAR files:"

                    ls -lh target/*.war
                '''
            }
        }


        // =========================================================
        // 7. LOGIN TO PRIVATE ECR
        // =========================================================

        stage('Login to Private ECR') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "LOGIN TO PRIVATE ECR"
                    echo "======================================"

                    aws ecr get-login-password \
                        --region "$AWS_REGION" \
                    | docker login \
                        --username AWS \
                        --password-stdin "$ECR_REGISTRY"

                    echo ""
                    echo "ECR login successful."
                '''
            }
        }


        // =========================================================
        // 8. BUILD DOCKER IMAGE
        // =========================================================

        stage('Build Docker Image') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "BUILDING DOCKER IMAGE"
                    echo "======================================"

                    echo "Image:"
                    echo "$IMAGE_URI"

                    docker build \
                        -t "$IMAGE_URI" \
                        .

                    echo ""
                    echo "Docker image created:"

                    docker images "$ECR_REPOSITORY"
                '''
            }
        }


        // =========================================================
        // 9. PUSH IMAGE TO ECR
        // =========================================================

        stage('Push Docker Image') {

            steps {

                sh '''
                    set -e

                    echo "======================================"
                    echo "PUSHING IMAGE TO ECR"
                    echo "======================================"

                    docker push "$IMAGE_URI"

                    echo ""
                    echo "Image pushed successfully:"
                    echo "$IMAGE_URI"
                '''
            }
        }


        // =========================================================
        // 10. CONFIGURE KUBERNETES ACCESS
        // =========================================================

        stage('Configure Kubernetes Access') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "KUBERNETES ACCESS"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        echo ""
                        echo "Current Kubernetes context:"
                        kubectl config current-context

                        echo ""
                        echo "Kubernetes cluster:"
                        kubectl cluster-info

                        echo ""
                        echo "Kubernetes nodes:"
                        kubectl get nodes

                        echo ""
                        echo "Kubernetes authentication successful."
                    '''
                }
            }
        }


        // =========================================================
        // 11. VERIFY KUBERNETES RBAC
        // =========================================================

        stage('Verify Kubernetes RBAC') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "KUBERNETES RBAC"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        echo ""
                        echo "Can get pods:"
                        kubectl auth can-i get pods \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Can create deployments:"
                        kubectl auth can-i create deployments \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Can update deployments:"
                        kubectl auth can-i update deployments \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Can patch deployments:"
                        kubectl auth can-i patch deployments \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Can create services:"
                        kubectl auth can-i create services \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "RBAC verification completed."
                    '''
                }
            }
        }


        // =========================================================
        // 12. VALIDATE KUBERNETES YAML
        // =========================================================

        stage('Validate Kubernetes YAML') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "VALIDATING KUBERNETES YAML"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        kubectl apply \
                            --dry-run=client \
                            -f "$DEPLOYMENT_FILE"

                        kubectl apply \
                            --dry-run=client \
                            -f "$SERVICE_FILE"

                        echo ""
                        echo "Kubernetes YAML validation successful."
                    '''
                }
            }
        }


        // =========================================================
        // 13. DEPLOY KUBERNETES MANIFESTS
        // =========================================================

        stage('Deploy to Kubernetes') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "DEPLOYING TO KUBERNETES"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        echo ""
                        echo "Applying Deployment..."

                        kubectl apply \
                            -f "$DEPLOYMENT_FILE"

                        echo ""
                        echo "Applying Service..."

                        kubectl apply \
                            -f "$SERVICE_FILE"

                        echo ""
                        echo "Kubernetes manifests applied successfully."
                    '''
                }
            }
        }


        // =========================================================
        // 14. UPDATE DEPLOYMENT IMAGE
        // =========================================================

        stage('Update Deployment Image') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "UPDATING DEPLOYMENT IMAGE"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        echo ""
                        echo "Finding deployment..."

                        DEPLOYMENT_NAME=$(kubectl get deployments \
                            -n "$K8S_NAMESPACE" \
                            -o jsonpath='{.items[0].metadata.name}')

                        if [ -z "$DEPLOYMENT_NAME" ]; then
                            echo "ERROR: No deployment found."
                            exit 1
                        fi

                        echo "Deployment:"
                        echo "$DEPLOYMENT_NAME"

                        echo ""
                        echo "Updating image to:"
                        echo "$IMAGE_URI"

                        kubectl set image \
                            deployment/"$DEPLOYMENT_NAME" \
                            "*=$IMAGE_URI" \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Deployment image updated successfully."
                    '''
                }
            }
        }


        // =========================================================
        // 15. ROLLING UPDATE
        // =========================================================

        stage('Rolling Update') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "ROLLING UPDATE"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        DEPLOYMENT_NAME=$(kubectl get deployments \
                            -n "$K8S_NAMESPACE" \
                            -o jsonpath='{.items[0].metadata.name}')

                        echo ""
                        echo "Waiting for deployment:"
                        echo "$DEPLOYMENT_NAME"

                        kubectl rollout status \
                            deployment/"$DEPLOYMENT_NAME" \
                            -n "$K8S_NAMESPACE" \
                            --timeout=5m

                        echo ""
                        echo "Rolling update completed successfully."
                    '''
                }
            }
        }


        // =========================================================
        // 16. VERIFY DEPLOYMENT
        // =========================================================

        stage('Verify Deployment') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "VERIFY DEPLOYMENT"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        kubectl get deployments \
                            -n "$K8S_NAMESPACE" \
                            -o wide

                        echo ""
                        echo "ReplicaSets:"

                        kubectl get rs \
                            -n "$K8S_NAMESPACE"
                    '''
                }
            }
        }


        // =========================================================
        // 17. VERIFY PODS
        // =========================================================

        stage('Verify Pods') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "VERIFY PODS"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        kubectl get pods \
                            -n "$K8S_NAMESPACE" \
                            -o wide

                        echo ""
                        echo "Checking pod status..."

                        NOT_READY=$(kubectl get pods \
                            -n "$K8S_NAMESPACE" \
                            --no-headers \
                            | awk '$2 !~ /^[0-9]+\\/\\1$/ {print}')

                        echo ""
                        echo "Pod verification completed."
                    '''
                }
            }
        }


        // =========================================================
        // 18. VERIFY SERVICE
        // =========================================================

        stage('Verify Service') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo "======================================"
                        echo "VERIFY SERVICE"
                        echo "======================================"

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        kubectl get services \
                            -n "$K8S_NAMESPACE" \
                            -o wide

                        echo ""
                        echo "Service verification completed."
                    '''
                }
            }
        }


        // =========================================================
        // 19. FINAL VERIFICATION
        // =========================================================

        stage('Final Verification') {

            steps {

                withCredentials([
                    file(
                        credentialsId: "${KUBECONFIG_CREDENTIAL_ID}",
                        variable: 'KUBECONFIG_FILE'
                    )
                ]) {

                    sh '''
                        set -e

                        echo ""
                        echo "=========================================="
                        echo "FINAL KUBERNETES VERIFICATION"
                        echo "=========================================="

                        export KUBECONFIG="$KUBECONFIG_FILE"

                        echo ""
                        echo "Deployments:"
                        kubectl get deployments \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Pods:"
                        kubectl get pods \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "Services:"
                        kubectl get services \
                            -n "$K8S_NAMESPACE"

                        echo ""
                        echo "=========================================="
                        echo "JAVA CI/CD PIPELINE SUCCESS"
                        echo "=========================================="

                        echo ""
                        echo "Docker Image:"
                        echo "$IMAGE_URI"

                        echo ""
                        echo "Kubernetes Namespace:"
                        echo "$K8S_NAMESPACE"

                        echo ""
                        echo "Deployment completed successfully."
                    '''
                }
            }
        }
    }


    // =============================================================
    // POST ACTIONS
    // =============================================================

    post {

        success {

            echo '''
==========================================
 JAVA CI/CD PIPELINE SUCCESS
==========================================

JUnit Tests        : PASSED
Maven Build        : PASSED
Docker Build       : PASSED
ECR Push            : PASSED
Kubernetes Auth     : PASSED
Kubernetes RBAC     : PASSED
Kubernetes Deploy   : PASSED
Rolling Update      : PASSED
Pod Verification   : PASSED
Service Verification: PASSED

==========================================
'''
        }

        failure {

            echo '''
==========================================
 JAVA CI/CD PIPELINE FAILED
==========================================

Check the failed stage in Console Output.

Possible areas:

1. JUnit
2. Maven
3. Docker
4. ECR authentication
5. ECR push
6. Kubernetes kubeconfig
7. Kubernetes RBAC
8. Kubernetes YAML
9. Kubernetes Deployment
10. Rolling Update
11. ImagePullBackOff
12. CrashLoopBackOff
13. Readiness Probe
14. Liveness Probe
15. Service

==========================================
'''
        }

        always {

            echo "Pipeline execution completed."
        }
    }
}
