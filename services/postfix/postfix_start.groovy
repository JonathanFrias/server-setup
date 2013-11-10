import ShellExecutor

use(ShellExecutor) {
    "sudo service start postfix".executeOnShell()
}