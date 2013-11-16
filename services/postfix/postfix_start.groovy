import ShellExecutor

use(ShellExecutor) {
    println "Starting postfix..."
    "sudo /etc/init.d/postfix reload".executeOnShell()
    println "Starting postfix complete."
}