FROM java:openjdk-8

ENV GOSU_VERSION=1.10 \
    SWARM_VERSION=3.4 \
    MD5=63b3733b875ab4615e91e911a7d5fd45

# grab gosu for easy step-down from root
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates wget bzip2 \
 && rm -rf /var/lib/apt/lists/* \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true

# grab swarm-client.jar
RUN mkdir -p /var/jenkins_home \
 && useradd -d /var/jenkins_home/worker -u 1000 -m -s /bin/bash jenkins \
 && curl -o /bin/swarm-client.jar -SL https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$SWARM_VERSION/swarm-client-$SWARM_VERSION.jar \
 && echo "$MD5  /bin/swarm-client.jar" | md5sum -c -

COPY docker-entrypoint.sh /

VOLUME /var/jenkins_home/worker
WORKDIR /var/jenkins_home/worker

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-jar", "/bin/swarm-client.jar"]
