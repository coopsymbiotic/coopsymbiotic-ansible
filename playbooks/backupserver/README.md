NB: on the backup server, you must configure:

    /etc/send_nsca.cfg

For example:

    password = "myfancypassword"
    server = "monitoring.example.org"
    tls_ciphers = "PSK-AES256-CBC-SHA"
    delay = 2
    timeout = 5

This must match the NSCA server configurations found in:

    /etc/nsca-ng/nsca-ng.local.cfg

For example:

    command_file= "/var/lib/icinga/rw/icinga.cmd"
    listen = "*:5668"
    tls_ciphers = "PSK-AES256-CBC-SHA"

    # default level is 3, which includes a log of events received
    # (2 = warnings and errors) see man nsca-ng.cfg(5)
    log_level = 2

    authorize "*" {
        password = "myfancypassword"
        services = ".+"
        hosts = ".+"
    }
