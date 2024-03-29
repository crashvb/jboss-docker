FROM crashvb/supervisord:202303031721@sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68" \
	org.opencontainers.image.base.name="crashvb/supervisord:202303031721" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing jboss." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/jboss-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/jboss" \
	org.opencontainers.image.url="https://github.com/crashvb/jboss-docker"

# Install packages, download files ...
ENV JBOSS_HOME=/usr/share/jboss
# Note: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
# hadolint ignore=DL4006
RUN mkdir --parents ${JBOSS_HOME} /usr/share/man/man1 && \
	docker-apt gnupg openjdk-8-jdk-headless && \
	wget --quiet --output-document=- http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz | \
	tar --directory=${JBOSS_HOME} --extract --gzip --strip-components=1 && \
	wget --quiet --output-document=${JBOSS_HOME}/jboss-modules.jar https://repo1.maven.org/maven2/org/jboss/modules/jboss-modules/1.1.5.GA/jboss-modules-1.1.5.GA.jar

# Configure: jboss
RUN useradd --comment="JBoss Daemon" --home=${JBOSS_HOME} --shell=/bin/bash jboss && \
	chown --recursive jboss:jboss ${JBOSS_HOME}

# Configure: profile
RUN echo "export JBOSS_HOME=${JBOSS_HOME}" > /etc/profile.d/jboss.sh && \
	chmod 0755 /etc/profile.d/jboss.sh

# Configure: supervisor
COPY supervisord.jboss.conf /etc/supervisor/conf.d/jboss.conf

# Configure: entrypoint
COPY entrypoint.jboss /etc/entrypoint.d/jboss

# Configure: healthcheck
COPY healthcheck.jboss /etc/healthcheck.d/jboss

EXPOSE 8080/tcp
