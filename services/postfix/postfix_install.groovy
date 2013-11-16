import org.cloudifysource.dsl.context.ServiceContext
import org.cloudifysource.dsl.context.ServiceContextFactory
import org.hyperic.sigar.OperatingSystem as os
import ShellExecutor

ServiceContext context = ServiceContextFactory.serviceContext
def thisService = context.attributes.thisService
thisService.instances.each {
    println "thisService attribute: ${it.dump()}"
}
assert thisService.mainCfTemplate, "Required file name name for main.cf template is not provided"
def templateFilePath = "${context.serviceDirectory}/templates/${thisService.mainCfTemplate}"
assert new File(templateFilePath).exists(), "Template File Not Found: $templateFilePath"
def templateFile = new File(templateFilePath)
template = templateFile.text.replaceAll('#myhostname#', thisService.myhostname)
template = template.replaceAll('#mydomain#', thisService.mydomain)

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
File postfixConfTempFile = File.createTempFile('postfix', 'cf')
postfixConfTempFile.write template.toString()
File postfixConfFile = new File(postfixConfPath)
use(ShellExecutor) {
    "sudo chown root:root ${postfixConfTempFile}".executeOnShell()
    "sudo mv ${postfixConfTempFile} ${postfixConfFile}".executeOnShell()
}





