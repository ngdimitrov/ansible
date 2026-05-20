# Loki

Ansible role to install and configure [Grafana Loki](https://grafana.com/oss/loki/) — a horizontally scalable, multi-tenant log aggregation system.

The role installs a single-binary Loki release, drops a systemd unit, and renders a v13-schema TSDB filesystem config suitable for single-node deployments.

## Requirements

- Ubuntu 22.04 (jammy) or 24.04 (noble)
- Ansible 2.10+
- `ansible.builtin` collection only

## Role variables

See [`defaults/main.yaml`](defaults/main.yaml) for the full list. Key variables:

| Variable | Default | Description |
|---|---|---|
| `loki_version` | `3.7.2` | Upstream release |
| `loki_arch_map` | `{x86_64: amd64, aarch64: arm64}` | Maps `ansible_facts.architecture` to release suffix |
| `loki_binary_sha256_map` | `{}` | Per-arch SHA256 (recommended in prod; see [SHA256SUMS][1]) |
| `loki_listen_address` | `127.0.0.1` | Bind address (loopback by default; Loki has no built-in auth) |
| `loki_http_port` / `loki_grpc_port` | `3100` / `9095` | HTTP / gRPC ports |
| `loki_auth_enabled` | `false` | Multi-tenant header-based auth |
| `loki_retention_period` | `168h` | Reject samples older than this (1 week) |
| `loki_data_dir` | `/data/loki` | Chunks + TSDB index + rules storage |
| `loki_user` / `loki_group` | `loki` | Service user (no shell, no home) |
| `loki_analytics_reporting_enabled` | `false` | Disable Grafana Labs anonymous telemetry |

[1]: https://github.com/grafana/loki/releases

## Example invocation

```yaml
- hosts: monitoring_servers
  become: true
  roles:
    - role: loki
      vars:
        loki_listen_address: 0.0.0.0        # expose externally (add auth/TLS!)
        loki_binary_sha256_map:
          amd64: "<sha256 from upstream SHA256SUMS>"
          arm64: "<sha256 from upstream SHA256SUMS>"
```

## Tags

`loki`, `install`, `config`, `service`, `systemd`.

## License

MIT
