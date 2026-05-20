#!/usr/bin/env bash
set -euo pipefail

# This script orchestrates the full Docker-based test harness.
# It is meant to be run from the project root.

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

CONTROLLER_IMAGE="vertastack-ansible-controller:test"
TARGET_IMAGE="geerlingguy/docker-ubuntu2404-ansible:latest"
NET_NAME="vertastack-test-net"
TARGET_NAME="ansible-target"
CONTROLLER_NAME="ansible-controller"

cleanup() {
    echo "--- Cleaning up containers ---"
    docker rm -f "$TARGET_NAME" "$CONTROLLER_NAME" 2>/dev/null || true
    docker network rm "$NET_NAME" 2>/dev/null || true
}
trap cleanup EXIT

cleanup

echo "--- Building controller image ---"
docker build -t "$CONTROLLER_IMAGE" -f test/Dockerfile.controller test/

echo "--- Pulling target image ---"
docker pull "$TARGET_IMAGE"

echo "--- Creating network ---"
docker network create "$NET_NAME"

echo "--- Starting target container (systemd-enabled Ubuntu 22.04) ---"
docker run -d \
    --name "$TARGET_NAME" \
    --network "$NET_NAME" \
    --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    --cgroupns=host \
    --tmpfs /tmp \
    --tmpfs /run \
    --tmpfs /run/lock \
    "$TARGET_IMAGE"

sleep 3

echo "--- Starting controller container ---"
docker run -d \
    --name "$CONTROLLER_NAME" \
    --network "$NET_NAME" \
    -v "$PROJECT_ROOT":/work \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e ANSIBLE_CONFIG=/work/test/ansible.cfg \
    "$CONTROLLER_IMAGE" \
    sleep infinity

exec_in_controller() {
    docker exec "$CONTROLLER_NAME" "$@"
}

echo
echo "=========================================="
echo "STEP 1: yamllint"
echo "=========================================="
exec_in_controller yamllint -c /work/test/.yamllint /work || YAML_EXIT=$?

echo
echo "=========================================="
echo "STEP 2: ansible-lint (production stack)"
echo "=========================================="
exec_in_controller ansible-lint /work/main.yaml /work/loki-role.yaml /work/promtail-role.yaml /work/grafana-role.yaml || LINT_EXIT=$?

echo
echo "=========================================="
echo "STEP 3: ansible-playbook --syntax-check"
echo "=========================================="
exec_in_controller ansible-playbook --syntax-check /work/main.yaml -i /work/test/inventory.ini
exec_in_controller ansible-playbook --syntax-check /work/loki-role.yaml -i /work/test/inventory.ini
exec_in_controller ansible-playbook --syntax-check /work/promtail-role.yaml -i /work/test/inventory.ini
exec_in_controller ansible-playbook --syntax-check /work/grafana-role.yaml -i /work/test/inventory.ini

echo
echo "=========================================="
echo "STEP 4: ansible -m ping (connectivity)"
echo "=========================================="
exec_in_controller ansible -i /work/test/inventory.ini cluster1 -m ping

echo
echo "=========================================="
echo "STEP 5: Full playbook run against target"
echo "=========================================="
exec_in_controller ansible-playbook -i /work/test/inventory.ini /work/main.yaml -v

echo
echo "=========================================="
echo "STEP 6: Verify services are running"
echo "=========================================="
docker exec "$TARGET_NAME" systemctl --no-pager status loki || true
docker exec "$TARGET_NAME" systemctl --no-pager status promtail || true
docker exec "$TARGET_NAME" systemctl --no-pager status grafana-server || true
docker exec "$TARGET_NAME" systemctl --no-pager status nginx || true
docker exec "$TARGET_NAME" curl -sf http://localhost:3100/ready && echo "Loki: ready" || echo "Loki: NOT ready"
docker exec "$TARGET_NAME" curl -sf http://localhost:9080/ready && echo "Promtail: ready" || echo "Promtail: NOT ready"
docker exec "$TARGET_NAME" curl -sf http://localhost:3000/api/health && echo "Grafana: ready" || echo "Grafana: NOT ready"
docker exec "$TARGET_NAME" curl -sf http://localhost:80/ -o /dev/null && echo "Nginx -> Uptime Kuma: ready" || echo "Nginx -> Uptime Kuma: NOT ready"

echo
echo "--- Test run complete ---"
