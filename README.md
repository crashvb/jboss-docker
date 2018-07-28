# jboss-docker

## Overview

This docker image contains [JBoss](https://jboss.org/).

## Entrypoint Scripts

### jboss

The embedded entrypoint script is located at `/etc/entrypoint.d/10jboss` and performs the following actions:

1. A new jboss configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | ---------| ------------- | ----------- |
 | JBOSS_PASSWORD | _random_ | The jboss `admin` password. |

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  └─ entrypoint.d/
│     └─ 10jboss
├─ root/
│  └─ jboss_password
└─ usr/
   └─ share/
      └─ jboss/
```

### Exposed Ports

Note: The Web Managment Console port (`9990`) is not automatically exposed for security reasons.

* `8080/tcp` - Unencrypted connection between deployed web applications and clients.
* `8443/tcp` - SSL-encrypted connection between deployed web applications and clients.

### Volumes

None.

## Development

[Source Control](https://github.com/crashvb/jboss-docker)

