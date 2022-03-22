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
    containerTemplate(name: 'kubeval', image: "garethr/kubeval:0.15.0", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
    containerTemplate(name: 'gcloud', image: "google/cloud-sdk:377.0.0", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
    containerTemplate(name: 'kustomize',image: "k8s.gcr.io/kustomize/kustomize:v3.8.7", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
  ]
) {
  timeout(60){
    timestamps {
      ansiColor('xterm') {
        node(ci) {
          try {
            container('gcloud') {
              stage('Git checkout') {
                checkout scm
                new_commit = sh(returnStdout: true, script:"git rev-parse --short HEAD").trim()
                last_commit = sh(returnStdout: true, script:"git rev-parse --short HEAD~1").trim()
                changed_files = sh(returnStdout: true, script:"""
                  git diff --no-commit-id --name-only -r ${new_commit} ${last_commit} |
                  xargs dirname |
                  sort -u |
                  xargs -I{} find {} -name "kustomization.yaml" -maxdepth 1
                  """).trim().split('\n')
                  print "Changed files: ${changed_files}"
              }
            }
            container('kustomize') {
              stage('CI - Generate K8s manifests from templates') {
                when {
                  expression { changed_files != [] }
                } 
                dir("k8s"){
                  for (file in changed_files) {
                    sh("/app/kustomize build `dirname ${file}` >> ${file.split("/")[0]}.yaml")
                  }
                }
              } // stage end
            }
            container('kubeval') {
              stage('CI - Validate K8s manifests') {
                when {
                  expression { changed_files != '' }
                }
                sh("""
                  /kubeval --ignore-missing-schemas k8s/*.yaml
                  """)
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
