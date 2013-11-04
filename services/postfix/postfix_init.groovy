import org.hyperic.sigar.OperatingSystem as os
import org.cloudifysource.dsl.context.ServiceContextFactory
import ShellExecutor

config = new ConfigSlurper().parse(new File("apacheLB-service.properties").toURI().toURL())
context = ServiceContextFactory.serviceContext
context.attributes.config = config
ant = new AntBuilder()

use(ShellExecutor) {
    switch (os.instance.vendor) {
        case ["Red Hat", "CentOS", "Fedora", "Amazon", ""]: {
            "yum install postfix -y".executeOnShell()
            break
        }
        case ["Ubuntu", "Debian", "Mint"]: {
            "apt-get install postfix -y".executeOnShell()
        }
    }
    "group add -g ${config.userGroup} ${config.userId} ${config.userName}".executeOnShell()
    "useradd -g ${config.userGroup} -u ${config.userId} -d ${config.userHome} --create-home"
    def password = "${config.userName}:${config.userName}"
    "chpasswd < ${password}"
}