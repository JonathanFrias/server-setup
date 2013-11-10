

service {
    name 'postfix'

//    icon "mysql.png"
    type "APP_SERVER"
    elastic true
    numInstances 1

    compute {
        template "SMALL_LINUX"
    }

    lifecycle {
        preInstall 'postfix_preInstall.groovy'
        install 'postfix_install.groovy'
        start 'postfix_start.groovy'
        startDetectionTimeoutSecs 800
        startDetection {
            ServiceUtils.isPortOccupied(postfixPort)
        }
    }
}