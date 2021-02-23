pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                mvn 'clean install -DskipTests'
            }
        }

        stage('App Internal Test') {
            steps {
                mvn 'test'

            }
        }
		
		stage('Deploy to Docker Container') {
             steps {
				 sh "cp target/vulnerablejavawebapp-0.0.1-SNAPSHOT.jar . &&docker build -t vjwwaa . && docker run -dp 9090:9090 vjwwaa"
             }
        }
		
		stage('ZAP scan') {
			steps{
				 build job:'ZAPvsVJWA',propagate:true, wait:true
			}
		}
			
		stage('Arachni Dynamic Test') {
        	steps{
        		 arachniScanner checks: '*', format: 'html', scope: [excludePathPattern: '', pageLimit: '3'], url: 'http://192.168.33.10:9090', userConfig:[filename: '/vagrant/conf.json']
        	}
        }
    }
	/*post{ 
        always {
            stopArachni() 
        }
    }*/
}


def startupArachni() {
   sh 'docker start arachni ||  docker run -d \
   -p 222:22 \
   -p 7331:7331 \
   -p 9292:9292 \
   --name arachni \
  arachni/arachni:latest   '
}



def mvn(def args) {
    def mvnHome = tool 'M3'
    def javaHome = tool 'JDK11'

    // Apache Maven related side notes:
    // --batch-mode : recommended in CI to inform maven to not run in interactive mode (less logs)
    // -V : strongly recommended in CI, will display the JDK and Maven versions in use.
    //      Very useful to be quickly sure the selected versions were the ones you think.
    // -U : force maven to update snapshots each time (default : once an hour, makes no sense in CI).
    // -Dsurefire.useFile=false : useful in CI. Displays test errors in the logs directly (instead of
    //                            having to crawl the workspace files to see the cause).

    // Advice: don't define M2_HOME in general. Maven will autodetect its root fine.
    // See also
    // https://github.com/jenkinsci/pipeline-examples/blob/master/pipeline-examples/maven-and-jdk-specific-version/mavenAndJdkSpecificVersion.groovy
    sh "${mvnHome}/bin/mvn ${args} --batch-mode -V -U -e -Dsurefire.useFile=false"
    
}