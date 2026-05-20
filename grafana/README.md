# Grafana

Ansible role to install and configure [Grafana OSS](https://grafana.com/oss/grafana/) from the upstream APT repository (`apt.grafana.com`).

## Requirements

- Ubuntu 22.04 (jammy) or 24.04 (noble)
- Ansible 2.10+

## Role variables

See [`defaults/main.yaml`](defaults/main.yaml). Key variables:

| Variable | Default | Description |
|---|---|---|
| `grafana_version` | `13.0.*` | APT version pin |
| `grafana_gpg_key_url` | `https://apt.grafana.com/gpg.key` | Upstream GPG key URL |
| `grafana_repo_release` | `stable` | Repo channel — `stable`, `beta` |
| `grafana_listen_address` | `127.0.0.1` | HTTP bind address (set via systemd `Environment`) |
| `grafana_http_port` | `3000` | HTTP port |
| `grafana_admin_password` | `""` | If set, exports `GF_SECURITY_ADMIN_PASSWORD` on first boot. Use ansible-vault! |
| `grafana_analytics_reporting_enabled` | `false` | Disable usage telemetry |

The role configures Grafana via a systemd drop-in
(`/etc/systemd/system/grafana-server.service.d/override.conf`) rather than editing
`/etc/grafana/grafana.ini` — this leaves the upstream config file untouched so
package upgrades replace it cleanly.

## Example invocation

```yaml
- hosts: monitoring_servers
  become: true
  roles:
    - role: grafana
      vars:
        grafana_listen_address: 0.0.0.0
        grafana_admin_password: "{{ vault_grafana_admin_password }}"
```

## Tags

`grafana`, `install`, `config`, `service`.

## License

MIT
