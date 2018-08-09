FROM alpine:3.8

LABEL maintainer="Chris Ruscio <chris.ruscio@allscripts.com>"

ENV SALT_LOG_LEVEL=debug

RUN apk add --no-cache openssl tini salt-master salt-minion \
 ## https://github.com/saltstack/salt/issues/47006
 && rm /usr/lib/python3.6/site-packages/salt/grains/__pycache__/*opt-1* \
 && rm -rf /var/cache/apk/* \
 && mkdir /etc/salt/minion.d \
 && mkdir /etc/salt/master.d

# COPY tcp.py.patch /tcp.py.patch
# RUN patch /usr/lib/python3.6/site-packages/salt/transport/tcp.py -i tcp.py.patch \
#  && rm /tcp.py.patch

COPY run.sh /usr/bin/run.sh
RUN  chmod +x /usr/bin/run.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/run.sh"]
