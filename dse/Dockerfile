FROM       ubuntu:trusty
MAINTAINER Joaquin Casares <joaquin@datastax.com>

ENV DATASTAX_USER demos_datastax.com
ENV DATASTAX_PASS 6i8Cjv3lmdKqf01

# create a docker volume for cassandra data
VOLUME ["/var/lib/cassandra"]
VOLUME ["/var/log/cassandra"]


# ensure DataStax authentication is set
# setup repo key and repo sources list
COPY src/DataStax.key DataStax.key
RUN if [ -z "${DATASTAX_USER}" -o -z "${DATASTAX_PASS}" ] ; then \
        echo "Need to set DATASTAX_USER and DATASTAX_PASS." ; \
        exit 1 ; \
    else \
        apt-key add DataStax.key && \
        rm DataStax.key && \
        echo "deb http://"${DATASTAX_USER}":"${DATASTAX_PASS}"@debian.datastax.com/enterprise stable main" \
            | tee /etc/apt/sources.list.d/datastax.enterprise.list ; \
    fi


# install prereqs for add-apt-repository
RUN apt-get update && \
    apt-get install -y \
        python-software-properties \
        software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# install Oracle Java using WebUpd8's distribution
RUN add-apt-repository -y ppa:webupd8team/java && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && \
    apt-get install -y \
        oracle-java7-installer \
        oracle-java7-set-default && \
    rm -rf /var/lib/apt/lists/* && \
    update-java-alternatives -s java-7-oracle


# workaround for DSP-4225
RUN mv /sbin/sysctl /sbin/sysctl.real && \
    ln -s /bin/true /sbin/sysctl

# install dse and python to start the service
# sysstat for the datatax-agent
RUN apt-get update && \
    apt-get install -y \
        dse-full \
        python \
        sysstat && \
    rm -rf /var/lib/apt/lists/*


# stop service and clear data
RUN service dse stop && \
    rm -rf /var/lib/cassandra/*


# copy start scripts and set start CMD
COPY bin/start-dse /usr/local/bin/start-dse
RUN ls -lah /usr/local/bin/start-dse 


ENTRYPOINT ["/usr/local/bin/start-dse"]
