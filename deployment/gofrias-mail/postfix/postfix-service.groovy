service {
    extend '../../../services/postfix'

    compute {
        template 'EE_APP_01'
    }
}