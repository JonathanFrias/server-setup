
import org.cloudifysource.dsl.utils.ServiceUtils;

service {
    name 'postfix'

    icon "postfix.gif"
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
        startDetection {
            ServiceUtils.isPortOccupied(postfixPort)
        }
        locator {
            NO_PROCESS_LOCATORS
        }
        stop 'postfix_stop.groovy'
    }
}