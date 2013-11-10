
class ShellExecutor {

    static output = []

    static printLines = {
        output << it
        println it
    }

    static executeOnShell(String self) {

        def processBuilder = new ProcessBuilder().redirectErrorStream(true)
        def command = ['sh', '-c']
        command << self

        def process = processBuilder.command(command as String[]).start()
        process.inputStream.eachLine printLines
        process.waitFor()
    }

    static executeOnShell(List self) {
        executeOnShell(self.join(' '))
    }

    static getOutput() { output }

    static clearOutput() { output = [] }

}
