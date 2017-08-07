# vim:set ft=dockerfile:
FROM debian:jessie

RUN apt-get update \
    && apt-get install -y wget \
    && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
    && apt-get install -y apt-transport-https \
    && echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list \
    && echo "deb http://ftp.de.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backport.list \
    && apt-get update \
    && apt-get -t jessie-backports -y install openjdk-8-jdk \
    && apt-get -y install elasticsearch \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove wget
RUN chown elasticsearch: /etc/elasticsearch/elasticsearch.yml \
    && chown elasticsearch: /etc/elasticsearch


ENV ES_HOME=/usr/share/elasticsearch
ENV CONF_DIR=/etc/elasticsearch
ENV DATA_DIR=/var/lib/elasticsearch
ENV LOG_DIR=/var/log/elasticsearch
ENV PID_DIR=/var/run/elasticsearch

WORKDIR /usr/share/elasticsearch
USER elasticsearch

EXPOSE 9200 9300
VOLUME ["/var/lib/elasticsearch"]
ADD ./start.sh /start.sh
ENTRYPOINT ["/start.sh"]
CMD ["/usr/share/elasticsearch/bin/elasticsearch", "-p", "${PID_DIR}/elasticsearch.pid", \
     "-Edefault.path.logs=${LOG_DIR}", "-Edefault.path.data=${DATA_DIR}", "-Edefault.path.conf=${CONF_DIR}"]
