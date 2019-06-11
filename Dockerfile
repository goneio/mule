FROM gone/php:cli
RUN apt-get -qq update && \
    apt-get -yq install --no-install-recommends \
        software-properties-common \
		gnupg \
        && \
    add-apt-repository -y ppa:linuxuprising/java && \
    apt-get -qq update && \
    apt-get -yq install --no-install-recommends \
        make \
        openssh-client \
        jq \
        xml-twig-tools \
        time \
        && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/cache/oracle-jdk11-installer

RUN apt-get -qq update && \
    echo oracle-java10-installer shared/accepted-oracle-license-v1-2 select true | debconf-set-selections && \
    apt-get -yq install --no-install-recommends \
        oracle-java11-installer \
        oracle-java11-set-default \
        && \
    java -version && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh && \
    curl \
        -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/cache/oracle-jdk11-installer

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]
