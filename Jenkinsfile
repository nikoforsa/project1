//вызов подключаемой Global Pipeline Libraries из ветки docker
@Library('bld-jenkins-shared-libraries@docker')_

node {
    def agents = [
            ['linux-docker', ['gcc8':['Debug','Release'],'gcc9':['Debug', 'Release']]],
            ['windows-docker', ['msvc19-release':['Debug','Release']]]
        ]
    def publish = true
    runBuild(['agents': agents], publish)
}