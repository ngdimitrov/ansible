# Promtail
Promtail is an agent which ships the contents of local logs to a private Grafana Loki instance or Grafana Cloud.

## Variables:
* promtail_binary_file: The Promtail source
* promtail_user: user
* promtail_group: user
* promtail_http_port: Port http 
* promtail_grpc_port: Port grcp
* promtail_installation: Path for installation on Promtail
* promtail_config_path: Path for configuration Promtail
* promtail_config_name: Config file

## Add this to the config file to provide the configuration for filter nginx logs.

``````
 pipeline_stages:
        - drop:
            expression: '(?P<remote_addr>.+?) - (?P<a>.+?) \[(?P<b>.+?)\] \"(?P<c>.+?)\" (?P<status>2[0-9][0-9]) (?P<d>.+?) (?P<e>.+?) (?P<f>.+?) \"(?P<g>.+?)\" \((?P<h>.+?) (?P<i>.+?) (?P<k>.+?)\) (?P<request_time>.+?)$'

``````

### Systemd 
``````
[Unit]
Description=Promtail service
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart={{promtail_installation}}/promtail-linux-amd64 -config.file {{promtail_config_path}}/promtail-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
``````

## Inventory example:

```yamlex
monitoring_servers:
  hosts: 
    cluster1
```
