# Promtail

Ansible role to install and configure [Grafana Promtail](https://grafana.com/docs/loki/latest/clients/promtail/) — the log shipping agent for Loki.

> [!NOTE]
> Promtail is in maintenance mode upstream; new deployments should consider [Grafana Alloy](https://grafana.com/docs/alloy/). This role still ships Promtail v3.5.x (last release with `linux-arm64` binary).

## Requirements

- Ubuntu 22.04 (jammy) or 24.04 (noble)
- Ansible 2.10+
- Loki reachable at `promtail_loki_url`

## Role variables

See [`defaults/main.yaml`](defaults/main.yaml). Key variables:

| Variable | Default | Description |
|---|---|---|
| `promtail_version` | `3.5.12` | Upstream release |
| `promtail_listen_address` | `127.0.0.1` | Bind address |
| `promtail_http_port` / `promtail_grpc_port` | `9080` / `9097` | HTTP / gRPC ports |
| `promtail_loki_url` | `http://127.0.0.1:3100/loki/api/v1/push` | Where to send logs |
| `promtail_scrape_configs` | scrapes `/var/log/*.log` + `/var/log/nginx/*.log` | List of scrape jobs (override to customize) |
| `promtail_binary_sha256_map` | `{}` | Per-arch SHA256 |
| `promtail_user` / `promtail_group` | `promtail` | Service user; added to `adm` group for `/var/log` access |

## Example invocation

```yaml
- hosts: monitoring_servers
  become: true
  roles:
    - role: promtail
      vars:
        promtail_loki_url: http://loki.internal:3100/loki/api/v1/push
        promtail_scrape_configs:
          - job_name: app
            static_configs:
              - targets: [localhost]
                labels: { job: app, __path__: /var/log/app/*.log }
```

## Tags

`promtail`, `install`, `config`, `service`, `systemd`.

## License

MIT
