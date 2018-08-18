#!groovy

def gitUtil = loadSemanticVersionLib().org.tmr.GitUtil.new(this)
def repoUrl

node {
   stage('Preparation') { // for display purposes
      deleteDir()
      // Set up local 'jenkins' git identy
      //gitUtil.reset()

      repoUrl = 'github.com/tim-m-robinson/release_tag_test.git'
      // Get some code from a GitHub repository
      git 'https://'+repoUrl

   }
   stage('Build') {
      // Create and Push new Tag with list
      // of commit comments
      gitUtil.calcNewTagVersionAndPush(repoUrl, 'github')

   }
   stage('Results') {

     def versions = readYaml file: 'release/config/versions.yml'
     echo versions.toString()
     versions.ol_dummy.release = 'v2.0.0'
     versions.ol_dummy.hash = 'sha256:f07cfefe56596f5e9846f84ecd36be1ad27c77501e1bd4ec77787d1c041c1a11'
     echo versions.toString()
     dir('release/config') {
         deleteDir()
     }
     writeYaml file: 'release/config/versions.yml', data: versions

   }
}

def loadSemanticVersionLib() {
  library identifier: 'semantic-version@master', retriever: modernSCM(
             [$class: 'GitSCMSource',
              remote: 'https://github.com/tim-m-robinson/semantic-version.git'])
}
