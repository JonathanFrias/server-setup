

service {
    name 'postfix'

//    icon "mysql.png"
    type "APP_SERVER"
    elastic true
    numInstances 1

    compute {
        template "SMALL_LINUX"
    }

    lifecycle {
        init 'postfix_init.groovy'
    }
}