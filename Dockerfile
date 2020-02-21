FROM crashvb/supervisord:202002211640
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

# Install packages, download files ...
ENV JBOSS_HOME=/usr/share/jboss
# Note: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir --parents ${JBOSS_HOME} /usr/share/man/man1 && \
	docker-apt gnupg openjdk-8-jdk-headless && \
	wget --quiet --output-document=- http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz | \
	tar --directory=${JBOSS_HOME} --extract --gzip --strip-components=1 && \
	wget --quiet --output-document=${JBOSS_HOME}/jboss-modules.jar https://repo1.maven.org/maven2/org/jboss/modules/jboss-modules/1.1.5.GA/jboss-modules-1.1.5.GA.jar

# Configure: jboss
RUN useradd --comment="JBoss Daemon" --home=${JBOSS_HOME} --shell=/bin/bash jboss && \
	chown --recursive jboss:jboss ${JBOSS_HOME}

# Configure: profile
RUN echo "export JBOSS_HOME=${JBOSS_HOME}" > /etc/profile.d/jboss && \
	chmod 0755 /etc/profile.d/jboss

# Configure: supervisor
ADD supervisord.jboss.conf /etc/supervisor/conf.d/jboss.conf

# Configure: entrypoint
ADD entrypoint.jboss /etc/entrypoint.d/10jboss

EXPOSE 8080/tcp
