FROM crashvb/supervisord:latest
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

# Install packages, download files ...
ENV JBOSS_HOME=/usr/share/jboss
RUN docker-apt default-jdk-headless && \
	mkdir --parents ${JBOSS_HOME} && \
	wget --quiet --output-document=- http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz | \
	tar --directory=${JBOSS_HOME} --extract --gzip --strip-components=1 && \
	wget --quiet --output-document=${JBOSS_HOME}/jboss-modules.jar http://repo1.maven.org/maven2/org/jboss/modules/jboss-modules/1.1.5.GA/jboss-modules-1.1.5.GA.jar

# Configure: jboss
RUN useradd --comment="JBoss Daemon" --home=${JBOSS_HOME} --shell=/bin/bash jboss && \
	chown --recursive jboss:jboss ${JBOSS_HOME}

# Configure: supervisor
ADD supervisord.jboss.conf /etc/supervisor/conf.d/jboss.conf

# Configure: entrypoint
ADD entrypoint.jboss /etc/entrypoint.d/10jboss

EXPOSE 8080/tcp 8443/tcp
