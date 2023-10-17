# Grafana 

A Grafana dashboard consists of panels displaying data in beautiful graphs, charts, and other visualizations. These panels are created using components that transform raw data from a data source into visualizations.

## Variables
* grafana_version: Grafana version to be installed
* path_import_gpg_key: Path of gpg key
* grafana_repo: Stable Grafana repository 

## Inventory example:

```yamlex
monitoring_servers:
  hosts: 
    cluster1
```
