import ShellExecutor
import org.cloudifysource.dsl.context.ServiceContextFactory
import org.hyperic.sigar.OperatingSystem as os

def configFile = new File("postfix-service.properties")
assert configFile.exists(), "postfix-service.properties file not found: $configFile"
def config = new ConfigSlurper().parse(configFile.text)
assert config.mainCfTemplate, "Required main.cf template file is not provided."

def context = ServiceContextFactory.serviceContext
println "Adding properties to service context"
config.toProperties().each { prop ->
    println "Setting thisService with property: ${prop.key} :: ${prop.value}"
    if (!context.attributes.thisService[prop.key])
        context.attributes.thisService[prop.key] = prop.value
    else
        println "Service configuration has been overridden in context attributes: ${prop.key}."
}

use(ShellExecutor) {
    switch (os.instance.vendor) {
        case ["Red Hat", "CentOS", "Fedora", "Amazon", ""]:
            "sudo yum install postfix -y".executeOnShell()
            break
        case ["Ubuntu", "Debian", "Mint"]:
            "sudo apt-get install postfix -y".executeOnShell()
            break

        default:
            break;

    }
}

// http://www.linux.com/learn/tutorials/308917-install-and-configure-a-postfix-mail-server