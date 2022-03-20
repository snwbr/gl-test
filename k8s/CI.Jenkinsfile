#!/usr/bin/env groovy

def manifests_folders = [
    "common",
    "apps/dev",
    "services",
] as String[]

podTemplate(
  label: ci,
  containers: [
    containerTemplate(name: 'kubeval', image: "garethr/kubeval:0.15.0", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
    containerTemplate(name: 'kustomize',image: "k8s.gcr.io/kustomize/kustomize:v3.8.7", ttyEnabled: true, alwaysPullImage: false, command: 'cat'),
  ]
) {
  timeout(60){
    timestamps {
      ansiColor('xterm') {
        node(ci) {
          try {
            container('kustomize') {
              stage('CI - Generate K8s manifests from templates') {
                for (folder in manifests_folders) {
                  sh("kustomize build ${folder} > ${folder.replaceAll("/", "-")}.yaml")
                }
              } // stage end
            }
            container('kustomize') {
              stage('CI - Validate K8s manifests') {
                sh("kubeval --ignore-missing-schemas ./*")
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
