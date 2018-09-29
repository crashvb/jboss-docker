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
├─ run/
│  └─ secrets/
│     └─ jboss_password
└─ usr/
   └─ share/
      └─ jboss/
```

### Exposed Ports

Note: The management ports (`9990` and `9999`) are not automatically exposed for security reasons.

* `8080/tcp` - Unencrypted connection between deployed web applications and clients.
* `9990/tcp` - HTTP management endpoint.
* `9999/tcp` - Native management endpoint.

### Volumes

None.

## Development

[Source Control](https://github.com/crashvb/jboss-docker)

