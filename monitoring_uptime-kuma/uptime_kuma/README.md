# Uptime Kuma
Uptime Kuma is an easy-to-use self-hosted monitoring tool.
# Role
This Ansible playbook deploys and configures Nginx with Uptime Kuma (GitHub - louislam/uptime-kuma: A fancy self-hosted monitoring tool).
Supported OS will be only Ubuntu - 22 LTS release.
The deployed version of Uptime Kuma is 1.21.3
Nginx & Uptime Kuma deployed on the same host.
Uptime Kuma is accessible via Nginx on port 80
The default port on Uptime Kuma is 3001

## Variables:
* nodejs_url: The Node.js source
* uptime_kuma_repo: Uptime Kuma repository
* uptime_kuma_version: Uptime Kuma version to be installed


## Inventory example:
`monitoring_servers:
  hosts: 
    cluster1`
