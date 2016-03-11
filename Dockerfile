FROM java:openjdk-7
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

ENV MD5 15c1f0937b9b8dd3ceca8f2418801b54

RUN mkdir -p /var/jenkins_home \
 && useradd -d /var/jenkins_home/worker -u 1000 -m -s /bin/bash jenkins \
 && curl -o /bin/swarm-client.jar -SL http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar \
 && echo "$MD5  /bin/swarm-client.jar" | md5sum -c -

COPY docker-entrypoint.sh /
WORKDIR /var/jenkins_home/worker

USER jenkins
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-Xmx2048m", "-jar", "/bin/swarm-client.jar", "-fsroot", "/var/jenkins_home/worker/"]
