# Author -- meevs
# Creation Date -- 2023-02-27
# File Name -- Dockerfile
# Notes --

# Spigot Minecraft build
FROM alpine:latest AS spigot_build

# Build arguments
# --------------------
# Spigot control arguments
ARG SPIGOT_BUILD_DIR="/spigot_build"

# Java control arguments
ARG JAVA_VERSION="17"

# Minecraft control arguments
ARG MC_VERSION="1.20.1"

WORKDIR ${SPIGOT_BUILD_DIR}

RUN apk add --no-cache openjdk${JAVA_VERSION} curl git
RUN curl --location https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --output ./BuildTools.jar\
 && java -jar ./BuildTools.jar --rev ${MC_VERSION}

# Server setup
FROM alpine:latest as spigot_server

ARG USER="spigot"

# Build arguments
# --------------------
# Spigot control arguments
ARG SPIGOT_BUILD_DIR="/spigot_build"
ARG INSTALL_DIR="/home/${USER}/server"
ARG MC_EULA="true"

# Java control arguments
ARG JAVA_VERSION="17"
ARG MIN_RAM="2G"
ARG MAX_RAM="8G"

# Minecraft control arguments
ARG MC_VERSION="1.20.1"

# Environment variables
# --------------------
ENV USER="${USER}"

# Spigot control arguments
ENV SPIGOT_BUILD_DIR="${SPIGOT_BUILD_DIR}"
ENV INSTALL_DIR="${INSTALL_DIR}"

# Java control arguments
ENV JAVA_VERSION="${JAVA_VERSION}"
ENV MIN_RAM="${MIN_RAM}"
ENV MAX_RAM="${MAX_RAM}"

# Minecraft control arguments
ENV MC_VERSION="${MC_VERSION}"
ENV MC_EULA="true"

RUN apk add --no-cache openjdk${JAVA_VERSION}-jre
RUN adduser -D ${USER}\
	&& mkdir --parent "${INSTALL_DIR}"\
	&& chown --recursive "${USER}:${USER}" "${INSTALL_DIR}"

USER "${USER}"
WORKDIR "${INSTALL_DIR}"
RUN mkdir --parent "${INSTALL_DIR}/plugins"

COPY --from=spigot_build --chown="${USER}:${USER}" "${SPIGOT_BUILD_DIR}/spigot-${MC_VERSION}.jar" "${INSTALL_DIR}/"
COPY --chown="${USER}:${USER}" ./init_scripts/start_server.sh "${INSTALL_DIR}/start_server.sh"

# Ensure scripts are executable
RUN [ "chmod", "a+x", "./start_server.sh" ]

EXPOSE 25565/tcp

CMD [ "/bin/sh", "-c" ]
ENTRYPOINT [ "./start_server.sh" ]

