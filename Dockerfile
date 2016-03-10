FROM java:openjdk-7
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

ENV MD5 41a24ed0a6c9998ab1d0864371f213e1

RUN mkdir -p /var/jenkins_home \
 && useradd -d /var/jenkins_home/worker -u 1000 -m -s /bin/bash jenkins \
 && curl -o /bin/swarm-client.jar -SL http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.22/swarm-client-1.22-jar-with-dependencies.jar \
 && echo "$MD5 /bin/swarm-client.jar" | md5sum -c -

COPY docker-entrypoint.sh /
WORKDIR /var/jenkins_home/worker

USER jenkins
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-Xmx2048m", "-jar", "/bin/swarm-client.jar", "-fsroot", "/var/jenkins_home/worker/"]
