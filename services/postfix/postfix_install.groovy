import org.hyperic.sigar.OperatingSystem as os
import groovy.text.*

def postfixConfPath
switch (os.instance.vendor) {
    case ["Red Hat", "CentOS", "Fedora", "Amazon", ""]:
        postfixConfPath = "/etc/postfix/main.cf"
        break
    case ["Ubuntu", "Debian", "Mint"]:
        postfixConfPath = "/etc/postfix/main.cf"
        break;
    default:
        postfixConfPath = "/etc/postfix/main.cf"
}

def config = new ConfigSlurper(new File('postfix-service.properties').toURI().toURL())

def templateFile = new File(config.mainCfTemplate)
template = templateFile.text.replaceAll('#myhostname#', config.myhostname)
template = template.replaceAll('#mydomain#', config.mydomain)
new File(postfixConfPath).write template.toString()





