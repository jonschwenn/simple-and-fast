#!/usr/bin/env bash
# Simple and Fast
set -eo pipefail

# SET THESE VARIABLES:
# ---------------------------------------------------------------------
# DigitalOcean API Token
DO_TOKEN=
# SSH Key ID
# List SSH Keys from API:
# https://developers.digitalocean.com/documentation/v2/#list-all-keys
SSH_KEY=
# This script assumes the region and Droplet size for simplicty
# ---------------------------------------------------------------------

deploy_lamp1 (){
  curl -X POST https://api.digitalocean.com/v2/droplets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -d '{"name":"lamp-1","region":"nyc1","size":"s-1vcpu-1gb","image":"lamp-16-04","ssh_keys":["'"$SSH_KEY"'"],"backups":false,"ipv6":true,"user_data":"
  #cloud-config
  runcmd:
    - echo Web-Server-1 > /var/www/html/index.html
    ","private_networking":"true","volumes": null,"tags":["web"]}'
  sleep 2
}

deploy_lamp2 (){
  curl -X POST https://api.digitalocean.com/v2/droplets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -d '{"name":"lamp-2","region":"nyc1","size":"s-1vcpu-1gb","image":"lamp-16-04","ssh_keys":["'"$SSH_KEY"'"],"backups":false,"ipv6":true,"user_data":"
  #cloud-config
  runcmd:
    - echo Web-Server-2 > /var/www/html/index.html
    ","private_networking":"true","volumes": null,"tags":["web"]}'
  sleep 2
}

deploy_lamp3 (){
  curl -X POST https://api.digitalocean.com/v2/droplets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -d '{"name":"lamp-3","region":"nyc1","size":"s-1vcpu-1gb","image":"lamp-16-04","ssh_keys":["'"$SSH_KEY"'"],"backups":false,"ipv6":true,"user_data":"
  #cloud-config
  runcmd:
    - echo Web-Server-3 > /var/www/html/index.html
    ","private_networking":"true","volumes": null,"tags":["web"]}'
  sleep 2
}

create_firewall(){
  curl -X POST  https://api.digitalocean.com/v2/firewalls\
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -d '{"name":"web-firewall","inbound_rules":[{"protocol":"tcp","ports":"22","sources":{"addresses":["0.0.0.0/0","::/0"]}}],"inbound_rules":[{"protocol":"tcp","ports":"80","sources":{"addresses":["0.0.0.0/0","::/0"]}}],"outbound_rules":[{"protocol":"tcp","ports":"80","destinations":{"addresses":["0.0.0.0/0","::/0"]}}],"droplet_ids":null,"tags":["web"]}'
  sleep 2
}

create_loadbalancer(){
  curl -X POST https://api.digitalocean.com/v2/load_balancers \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN"  \
  -d '{"name": "web-balancer", "region": "nyc1", "forwarding_rules":[{"entry_protocol":"http","entry_port":80,"target_protocol":"http","target_port":80,"certificate_id":"","tls_passthrough":false}, {"entry_protocol": "https","entry_port": 443,"target_protocol": "https","target_port": 443,"tls_passthrough": true}], "health_check":{"protocol":"http","port":80,"path":"/","check_interval_seconds":10,"response_timeout_seconds":5,"healthy_threshold":5,"unhealthy_threshold":3}, "sticky_sessions":{"type":"none"}, "tag": "web"}'
}

main() {
  deploy_lamp1 &&
  deploy_lamp2 &&
  deploy_lamp3 &&
  create_firewall &&
  create_loadbalancer
}

main "$@"
