import ShellExecutor
import org.cloudifysource.dsl.context.ServiceContextFactory
import org.hyperic.sigar.OperatingSystem as os

config = new ConfigSlurper().parse(new File("postfix-service.properties").toURI().toURL())
context = ServiceContextFactory.serviceContext
context.attributes.config = config
ant = new AntBuilder()

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