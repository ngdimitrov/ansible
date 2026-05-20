# Uptime Kuma

Ansible role to install and configure [Uptime Kuma](https://github.com/louislam/uptime-kuma) — a self-hosted status monitor — behind an Nginx reverse proxy.

The role runs Uptime Kuma as a **native systemd service** under a dedicated unprivileged user (no PM2 dependency, no root processes), with sandboxing directives enabled.

## Requirements

- Ubuntu 22.04 (jammy) or 24.04 (noble)
- Ansible 2.10+
- Internet egress to `deb.nodesource.com` and `github.com`

## Role variables

See [`defaults/main.yaml`](defaults/main.yaml). Key variables:

| Variable | Default | Description |
|---|---|---|
| `nodejs_major_version` | `22` | Node.js LTS line (NodeSource APT) |
| `uptime_kuma_version` | `2.3.2` | Git tag to check out |
| `uptime_kuma_install_dir` | `/opt/uptime-kuma` | Source checkout |
| `uptime_kuma_user` / `uptime_kuma_group` | `uptime-kuma` | System user (no shell) |
| `uptime_kuma_home` | `/var/lib/uptime-kuma` | Data directory (`DATA_DIR` env) |
| `uptime_kuma_bind_address` | `127.0.0.1` | Node app bind (Nginx fronts it) |
| `uptime_kuma_port` | `3001` | Node app port |
| `uptime_kuma_server_name` | `localhost` | Nginx `server_name` |

## Example invocation

```yaml
- hosts: status_servers
  become: true
  roles:
    - role: uptime_kuma
      vars:
        uptime_kuma_server_name: status.example.com
```

## Tags

`uptime_kuma`, `install`, `config`, `service`, `systemd`, `nginx`, `nodejs`.

## License

MIT
