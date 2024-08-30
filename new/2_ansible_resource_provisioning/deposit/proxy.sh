#!/bin/bash

PROXY=$(cd ../1_resource_generation; terraform output -raw access-proxy_ip)
export HTTP_PROXY="socks5://$PROXY:1080"
export HTTPS_PROXY="socks5://$PROXY:1080"

exec "$@"