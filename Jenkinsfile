node {
    env.gluonrepo    = 'https://github.com/freifunk-gluon/gluon'            // the correct branch/tag will be determined automatically
    env.ffsiterepo   = 'https://github.com/ffka/site-ffka'                  // switch to official repo asap
    env.GLUON_BRANCH = 'stable'                                             // ex. 'stable', 'beta' or 'experimental'
    
    //env.ffsitebranch = getlatesttag(env.ffsiterepo, env.GLUON_BRANCH)       // 'branch' is usually the tag to be checked out, ex. v0.2.90-stable.1 for stable as of today.
    env.ffsitebranch = env.BRANCH_NAME
    echo "Building firmware images for site-conf branch ${env.ffsitebranch}"
    
    wrap([$class: 'TimestamperBuildWrapper']) {
        timeout(time: 12, unit: 'HOURS') {
            stage('Cleanup') {
                deleteDir()
            }
            dir('site') {
                stage('Checkout site.conf') {
                    // this is the only syntax able to check out tags
                    checkout([$class: 'GitSCM', userRemoteConfigs: [[url: env.ffsiterepo]], branches: [[name: env.ffsitebranch]]])
                }

                env.gluonBranch = sh([returnStdout: true, script: "make -f site.mk --eval='gluonbranch: ;@echo \$(GLUON_CHECKOUT)'"])
                echo 'Corresponding gluon tag: ' + env.gluonbranch
            }
            
            dir('ffka') {
                stage('Checkout gluon') {
                    def branchName = 'refs/tags/' + env.gluonBranch
                    echo 'gluon: using git branch name=' + branchName
                    checkout([$class: 'GitSCM', userRemoteConfigs: [[url: env.gluonrepo]], branches: [[name: branchName]]])
                    sh "ln -s ../site ./site"
                }
                
                stage('Update gluon sub projects') {
                    sh "make update"
                }
                
                stage('Prepare and build targets') {
                    def gluontargets = sh([returnStdout: true, script: "make 2>/dev/null | grep '^ [*] ' | cut -b 4- | tr '\n' ' ' | tr -s ' '"])
                    String[] targets = gluontargets.trim().split(' ')
                    
                    for(int i = 0; i < targets.size(); i++) {   // for-loop must stay, otherwise: java.io.NotSerializableException: java.util.AbstractList$Itr
                        
                        def stagename = 'Build ' + targets[i]
                        stage(stagename) {
                            env.GLUON_TARGET = targets[i]
                            sh "make -j \$(nproc) clean"    // rebuilds all (tool-)packages for a single target (and cleans up temporary files)
                            
                            // gluon builds seem to be a little bit unstable recently. idea: move targets to separate jobs?
                            retry(1) {
                                sh "make -j \$(nproc)"
                            }
                            
                            // final clean disabled  .. missing ath9k-htc-firmware ipk. maybe some packages are not copied to output dir .. ffka-site has the ipk, though
                            // sh "make -j \$(nproc) clean"    // clean again: reduce disk space consumption by ~20GiB in total; build artifacts (=output folder) remain
                        }
                    }
                }
                
                stage('Create manifest') {
                    sh "make manifest"
                }
                
                stage('Wrap artifacts up') {
                    // should be ~1.1GiB in total (2016-11-13)
                    archiveArtifacts artifacts: 'output/**', caseSensitive: false, defaultExcludes: false, onlyIfSuccessful: true
                }
            }
            
            stage('Cleanup') {
                 step([$class: 'WsCleanup', cleanWhenFailure: false])
            }
        }
    }
}

// url is the url to the site-conf git repository; ex. https://github.com/ffka/site-ffka
// releaseline is one of 'stable', 'beta' or 'experimental'
// gettag always returns the latest tag for the selected release line.
def getlatesttag(url, releaseline) {
    sh([script: "git ls-remote --tags ${url} | grep -i -- '-$releaseline' | cut -b 42- | sort -rn | head -n 1", returnStdout: true])
}
