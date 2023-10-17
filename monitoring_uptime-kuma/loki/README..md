# Loki 
Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost-effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

## Variables:
loki_binary_file: The Loki source
loki_user: user 
loki_group: user
loki_installation: Path for installation on Loki
loki_config_path: Path for configuration Loki
loki_data_dir: Save data
loki_http_port: Port http 
loki_grcp_port: Port grcp
loki_config_name: Config file
loki_log_file: Path for log Loki

### Provides simple single binary as a systemd unit 
```yamlex
[Unit]
Description=Loki service
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart={{loki_installation}}/loki-linux-amd64 -config.file {{loki_config_path}}/loki-config.yaml
SyslogIdentifier= root
StandardError=append:{{loki_log_file}}/loki.log
Restart=always
```

[Install]
WantedBy=multi-user.target

## Inventory example:

```yamlex
monitoring_servers:
  hosts: 
    cluster1
```
