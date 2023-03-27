pipeline{
    agent any
    stages{
        stage("checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/gopikrishna7/Helloworld_Nodejs.git'
                echo "Checkout completed."
            }
        }
        stage("Sonarscan"){
            environment{
                scannerHome = tool 'sonar-scanner'
            }
            steps{
                withSonarQubeEnv(installationName:'sq1'){
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time:5,unit:'MINUTES'){
                    waitForQualityGate abortPipeline: true

                }
            }
        }
        stage('DockerBuild'){
            steps{
                sh "docker build -t hellonode ."
            }     
        }
        stage("Scan Image"){
            steps{
                //sh "trivy image --no-progress --exit-code 1 --severity HIGH,CRITICAL mynodeimg"
                sh "trivy image hellonode"
            }
        }
        stage("Docker push"){
            environment{
                SERVER_CRED=credentials('DockerHub')
            }
            steps{
                sh 'echo ${SERVER_CRED_PSW} | docker login -u ${SERVER_CRED_USR} --password-stdin'
                sh "docker tag hellonode gopikrishna99899/hellonode:${env.BUILD_NUMBER}"
                sh "docker push gopikrishna99899/hellonode:${env.BUILD_NUMBER}"
                
            }
        }
        stage("Create_Infra"){
            steps{
                
                dir('Terraform'){
                    sh "terraform init"
                    sh "terraform apply -auto-approve"
                }

            }
            
        }
        stage("update kubeconfig"){
            steps{
                sh "aws eks update-kubeconfig --region us-west-2 --name eks_test"
            }

        }
        stage("KubernetesDeploy"){
            steps{
                script{
                    def manifest = readFile('kubernetes/Deployment.yaml')
                    manifest = manifest.replaceAll('image:.*', "image: gopikrishna99899/hellonode:${env.BUILD_NUMBER}")
                    sh "echo '${manifest}' > kubernetes/Deployment.yaml"
                    sh "kubectl apply -f kubernetes"
                    sh "kubectl get svc"
                    timeout(time:5,unit:'MINUTES'){
                        sh "kubectl get svc"

                    }

                }
                
            }
        }
    }
    post{
        always{
                sh "docker rmi hellonode"
                sh "docker rmi gopikrishna99899/hellonode:${env.BUILD_NUMBER}"
                sh 'docker logout'
        }
    }

}