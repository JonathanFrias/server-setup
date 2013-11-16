import ShellExecutor

use(ShellExecutor) {
    println "Stoping postfix..."
    "sudo /etc/init.d/postfix stop".executeOnShell()
    println "Stoping postfix complete."
}