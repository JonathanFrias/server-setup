service {
    extend '../../../services/postfix'

    compute {
        template 'SMALL_LINUX'
    }
}