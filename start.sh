#!/bin/bash

if [ -n "$NETWORK_HOST" ]; then
  sed -i "s/#network.host: 192.168.0.1/network.host: $NETWORK_HOST/" /etc/elasticsearch/elasticsearch.yml
fi

/usr/share/elasticsearch/bin/elasticsearch-systemd-pre-exec

exec "$@"
