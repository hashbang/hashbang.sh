reserved_names = [
    # Names that might be used for phishing
    'about', 'account', 'admin', 'administrator', 'anonymous', 'billing',
    'board', 'calendar', 'contact', 'copyright', 'data', 'development',
    'donate', 'dotfile', 'email', 'example', 'feedback', 'forum', 'image',
    'inbox', 'index', 'invite', 'jabber', 'legal', 'main', 'manage',
    'media', 'message', 'mobile', 'official', 'payment', 'photos',
    'picture', 'policy', 'portal', 'press', 'private', 'sitemap', 'staff',
    'staging', 'status', 'user', 'username',

    # Usernames reserved in Debian
    'root', 'daemon', 'bin', 'sys', 'sync', 'games', 'man', 'lp',
    'proxy', 'www-data', 'backup', 'list', 'irc', 'gnats', 'nobody',
    'ntpd', 'statd', 'sshd', 'messagebus', 'unbound', 'postfix',
    'postgres', 'nslcd', 'glances', 'oident', 'bitlbee', 'redis',
    'epmd',

    # #! service names
    'chat', 'finger', 'git', 'im', 'irc', 'ldap', 'mail', 'voip', 'www',
    'mumble'

    # Non-RFC2142 email aliases
    'mailer-daemon', 'nobody', 'root', 'team'

    # RFC2142 mailbox names
    #  Business related
    'info', 'marketing', 'sales', 'support',

    #  Network operations
    'abuse', 'noc', 'security'

    #  Support for specific services
    'ftp', 'hostmaster', 'news', 'usenet',
    'uucp', 'postmaster', 'webmaster', 'www'
]

reserved_usernames = reserved_names
reserved_usernames += [name + 's'
                       for name in reserved_names
                       if name[-1] != 's']

RESERVED_USERNAMES = frozenset(reserved_usernames)
del reserved_usernames
del reserved_names
