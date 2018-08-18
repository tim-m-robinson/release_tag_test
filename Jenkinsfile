#!groovy

public def String commitList, tagNew

node {
   stage('Preparation') { // for display purposes
      deleteDir()
      // Set up local 'jenkins' git identy
      sh( 'git init' )
      sh( 'git config user.email "jenkins@acme.net"' )
      sh( 'git config user.name "Jenkins"')
   
      def repoUrl = 'github.com/tim-m-robinson/release_tag_test.git'
      // Get some code from a GitHub repository
      git 'https://'+repoUrl

      def tagCount = sh( 
        script: 'git tag -l | wc -l',
        returnStdout: true
      ).trim()
      echo tagCount
 
      if( tagCount == '0' ) {
          commitList = sh(
            script: 'git log --oneline',
            returnStdout: true 
          ).trim()
          
          tagNew = 'v1.0.0'

      } else {
          // get latest tag
          def tagLatest = sh(
            script: 'git tag | tail -1',
            returnStdout: true 
          ).trim()
          echo tagLatest
          
          commitList = sh(
            script: 'git log '+tagLatest+'..HEAD --oneline',
            returnStdout: true 
          ).trim()
          
          if ( commitList.equals('') ) {
            //currentBuild.result = 'ABORTED'
            //error('No changes commited since last tag')
            echo 'No changes...'
          }
          
          // Here we use the imported Library 'sem'
          def currentVersion = loadSemanticVersionLib().org.tmr.SemanticVersion.parse(tagLatest)
          if(currentVersion.isReleaseCandidate()) {
            tagNew = currentVersion.incrementRc().toString()
          } else {
            tagNew = currentVersion.incrementRevision().toString()
          }
          
          echo tagNew
      }
      
      echo commitList
      
      // Create and Push new Tag with list
      // of commit comments
    
   
    
     
   }
   stage('Build') {
      echo '******'
      echo tagNew
      echo commitList
      // Create the new release tag
      /*
      withCredentials(
          [usernamePassword(
              credentialsId: 'github',
              passwordVariable: 'GIT_PASSWORD',
              usernameVariable: 'GIT_USERNAME')]) {
          sh('git tag -a "'+tagNew+'" -m "'+commitList+'"')
          sh('git push --tags https://${GIT_USERNAME}:${GIT_PASSWORD}@'+repoUrl)
      }  
      */
   }
   stage('Results') {

     def versions = readYaml file: 'release/config/versions.yml'
     echo versions.toString()
     

   }
}

def loadSemanticVersionLib() {
  library identifier: 'semantic-version@master', retriever: modernSCM(
             [$class: 'GitSCMSource',
              remote: 'git@github.com/tim-m-robinson/semantic-version.git'])
}
