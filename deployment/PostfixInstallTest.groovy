configFile = new File('services/postfix/postfix-service.properties')
assert configFile.exists()
config = new ConfigSlurper().parse(configFile.toURI().toURL())

templateFile = new File('services/postfix/templates/main.cf.template')
assert templateFile.exists()

template = templateFile.text.replaceAll('#myhostname#', config.myhostname)
template = template.replaceAll('#mydomain#', config.mydomain)
new File('deleteme.txt').write template.toString()
println "$template"
println config.myhostname
println config.mydomain