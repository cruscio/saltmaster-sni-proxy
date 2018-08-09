#!/usr/bin/env sh

#Master.d Config
echo "transport: ${SALT_TRANSPORT:-tcp}" > /etc/salt/master.d/transport.conf
if [[ "$SALT_TRANSPORT_TLS" = "enabled" ]]; then
  echo "ssl:" >> /etc/salt/master.d/transport.conf
  echo "  keyfile: /etc/tls/privkey.pem" >> /etc/salt/master.d/transport.conf
  echo "  certfile: /etc/tls/fullchain.pem" >> /etc/salt/master.d/transport.conf
  echo "  ssl_version: PROTOCOL_TLSv1_2" >> /etc/salt/master.d/transport.conf
fi
if [[ "$SALT_TRANSPORT_SNIOPTS" = "enabled" ]]; then
  echo "  has_sni: true" >> /etc/salt/master.d/transport.conf
  echo "  server_hostname: ${SALT_MASTER_ID:-salt}" >> /etc/salt/master.d/transport.conf
fi
echo "publish_port: ${SALT_PUBLISH_PORT:-4505}" >> /etc/salt/master.d/transport.conf
echo "ret_port: ${SALT_RETURN_PORT:-4506}" >> /etc/salt/master.d/transport.conf
echo "log_level: ${SALT_LOG_LEVEL:-debug}" > /etc/salt/minion.d/log_level.conf
echo "log_level_logfile: ${SALT_LOG_LEVEL:-debug}" >> /etc/salt/master.d/log_level.conf

#Minion.d Config
echo "transport: ${SALT_TRANSPORT:-tcp}" > /etc/salt/minion.d/transport.conf
if [[ "$SALT_TRANSPORT_TLS" = "enabled" ]]; then
  echo "ssl:" >> /etc/salt/minion.d/transport.conf
  echo "  ssl_version: PROTOCOL_TLSv1_2" >> /etc/salt/minion.d/transport.conf
fi
if [[ "$SALT_TRANSPORT_SNIOPTS" = "enabled" ]]; then
  echo "  has_sni: true" >> /etc/salt/minion.d/transport.conf
  echo "  server_hostname: ${SALT_MASTER_ID:-salt}" >> /etc/salt/minion.d/transport.conf
  echo "tcp_use_hostname: true" >> /etc/salt/minion.d/transport.conf
fi
echo "publish_port: ${SALT_PUBLISH_PORT:-4505}" >> /etc/salt/minion.d/transport.conf
echo "master_port: ${SALT_RETURN_PORT:-4506}" >> /etc/salt/minion.d/transport.conf
echo "master: ${SALT_MASTER_ID:-salt}" >> /etc/salt/minion.d/transport.conf
echo "log_level: ${SALT_LOG_LEVEL:-debug}" > /etc/salt/minion.d/log_level_logfile.conf
echo "log_level_logfile: ${SALT_LOG_LEVEL:-debug}" >> /etc/salt/minion.d/log_level_logfile.conf


if [[ "$SALT_MASTER" = "enabled" ]]; then
  /usr/bin/salt-master -l $SALT_LOG_LEVEL $@
else
  /usr/bin/salt-minion -l $SALT_LOG_LEVEL $@
fi
