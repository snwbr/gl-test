#!/usr/bin/env groovy

def manifests_folders = [
    "common",
    "apps/dev",
    "services",
] as String[]
def ci = "tfpod-${UUID.randomUUID().toString()}"

podTemplate(
  label: ci,
  containers: [
    containerTemplate(name: 'kustomize',image: "k8s.gcr.io/kustomize/kustomize:v3.8.7", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
    containerTemplate(name: 'gcloud', image: "google/cloud-sdk:377.0.0", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
    containerTemplate(name: 'helm', image: "alpine/helm:3.8.1", ttyEnabled: true, alwaysPullImage: false, command: 'cat')
  ]
) {
  timeout(60){
    timestamps {
      ansiColor('xterm') {
        node(ci) {
          try {
            container('kustomize') {
              stage('Git checkout') {
                checkout scm
              }
              stage('CD - Generate K8s manifests from templates') {
                dir("k8s"){
                  for (folder in manifests_folders) {
                    sh("/app/kustomize build ${folder} > ${folder.replaceAll("/", "-")}.yaml")
                  }
                }
              } // stage end
            }
            container('gcloud') {
              stage('CD - Get Google credentials') {
                withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'gcp_sa_key')]) {
                  sh("""
                    gcloud auth activate-service-account --key-file=${gcp_sa_key}
                    gcloud container clusters get-credentials dev-gke --region us-central1 --project test-snwbr
                    kubectl apply -f k8s/common.yaml
                    """)
                }
              } // stage end
            }
            container('helm') {
              stage('CD - Deploying Helm apps') {
                sh("""
                  helm upgrade --install \
                    --namespace=services \
                    --values=k8s/services/traefik/helm_values.yaml \
                    traefik traefik/traefik
                  """)
                  sleep(time:15,unit:"SECONDS")
              } // stage end
            }
            container('gcloud') {
              stage('CD - Deploying Kustomize templates') {
                sh("kubectl apply -f k8s/services.yaml")
                sleep(time:30,unit:"SECONDS")
                sh("kubectl apply -f k8s/apps.yaml")
              } // stage end
            }
          } catch(err) {
            if (err.toString().contains('FlowInterruptedException')) {
              currentBuild.result = 'UNSTABLE'
              echo "Pipeline Aborted/Timed Out"
            } else {
              currentBuild.result = 'FAILURE'
              echo """
                Pipeline failed. Please see error information below:

                ${err}

              """.stripIndent()
            }
          } finally {}
        }
      }
    }
  }
}
